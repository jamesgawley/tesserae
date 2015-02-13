#!/usr/bin/env perl

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

use CGI qw(:standard);

use POSIX;
use Storable qw(nstore retrieve);

# allow unicode output

binmode STDOUT, ":utf8";

# is the program being run from the web or
# from the command line?

my $query = CGI->new() || die "$!";

my $no_cgi = defined($query->request_method()) ? 0 : 1;

#
# command-line options
#

# print debugging messages to stderr?

my $quiet = 0;

# determine file from session id

my $target    = 'lucan.bellum_civile.part.1';
my $source    = 'vergil.aeneid.part.1';
my $unit_id   = 0;
my $topics    = 10;
my $threshold = 0.5;

#
# command-line arguments
#

GetOptions( 
	'target=s'    => \$target,
	'source=s'    => \$source,
	'unit_id=i'   => \$unit_id,
	'topics|n=i'  => \$topics,
	'threshold=f' => \$threshold,
	'quiet'       => \$quiet );

#
# cgi input
#

unless ($no_cgi) {
	
	my %h = ('-charset'=>'utf-8', '-type'=>'text/html');
	
	print header(%h);

	$target = $query->param('target')   || $target;
	$source = $query->param('source')   || $source;
	$unit_id = defined $query->param('unit_id') ? $query->param('unit_id') : $unit_id;
	$topics  = $query->param('topics')  || $topics;
	$threshold = defined $query->param('threshold') ? $query->param('threshold') : $threshold; 

	$quiet = 1;
}

#
# load texts
#

# abbreviations of canonical citation refs

my $file_abbr = catfile($fs{data}, 'common', 'abbr');
my %abbr = %{ retrieve($file_abbr) };

# language of input texts

my $lang = Tesserae::lang($target);

#
# source and target data
#

print STDERR "loading $target\n" unless ($quiet);

my $file = catfile($fs{data}, 'v3', $lang, $target, $target);

my @token = @{retrieve("$file.token")};
my @line  = @{retrieve("$file.line") };
my @bounds = @{retrieve(catfile($fs{data}, 'lsa', $lang, $target, 'bounds.small'))};
	
# validate selected id

if ($unit_id > $#bounds) {
   $unit_id = $#bounds;
} elsif ($unit_id < 0) {
   $unit_id = 0;
}

#
# highlighted phrase
#

my ($lbound, $rbound) = @{$bounds[$unit_id]};

#
# display the full text
# 

# create the table with the full text of the poem

my $table;

$table .= "<table class=\"fulltext\">\n";

for my $line_id (0..$#line) {

	$table .= "<tr>\n";
	$table .= "<td>$line[$line_id]{LOCUS}</td>\n";
	$table .= "<td>";
	
	for my $token_id (@{$line[$line_id]{TOKEN_ID}}) {
				
		if ($token[$token_id]{TYPE} eq 'WORD') {
				
			my $unit_id = $token[$token_id]{PHRASE_ID};
			
			my $marked = "";
			
			if ($token_id >= $lbound && $token_id <= $rbound) {
			
				$marked = "class=\"mark\"";
			}
			
			$table .= "<a href=\"$unit_id\"$marked>";
		}
		
		$table .= $token[$token_id]{DISPLAY};

		$table .= "</a>" if $token[$token_id]{TYPE} eq "WORD";
	}
	
	$table .= "</td>\n";
	$table .= "</tr>\n";
}

$table .= "</table>\n";

# send to browser

print $table;

