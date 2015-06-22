#!/usr/bin/env perl

#
# corpus-stats.pl
#
# create lists of most frequent tokens by rank order
# in order to calculate stop words
# and frequency-based scores

=head1 NAME

corpus-stats.pl	- calculate corpus-wide statistics

=head1 SYNOPSIS

perl corpus-stats.pl [options] LANG [LANG2 [...]]

=head1 DESCRIPTION

Calculates corpus-wide frequencies for all features.

=head1 OPTIONS AND ARGUMENTS

=over

=item B<--help>

Print usage and exit.

=back

=head1 KNOWN BUGS

=head1 SEE ALSO

I<add_column.pl> - add texts to the database

=head1 COPYRIGHT

University at Buffalo Public License Version 1.0.
The contents of this file are subject to the University at Buffalo Public License Version 1.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at http://tesserae.caset.buffalo.edu/license.txt.

Software distributed under the License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for the specific language governing rights and limitations under the License.

The Original Code is corpus-stats.pl.

The Initial Developer of the Original Code is Research Foundation of State University of New York, on behalf of University at Buffalo.

Portions created by the Initial Developer are Copyright (C) 2007 Research Foundation of State University of New York, on behalf of University at Buffalo. All Rights Reserved.

Contributor(s): Chris Forstall

Alternatively, the contents of this file may be used under the terms of either the GNU General Public License Version 2 (the "GPL"), or the GNU Lesser General Public License Version 2.1 (the "LGPL"), in which case the provisions of the GPL or the LGPL are applicable instead of those above. If you wish to allow use of your version of this file only under the terms of either the GPL or the LGPL, and not to allow others to use your version of this file under the terms of the UBPL, indicate your decision by deleting the provisions above and replace them with the notice and other provisions required by the GPL or the LGPL. If you do not delete the provisions above, a recipient may use your version of this file under the terms of any one of the UBPL, the GPL or the LGPL.

=cut

use strict;
use warnings;

#
# Read configuration file
#

# modules necessary to read config file

use Cwd qw/abs_path/;
use File::Spec::Functions;
use FindBin qw/$Bin/;

# read config before executing anything else

my $lib;

BEGIN {

	# look for configuration file
	
	$lib = $Bin;
	
	my $oldlib = $lib;
	
	my $pointer;
			
	while (1) {

		$pointer = catfile($lib, '.tesserae.conf');
	
		if (-r $pointer) {
		
			open (FH, $pointer) or die "can't open $pointer: $!";
			
			$lib = <FH>;
			
			chomp $lib;
			
			last;
		}
									
		$lib = abs_path(catdir($lib, '..'));
		
		if (-d $lib and $lib ne $oldlib) {
		
			$oldlib = $lib;			
			
			next;
		}
		
		die "can't find .tesserae.conf!\n";
	}
	
	$lib = catdir($lib, 'TessPerl');	
}

# load Tesserae-specific modules

use lib $lib;
use Tesserae;
use EasyProgressBar;

# modules to read cmd-line options and print usage

use Getopt::Long;
use Pod::Usage;

# load additional modules necessary for this script

use Storable qw(nstore retrieve);

# initialize some variables

my @feature;
my @lang;
my $use_lingua_stem = 0;
my $help = 0;
my $quiet = 0;

# get user options

GetOptions(
	'help'      => \$help,
	'quiet'     => \$quiet,
	'feature=s' => \@feature,
    'use-lingua-stem' => \$use_lingua_stem
);

# print usage if the user needs help
	
if ($help) {
	pod2usage(1);
}

#
# initialize stemmer
#

if ($use_lingua_stem) {

	Tesserae::initialize_lingua_stem();
}

#
# allow utf8 output to STDERR
#

binmode STDERR, ':utf8';

#
# specify language to parse at cmd line
#

for (@ARGV) {

	$_ = lc($_);

	if (/^[a-z]{1,4}$/)	{ 
	
		next unless -d catdir($fs{data}, 'v3', $_);
		push @lang, $_;
	}
}

print STDERR "lang: " . join(" ", @lang) . "\n" unless $quiet;
print STDERR "feature: " . join(" ", @feature) . "\n" unless $quiet;

#
# main loop
#

# word counts come from documents already parsed.
# stem counts are based on word counts, but also 
# use the cached stem dictionary
#

for my $lang (@lang) {
	
	# get a list of all the word counts

	my @text = @{Tesserae::get_textlist($lang, -no_part => 1)};
	
    my $base = catfile($fs{data}, "common", $lang);
    
    #
    # get word counts 
    #
    print STDERR "Getting word counts\n" unless $quiet;
    my %word_index = %{get_tallies($lang, 'word', \@text)};
    write_tallies("$base.word.freq", \%word_index);
    
	#
	# do feature counts
	#

	for my $feat (@feature) {
        # first the straight feature count
		print STDERR "Getting $feat counts\n" unless $quiet;
        my %feature_index = %{get_tallies($lang, $feat, \@text)};
        write_tallies("$base.$feat.freq", \%feature_index);
        
        # now the "word by feature" count used for scoring
        print STDERR " -> word by $feat\n" unless $quiet;
        my %word_by_feature;
        my $pr = ProgressBar->new(scalar(keys %word_index), $quiet);
        for my $word (keys %word_index) {
            $pr->advance;
            next if $word =~ /^__/;
            
            my @indexable = @{Tesserae::feat($lang, $feat, $word)};
            my ($sum, $count);
            for (@indexable) {
                unless (defined $feature_index{$_}) { print STDERR "no feature count: $_\n";}
                $sum += $feature_index{$_};
                $count ++;
            }
            $word_by_feature{$word} = sprintf("%0f", $sum/$count);
        }
        $word_by_feature{__TOTAL__} = $feature_index{__TOTAL__};
        
        write_tallies("$base.$feat.freq_score", \%word_by_feature);
	}
}


sub get_tallies {
    my ($lang, $feature, $list_ref) = @_;
    my @texts = @$list_ref;
    my $total;
    my %tally;

    my $pr = ProgressBar->new(scalar(@texts), $quiet);

	for my $text (@texts) {	
        $pr->advance;
        
		my $file_index = catfile($fs{data}, 'v3', $lang, $text, "$text.index_$feature");

		next unless -s $file_index;

		my %index = %{retrieve($file_index)};

		for (keys %index) {
            my $this_count = scalar(@{$index{$_}});
			$tally{$_} += $this_count;
			$total += $this_count;
		}
    }
    $pr->finish;
    
    $tally{__TOTAL__} = $total;
    
    return \%tally;
}

sub write_tallies {
    my ($file, $index_ref) = @_;
    my %tally = %$index_ref;
    
	print STDERR "writing $file\n";

	open (FREQ, ">:utf8", $file) or die "can't write $file: $!";

	print FREQ "# count: $tally{__TOTAL__}\n";
	
	for (sort {$tally{$b} <=> $tally{$a}} grep {!/^__/} keys %tally) {
		print FREQ sprintf("%s\t%i\n", $_, $tally{$_});
	}

	close FREQ;
}

sub read_tallies {
    my $file = shift;
    my %tally;
    
    open (my $fh, "<:utf8", $file) or die;
    
    my $head = <$fh>;
    $head =~ /count: (\d+)/ or die;
    $tally{__TOTAL__} = $1;
    
    while (my $line = <$fh>) {
        if ($line =~ /(\w+)\s+(\d+)/) {
            $tally{$1} = $2;
        }
    }
    
    return \%tally;
}