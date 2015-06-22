#!/usr/bin/env perl

=head1 NAME

lsa.target.pl - display target text for lsa search interface

=head1 SYNOPSIS

lsa.target.pl [options] --source SOURCE --target TARGET

=head1 DESCRIPTION

Loads the target text and displays it with the query phrase highlighted.
Intended to be invoked via the web interface.

=head1 OPTIONS AND ARGUMENTS

=over

=item --source I<SOURCE>

The source, (or "corpus") text.

=item --target I<TARGET>

The target, (or "query") text.

=item --unit_id I<N>

The phrase id from the target text to use as our search query.

=item --threshold I<FLOAT>

The similarity threshold above which something counts as a "hit". Default is
0.5.

=item B<--quiet>

Don't print debugging info to stderr.

=item B<--help>

Print usage and exit.

=back

=head1 KNOWN BUGS

=head1 SEE ALSO

=head1 COPYRIGHT

University at Buffalo Public License Version 1.0. The contents of this file are
subject to the University at Buffalo Public License Version 1.0 (the
"License"); you may not use this file except in compliance with the License.
You may obtain a copy of the License at
http://tesserae.caset.buffalo.edu/license.txt.

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is lsa.target.pl.

The Initial Developer of the Original Code is Research Foundation of State
University of New York, on behalf of University at Buffalo.

Portions created by the Initial Developer are Copyright (C) 2007 Research
Foundation of State University of New York, on behalf of University at Buffalo.
All Rights Reserved.

Contributor(s): Chris Forstall <cforstall@gmail.com>

Alternatively, the contents of this file may be used under the terms of either
the GNU General Public License Version 2 (the "GPL"), or the GNU Lesser General
Public License Version 2.1 (the "LGPL"), in which case the provisions of the
GPL or the LGPL are applicable instead of those above. If you wish to allow use
of your version of this file only under the terms of either the GPL or the
LGPL, and not to allow others to use your version of this file under the terms
of the UBPL, indicate your decision by deleting the provisions above and
replace them with the notice and other provisions required by the GPL or the
LGPL. If you do not delete the provisions above, a recipient may use your
version of this file under the terms of any one of the UBPL, the GPL or the
LGPL.
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

use CGI qw(:standard);
use LWP::UserAgent;

use POSIX;
use Storable qw(nstore retrieve);

# initialize some variables

my $help = 0;
my $quiet = 0;
my $target = 'lucan.bellum_civile.part.1';
my $source = 'vergil.aeneid.part.1';
my $unit_id = 0;
my $threshold = .5;
my $topics = 10;

# allow unicode output

binmode STDOUT, ":utf8";

# is the program being run from the web or
# from the command line?

my $query = CGI->new() || die "$!";

my $no_cgi = defined($query->request_method()) ? 0 : 1;

if ($no_cgi) {
    # command-line arguments

    GetOptions( 
	    'target=s' => \$target,
        'source=s' => \$source,
        'unit_id|i=i' => \$unit_id,
        'topics|n=i' => \$topics,
        'threshold=f' => \$threshold,
        'quiet' => \$quiet,
        'help' => \$help
    );
    
    # print help if user needs help
    pod2usage(1) if ($help);
    
} else {
    # cgi input
    
	my %h = ('-charset'=>'utf-8', '-type'=>'text/html');
	
	print header(%h);

	$target    = $query->param('target')   || $target;
	$source    = $query->param('source')   || $source;
	$unit_id   = defined $query->param('unit_id') ? $query->param('unit_id') : $unit_id;
	$topics    = $query->param('topics')   || $topics;
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
