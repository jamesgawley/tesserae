#!/usr/bin/env perl

=head1 NAME

build-stem-cache.pl - create stem dictionaries

=head1 SYNOPSIS

build-stem-cache.pl I<LANG> [I<LANG> ...]

=head1 DESCRIPTION

Reads in Helma Dik's dictionaries in CSV format, parses them, and then
saves the data in Storable binary format.

=head1 OPTIONS AND ARGUMENTS

=over

=item I<LANG>

Languages to set up. 

=item B<--help>

Print usage and exit.

=back

=head1 KNOWN BUGS

See notes to B<init.pl> on English stems.

=head1 SEE ALSO

=head1 COPYRIGHT

University at Buffalo Public License Version 1.0. The contents of this file
are subject to the University at Buffalo Public License Version 1.0 (the
"License"); you may not use this file except in compliance with the License.
You may obtain a copy of the License at
http://tesserae.caset.buffalo.edu/license.txt.

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is build-stem-cache.pl.

The Initial Developer of the Original Code is Research Foundation of State
University of New York, on behalf of University at Buffalo.

Portions created by the Initial Developer are Copyright (C) 2007 Research
Foundation of State University of New York, on behalf of University at
Buffalo. All Rights Reserved.

Contributor(s): Chris Forstall <cforstall@gmail.com>

Alternatively, the contents of this file may be used under the terms of
either the GNU General Public License Version 2 (the "GPL"), or the GNU
Lesser General Public License Version 2.1 (the "LGPL"), in which case the
provisions of the GPL or the LGPL are applicable instead of those above. If
you wish to allow use of your version of this file only under the terms of
either the GPL or the LGPL, and not to allow others to use your version of
this file under the terms of the UBPL, indicate your decision by deleting the
provisions above and replace them with the notice and other provisions
required by the GPL or the LGPL. If you do not delete the provisions above, a
recipient may use your version of this file under the terms of any one of the
UBPL, the GPL or the LGPL.

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
use Encode;

#
# initialize some parameters
#

my @lang = @ARGV ? @ARGV : qw/la/;

my $quiet = 0;

# command-line options

GetOptions(
	'quiet'  => \$quiet);

#
# process each language
#

for my $lang (@lang) {

	my $file_csv   = catfile($fs{data}, 'common', "$lang.lexicon.csv");
	my $file_cache = catfile($fs{data}, 'common', "$lang.stem.cache");
	
	my %stem;
	
	print STDERR "reading csv file: $file_csv\n" unless $quiet;
	
	open (FH, "<:utf8", $file_csv) || die "can't open csv: $!";
	
	my $pr = ProgressBar->new(-s $file_csv, $quiet);
	
	while (my $line = <FH>) {
		
		$pr->advance(length(Encode::encode('utf8', $line)));
	
		# NOTE:
		# what's the significance of quotation marks?
		
		$line =~ s/"//g;
		
		# remove newline
	
		chomp $line;
		
		# split on commas
		
		my @field = split /,/, $line;
		
		my ($token, $grammar, $headword) = @field[0..2];
		
		# standardize the forms
		
		$token = Tesserae::standardize($lang, $token);
		
		$headword = Tesserae::standardize($lang, $headword);
		
		# add to dictionary
		
		push @{$stem{$token}}, $headword;
	}
	
	close FH;
	
	print STDERR "rationalizing headwords...\n" unless $quiet;
	
	$pr = ProgressBar->new(scalar(keys %stem), $quiet);
	
	for my $headword (keys %stem) {
	
		$pr->advance();
	
		my %uniq;
		
		for (@{$stem{$headword}}) {
	
			$uniq{$_} = 1;
		}
			
		$stem{$headword} = [(keys %uniq)];
		
	}
	
	print STDERR "saving: $file_cache" unless $quiet;
	
	nstore \%stem, $file_cache;
	
	print STDERR "\n" unless $quiet;
}