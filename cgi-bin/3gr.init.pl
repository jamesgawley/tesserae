#!/usr/bin/env perl

=head1 NAME

3gr.init.pl - start a trigram viewing session

=head1 SYNOPSIS

3gr.init.pl [options] NAME

=head1 DESCRIPTION

Initializes a new trigram viewing session by pre-calculating the concentrations
of a selected number of trigrams and saving the values to a temporary directory.
Intented to be called from the web interface.

=head1 OPTIONS AND ARGUMENTS

=over

=item I<NAME>

The text to analyse.

=item --unit I<STRING>

Textual unit to consider. Choices are 'line' or 'phrase'; default is 'line'.

=item --top I<N>

How many trigrams to consider. Takes the N most frequent. Default is 10.

=item --keys I<TRIGRAM>[,I<TRIGRAM>,...]

User-specified trigrams to calculate, separated by commas but not spaces.

=item --memory I<N>

How many subsequent units after one in which a given sound occurs will its 
effect continue to be felt? Default is 10.

=item --decay I<FLOAT>

Factor controlling how quickly the strength of a sound decreases in the memory
effect. Default is 0.5.

=item B<--quiet>

Don't print debugging info to stderr.

=item B<--help>

Print usage and exit.

=back

=head1 KNOWN BUGS

The way these scripts work is pretty crazy; this should all be redone without
CGI::Session, and my opinion, ideally doing most of the calculation on the
client side in Javascript. You could just request the 3-gram values as raw
JSON data, and not bother trying to store persistent pre-calculated data on
the server side.

=head1 SEE ALSO

3gr.display.pl, 3gr.session.pl

=head1 COPYRIGHT

University at Buffalo Public License Version 1.0.
The contents of this file are subject to the University at Buffalo Public License Version 1.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at http://tesserae.caset.buffalo.edu/license.txt.

Software distributed under the License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for the specific language governing rights and limitations under the License.

The Original Code is 3gr.init.pl.

The Initial Developer of the Original Code is Research Foundation of State University of New York, on behalf of University at Buffalo.

Portions created by the Initial Developer are Copyright (C) 2007 Research Foundation of State University of New York, on behalf of University at Buffalo. All Rights Reserved.

Contributor(s): Chris Forstall <cforstall@gmail.com>

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


use CGI::Session;
use CGI qw/:standard/;
use Storable qw(nstore retrieve);
use File::Path qw(mkpath rmtree);

#
# initialize set some parameters
#

# text to parse 

my $target = 0;

# unit

my $unit = 'line';

# length of memory effect in units

my $memory = 10;

# used to calculated the decay exponent

my $decay = .5;

# print debugging messages to stderr?

my $quiet = 0;

# 3-grams to look for; if empty, use all available

my $keys = 0;

# choose top n 3-grams

my $top = 10;

# for progress bars

my $pr;

# abbreviations of canonical citation refs

my $file_abbr = catfile($fs{data}, 'common', 'abbr');
my %abbr = %{retrieve($file_abbr)};

# language database

my $file_lang = catfile($fs{data}, 'common', 'lang');
my %lang = %{retrieve($file_lang)};

#
# check for cgi interface
#

my $cgi = CGI->new() || die "$!";
my $session;

my $no_cgi = defined($cgi->request_method()) ? 0 : 1;

if ($no_cgi) {
    # get options from command-line 
    
	GetOptions( 
		'unit=s'       => \$unit,
		'decay=f'      => \$decay,
		'keys=s'       => \$keys,
		'top=i'        => \$top,
		'memory=i'     => \$memory,
		'quiet'        => \$quiet );
		
	$target = shift @ARGV;
    
} else {
    # create new cgi session,
    # print html header, if necessary

	$session = CGI::Session->new(undef, $cgi, {Directory => '/tmp'});
	
	my $cookie = $cgi->cookie(CGISESSID => $session->id );

	print header(-cookie=>$cookie, -encoding=>"utf8");

	$target = $cgi->param('target');
	$unit   = $cgi->param('unit')     || $unit;
	$decay  = $cgi->param('decay')    || $decay;
	$keys   = $cgi->param('keys')     || $keys;
	$top    = $cgi->param('top')      || $top;
	$memory = $cgi->param('memory')   || $memory;

	$session->save_param($cgi);

	$quiet  = 1;
	
	print <<END;

<html>
	<head>
		<title>Tesserae results</title>
		<link rel="stylesheet" type="text/css" href="/css/style.css" />
		<meta http-equiv="Refresh" content="0; url='/cgi-bin/3gr.display.pl'">
	</head>
	<body>
		<div class="waiting">
END

}

#
# bail out if no target selected
# or if needed files aren't present
#

unless ($target) {

	die "no target specified";
}

unless (defined $lang{$target}) {

	die "target $target has no entry in the language database";
}

my $file = catfile($fs{data}, 'v3', $lang{$target}, $target, $target);

for ('token', 'index_3gr', $unit) {

	unless (-s "$file.$_") {
	
		die "can't read $file.$_: $!";
	}
}

#
# read the files
#

print STDERR "loading $target\n" unless $quiet;

my @token = @{retrieve("$file.token")};

my @unit  = @{retrieve("$file.$unit")};

my %index = %{retrieve("$file.index_3gr")};

#
# set up the matrix of 3-gram frequencies
#

my @matrix;
$#matrix = $#unit;

# tally n-gram occurrences; used to choose funcional ngrams

my %count;

# user-selected set of keys

my @keys = $keys ? split(/,/, $keys) : keys(%index);

# max values for each column; used for scaling

my %max;
@max{@keys} = (0)x($#keys+1);

#
# get 3-gram counts from the index
#

# progress bar

if ($no_cgi) {

	print STDERR "Calculating n-gram count matrix\n" unless $quiet;	
	print STDERR "Initial counts\n" unless $quiet;

	$pr = ProgressBar->new(scalar(@keys), $quiet);
}
else {

	print "<p>Calculating n-gram count matrix</p>\n";
	print "<p>Initial counts</p>\n";

	$pr = HTMLProgress->new(scalar(@keys));
}

for my $key (@keys) {

	$pr->advance();

	for my $token_id (@{$index{$key}}) {
	
		my $unit_id = $token[$token_id]{uc($unit) . "_ID"};
		
		$matrix[$unit_id]{$key}++;
		
		$count{$key} ++;
	}
}

$pr->finish();

#
# add in the effect of earlier lines
#

# progress bar

if ($no_cgi) {

	print STDERR "Memory effect\n" unless $quiet;

	$pr = ProgressBar->new($#matrix, $quiet);
}
else {

	print "<p>Memory effect</p>\n";

	$pr = HTMLProgress->new($#matrix);
}

for (my $unit_id = $#matrix; $unit_id >= 0; $unit_id--) {

	$pr->advance();

	my $first = $unit_id < $memory ? 0 : ($unit_id - $memory);
	
	for my $i ($first..$unit_id-1) {
	
		for my $key (keys %{$matrix[$i]}) {
		
			$matrix[$unit_id]{$key} += $matrix[$i]{$key}/($unit_id-$i) ** $decay;
			
			if ($matrix[$unit_id]{$key} > $max{$key}) {
			
				$max{$key} = $matrix[$unit_id]{$key};
			}
		}
	}	
}

$pr->finish();

#
# select functional ngrams if top set
#

@keys  = sort {$count{$b} <=> $count{$a}} keys %count;

if ($top and $top > 0 and $top < ($#keys-1)) {

	if ($no_cgi) {
	
		print STDERR "Selecting $top functional 3-grams\n";
	}
	else {
	
		print "<p>Selecting $top functional 3-grams</p>\n";
	}

	$#keys = $top - 1
}

#
# convert from array of hashes to array of arrays
#

for (@matrix) {

	my @row = map { $_ || 0 } @{$_}{@keys};

	$_ = \@row;
}

#
# export the matrix
#

if ($no_cgi) {

	print STDERR "Exporting matrix\n" unless $quiet;
	
	$pr = ProgressBar->new($#matrix+1, $quiet);
	
	print join("\t", @keys) . "\n";
	
	for my $i (0..$#matrix) {
	
		$pr->advance();
	
		print join("\t", $i, @{$matrix[$i]}) . "\n";		
	}
	
	$pr->finish();
}
else {

	print "<p>Saving matrix data</p>\n";

	$session->param('matrix', \@matrix);
	$session->param('keys',   \@keys);
	$session->param('maxval', [@max{@keys}]);
	
	print <<END;
	
			Your search is done.  If you are not redirected automatically, <a href="/cgi-bin/3gr.display.pl">click here.</a>
		</div>
	</body>
</html>
END

}