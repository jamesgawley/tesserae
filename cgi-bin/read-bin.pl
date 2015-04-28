#!/usr/bin/env perl

=head1 NAME

read_bin.pl - Sort and format the results of a Tesserae search.

=head1 SYNOPSIS

B<read_bin.pl> [OPTIONS] <I<name> | B<--session> I<session_id>>

=head1 DESCRIPTION

This script reads the directory of binary files produced by I<read_table.pl> and presents the results to the user.  It's usually run behind the scenes to create the paged HTML tables seen from the web interface, but it can also be run from the command-line, and can format results as plain text or XML as well as HTML.

It takes as its argument the I<name> of the results saved by I<read_table.pl>--that is "tesresults," or whatever was specified using the B<--binary> flag.  Alternatively you may specify the I<session_id> of a previous web session.  Output is dumped to STDOUT.

Options:

=over

=item B<--sort> target|source|score

Which column to sort the results table by.  B<target> (the default) sorts by location in the target text, B<source>, by location in the source text, and B<score> sorts by the Tesserae-assigned score.

=item B<--batch> I<page_size>

For paged results, I<page_size> gives the number of results per page. The default is 100.  If you say B<all> here instead of a number, you'll get all the results on one page.

=item B<--page> I<page_no>

For paged results, I<page_no> gives the page to display.  The default is 1.

=item B<--export> html|tab|csv|xml

How to format the results.  The default is B<html>.  I<tab> and I<csv> are similar: both produce plain text output, with one parallel to a line, and fields either separated by either tabs or commas.  Tab- and comma-separated results are not paged, but will be sorted according to the values of B<--sort> and B<--rev>. XML results are neither paged nor sorted (actually, they're always sorted by target).

If you want to import the results into Microsoft Excel, I<tab> seems to work best.

=item B<--session> I<session_id>

When this option is given, the results are read not from a local, named session, but rather from a previously-created session file in C<tmp/> having id I<session_id>.  This is useful if the results you want to read were generated from the web interface.

=item B<--quiet>

Don't write progress info to STDERR.

=item B<--help>

Print this message and exit.

=back

=head1 EXAMPLE

Presuming that you had previously run read_table.pl using the default name "tesresults" for your output:

% cgi-bin/read_bin.pl --export tab tesresults > results.txt

=head1 SEE ALSO

I<cgi-bin/read_table.pl>

=head1 COPYRIGHT

University at Buffalo Public License Version 1.0.
The contents of this file are subject to the University at Buffalo Public License Version 1.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at http://tesserae.caset.buffalo.edu/license.txt.

Software distributed under the License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for the specific language governing rights and limitations under the License.

The Original Code is read_bin.pl.

The Initial Developer of the Original Code is Research Foundation of State University of New York, on behalf of University at Buffalo.

Portions created by the Initial Developer are Copyright (C) 2007 Research Foundation of State University of New York, on behalf of University at Buffalo. All Rights Reserved.

Contributor(s): Neil Coffee, Chris Forstall, James Gawley.

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
use utf8;

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
use Encode;
use JSON;

# allow unicode output

binmode STDOUT, ":utf8";
binmode STDERR, ":utf8";

# is the program being run from the web or
# from the command line?

my $query = CGI->new() || die "$!";

my $no_cgi = defined($query->request_method()) ? 0 : 1;

#
# command-line options
#

# print debugging messages to stderr?
my $quiet = 0;

# sort algorithm
my $sort = 'score';

# first page of results to display
my $page = 1;

# how many results on a page? (0 = all on one page)
my $batch = 0;

# determine file from session id
my $session;

# format for results
my $export = "tab";

# score cutoff
my $cutoff = 8;

# number of decimal places to report in scores
my $dec = 0;

# help flag
my $help;


if ($no_cgi) {
   # command-line arguments

   GetOptions(
      'sort=s'    => \$sort,
      'page=i'    => \$page,
      'batch=i'   => \$batch,
      'session=s' => \$session,
      'export=s'  => \$export,
      'cutoff=f'  => \$cutoff,
      'decimal=i' => \$dec,
      'quiet'     => \$quiet,
      'help'      => \$help 
   );

   # if help requested, print usage
   if ($help) {
      pod2usage( -verbose => 2 );
   }

} else {
   # cgi arguments

	$session    = $query->param('session') || die "no session specified from web interface";
   $dec        = $query->param('decimal') || $dec;
   $cutoff     = $query->param('cutoff')  || $cutoff;
	$sort       = $query->param('sort')    || $sort;
	$page       = $query->param('page')    || $page;
	$batch      = $query->param('batch')   || $batch;
	$export     = $query->param('export')  || $export;

	my %h = ('-charset'=>'utf-8', '-type'=>'text/html');

   if ($export eq "tab") { 
      $h{'-type'} = "text/plain"; 
      $h{'-attachment'} = "tesresults-$session.txt" 
   } elsif ($export eq "json") { 
      $h{'-type'} = "application/json"; 
      $h{'-attachment'} = "tesresults-$session.json";
   } elsif ($export eq "csv") { 
      $h{'-type'} = "text/csv"; 
      $h{'-attachment'} = "tesresults-$session.csv" 
   }
   
	print header(%h);

	$quiet = 1;
}

# locate session data
my $file;

if (defined $session) {
	$file = catdir($fs{tmp}, "tesresults-" . $session);
} else {
	$file = shift @ARGV;
}


# abbreviations of canonical citation refs

my $file_abbr = catfile($fs{data}, 'common', 'abbr');
my %abbr = %{retrieve($file_abbr)};


#
# load the search results
#

my %meta = %{retrieve(catfile($file, "match.meta"))};

# sort results
my @rec = @{load_results($file)};

# add metadata about cutoff, total results before paging
$meta{CUTOFF} = $cutoff;
$meta{TOTAL} = scalar(@rec);

# page them
my ($first, $last) = page($batch, $page);
splice(@rec, $last+1);
splice(@rec, 0, $first);

# convert token ids to actual text for display
add_phrase_text();

# add metadata about paging
$meta{PAGE} = $page;
$meta{PAGESIZE} = $batch;

#
# output
#

for ($export) {
   m/tab/  && print_delim("\t");
   m/csv/  && print_delim(",");
   m/json/ && print_json();
}


#
# subroutines
#

sub load_results {
   my ($file) = @_;
   
   print STDERR "Reading session data $session\n" unless $quiet;

   my %match_target = %{retrieve(catfile($file, "match.target"))};
   my %match_source = %{retrieve(catfile($file, "match.source"))};
   my %match_score = %{retrieve(catfile($file, "match.score"))};
   
	my @rec;
   my $n = 1;

	for my $unit_id_target (sort {$a <=> $b} keys %match_score) {

		for my $unit_id_source (sort {$a <=> $b} keys %{$match_score{$unit_id_target}}) {

         # round scores
         my $score = sprintf("%.${dec}f", $match_score{$unit_id_target}{$unit_id_source});
         
         # check cutoff
         if ($score >= $cutoff) {
            
            # track which tokens, features occur in this match
      		my %marked_target;
      		my %marked_source;
      		my %seen_keys;

      		for (keys %{$match_target{$unit_id_target}{$unit_id_source}}) {

      			$marked_target{$_} = 1;

      			$seen_keys{join("-", sort keys %{$match_target{$unit_id_target}{$unit_id_source}{$_}})} = 1;
      		}

      		for (keys %{$match_source{$unit_id_target}{$unit_id_source}}) {

      			$marked_source{$_} = 1;

      			$seen_keys{join("-", sort keys %{$match_source{$unit_id_target}{$unit_id_source}{$_}})} = 1;
      		}
            
            push @rec, {
               n => $n,
               unit_target => $unit_id_target, 
               unit_source => $unit_id_source,
               marked_target => [sort {$a <=> $b} keys %marked_target],
               marked_source => [sort {$a <=> $b} keys %marked_source],
               score => $score,
               features => [sort keys %seen_keys]
            };
            
            $n++;
         }
		}
	}
   
   # sorting

	@rec = sort {$b->{score} <=> $a->{score}} @rec;

	if ($sort eq "source") {

		@rec = sort {$a->{unit_source} <=> $b->{unit_source}} @rec;
	}
	if ($sort eq "target") {

		@rec = sort {$a->{unit_target} <=> $b->{unit_target}} @rec;
	}
   
   return \@rec;
}

sub add_phrase_text {
   
   for my $dest (qw/target source/) {
      
      my $name = $meta{uc($dest)};
      print STDERR "Reading text $name\n" unless $quiet;
      
      my $base = catfile($fs{data}, 'v3', Tesserae::lang($name), $name, $name);

      my @token = @{ retrieve( "$base.token"    ) };
      my @unit = @{ retrieve( "$base.$meta{UNIT}" ) };
      my %index = %{ retrieve( "$base.index_$meta{FEATURE}" ) };
      
      for my $rec (@rec) {
         $rec->{"loc_$dest"} = join(" ", $abbr{$name}, $unit[$rec->{"unit_$dest"}]{LOCUS});
         my @token_id = @{$unit[$rec->{"unit_$dest"}]{TOKEN_ID}};
         my %marked_id = map {$_ => 1} @{$rec->{"marked_$dest"}};
         
         my @display;
         my @marked_pos;
         
         for my $i (0..$#token_id) {
            my $id = $token_id[$i];
            
            push @display, $token[$id]{DISPLAY};
            if (defined $marked_id{$id}) {
               push @marked_pos, $i;
            }
         }
         
         $rec->{"display_$dest"} = \@display;
         $rec->{"marked_$dest"} = \@marked_pos;
      }
   }
}

sub page {
   my ($pagesize, $page) = @_;
   
   if ($pagesize < 1) {
      return (0, $#rec);
   }

   my $npages = ceil(scalar(@rec)/$pagesize) || 1;

   if ($page > $npages) {
      $page = $npages;
   } elsif ($page < 1) {
      $page = 1;
   }

   my $first = ($page-1) * $pagesize;
   my $last = $first + $pagesize - 1;

   if ($last > $#rec) {
      $last = $#rec;
   }
         
   return($first, $last)
}

sub display {
   my ($rec, $before, $after) = @_;
   
   my @phrases;
   
   for my $dest (qw/target source/) {
      my @display = @{$rec->{"display_$dest"}};
      my @marked = @{$rec->{"marked_$dest"}};
      
      @display[@marked] = map {join("", $before, $_, $after)} @display[@marked];
      
      push @phrases, join("", @display);
   }
   
   return @phrases;
}

sub print_delim {

	my $delim = shift;
   
   print STDERR "Exporting " . scalar(@rec) . " results\n";

	# print header with settings info

	my $stoplist = join(" ", @{$meta{STOPLIST}});

	print <<END;
# Tesserae V3 results
#
# session   = $meta{SESSION}
# source    = $meta{SOURCE}
# target    = $meta{TARGET}
# unit      = $meta{UNIT}
# feature   = $meta{FEATURE}
# stopsize  = $meta{STOP}
# stbasis   = $meta{STBASIS}
# stopwords = $stoplist
# max_dist  = $meta{DIST}
# dibasis   = $meta{DIBASIS}
# cutoff    = $cutoff

END

	print join ($delim, qw/
		"RESULT"
		"TARGET_LOC"
		"TARGET_TXT"
		"SOURCE_LOC"
		"SOURCE_TXT"
		"SHARED"
		"SCORE"
   /) . "\n";

	for my $rec (@rec) {

      my ($display_target, $display_source) = display($rec, "**", "**");

      my @fields = (
         $rec->{n},
         $rec->{loc_target},
         $display_target,
         $rec->{loc_source},
         join("; ", @{$rec->{features}}),
         $rec->{score}
      );

      @fields[1..4] = map {"\"$_\""} @fields[1..4];

		# print row

		print join($delim, @fields) . "\n";
	}
}

sub print_json {
   print encode_json({metadata=>\%meta, results=>\@rec});
}
