#!/usr/bin/env perl

=head1 NAME

check-recall.pl - compare search results against a benchmark

=head1 SYNOPSIS

check-recall.pl [options] <--session ID | TESRESULTS>

=head1 DESCRIPTION

Compare the results of a tesserae search with a benchmark of predefined
allusions. The benchmark set must previously have been installed using
F<scripts/benchmark/build-rec.pl>. To analyse a session created through
the web interface, use B<-s> with the session id; to analyse local results
created by a command line search, give the name of the directory (e.g.
'tesresults') without any flag.

=head1 OPTIONS AND ARGUMENTS

=over

=item I<TESRESULTS>

The name of a local search session, the output of read_table.pl (i.e. a
directory containing F<match.source>, F<match.target>, F<match.meta>, and
F<match.score>).

=item --session I<ID>

The session id for results created through the web interface.

=item --bench I<NAME>

The name of the pre-defined benchmark to use. Should correspond to a file
F<data/bench/NAME.cache>.

=item --export I<MODE>

The type of results to produce. Choices are

=over

=item summary

A simple table showing tallies of benchmark allusions found, by type. The
default output.

=item tab

A table of all benchmark results caught, tab-delimited

=item missed

A table of all the results missed, tab-delimited

=item html

An html document showing all benchmark results caught; what you get when you
run check-recall from the web interface.

=back


=item --quiet

Don't print debugging info to stderr.

=item --help

Print usage and exit.

=back

=head1 KNOWN BUGS

=head1 SEE ALSO

=head1 COPYRIGHT

University at Buffalo Public License Version 1.0.
The contents of this file are subject to the University at Buffalo Public License Version 1.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at http://tesserae.caset.buffalo.edu/license.txt.

Software distributed under the License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for the specific language governing rights and limitations under the License.

The Original Code is check-recall.pl.

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
use Parallel;

# modules to read cmd-line options and print usage

use Getopt::Long;
use Pod::Usage;

# load additional modules necessary for this script

use CGI qw(:standard);

use Storable;
use File::Basename;

# optional modules

# initialize some variables

my $help = 0;

my $session;

my $process_multi = 0;
my $use_lingua_stem = 0;
my $export = 'summary';
my $sort = 'score';
my $bench = 'default';
my $rev = 1;
my $dec = 2;

my @w = (7);
my $quiet = 1;

my %file;
my %name;

# is the program being run from the web or
# from the command line?

my $query = CGI->new() || die "$!";

my $no_cgi = defined($query->request_method()) ? 0 : 1;

if ($no_cgi) {
    # commandline options

    GetOptions(
    	"bench=s"    => \$bench,
    	"session=s"  => \$session,
    	"sort=s"     => \$sort,
        "multi=i"    => \$process_multi,
    	"export=s"   => \$export
    );    
} else {
    # CGI options
	$session = $query->param('session');
	$sort = $query->param('sort') || $sort;
	$export = $query->param('export') || 'html';
	$bench = $query->param('bench') || $bench;
	$quiet = 1;
    
	my %h = ('-charset'=>'utf-8', '-type'=>'text/html');
	
	if ($export eq "xml") { $h{'-type'} = "text/xml"; $h{'-attachment'} = "tesresults-$session.xml" }
	if ($export eq "csv") { $h{'-type'} = "text/csv"; $h{'-attachment'} = "tesresults-$session.csv" }
	if ($export eq "tab") { $h{'-type'} = "text/plain"; $h{'-attachment'} = "tesresults-$session.txt" }
	if ($export =~ /^miss/) { $h{'-type'} = "text/plain"; $h{'-attachment'} = "tesresults-$session.missed.txt" }

	print header(%h);    
}


# cache file
$file{cache} = catfile($fs{data}, 'bench', $bench . ".cache");
	
# sort order
$rev = $sort eq "target" ? 0 : 1;

# session file
if (defined $session) {
	$file{tess} = catfile($fs{tmp}, "tesresults-" . $session);
}
else {
	$file{tess} = shift @ARGV;
}

unless (defined $file{tess}) {
	if ($no_cgi) {
		pod2usage(2);
	}
	else {		
		html_no_table();
	}
	exit;
}

#
# read the data
#

# the benchmark data

my @bench = @{ retrieve($file{cache}) };

# the tesserae data

my %match_target = %{retrieve(catfile($file{tess}, "match.target"))};
my %match_source = %{retrieve(catfile($file{tess}, "match.source"))};
my %score        = %{retrieve(catfile($file{tess}, "match.score"))};
my %meta         = %{retrieve(catfile($file{tess}, "match.meta"))};
my %type;
my %auth;

$session = $meta{SESSION};

for (qw/target source/) {

	$name{$_} = $meta{uc($_)};
	$file{"token_$_"} = catfile($fs{data}, 'v3', Tesserae::lang($name{$_}), $name{$_}, $name{$_} . ".token");
	$file{"unit_$_"}  = catfile($fs{data}, 'v3', Tesserae::lang($name{$_}), $name{$_}, $name{$_} . ".phrase");
}

# now load the texts

my %unit;
my %token;

for (qw/target source/) {
 	
	@{$token{$_}}   = @{ retrieve($file{"token_$_"})};
	@{$unit{$_}}    = @{ retrieve($file{"unit_$_"}) };
}

#
# abbreviations of canonical citation refs
#

my $file_abbr = catfile($fs{data}, 'common', 'abbr');
my %abbr = %{ retrieve($file_abbr) };

#
# compare 
#

my @count = (0) x 7;
my @score = (0) x 7;
my @total = (0) x 7;
my @order = ();

# this records benchmark records not found by tesserae

my @missed;

# do the comparison

print STDERR "comparing\n" unless $quiet;
	
for my $i (0..$#bench) {
	
	my $auth   = $bench[$i]->get('auth');
	my $type   = $bench[$i]->get('type');
	my $unit_t = $bench[$i]->get('target_unit');
	my $unit_s = $bench[$i]->get('source_unit');
	
	if (defined $type) {

		$total[$type]++;
	}
	
	if (defined $auth) {
		
		$total[6]++;
	}
	
	if (defined $score{$unit_t}{$unit_s}) { 
		
		# tally the match for stats

		if (defined $type) {

			$count[$type]++;
			$score[$type] += $score{$unit_t}{$unit_s};
		
			# add the benchmark data to the tess parallel
		
			$type{$unit_t}{$unit_s} = $type;
		}

		if (defined $auth) {
			
			# tally commentator match
			
			$count[6]++;
			$score[6] += $score{$unit_t}{$unit_s};
			
			# add commentators to tess parallel
			
			$auth{$unit_t}{$unit_s} = $auth;
		}
		
		$bench[$i]->set('score', $score{$unit_t}{$unit_s});
				
		push @order, $i;
	}
	else {
	
		push @missed, $i;
	}
}	

unless ($quiet) {

	print STDERR "bench has " . scalar(@bench) . " records\n";
	print STDERR "order has " . scalar(@order) . " records\n";
	print STDERR "missed has " . scalar(@missed) . " records\n";
}

#
# load multi results
#

my @others;

my %multi = $process_multi ? %{load_multi()} : (); 

#
# output
#

binmode STDOUT, ":utf8";

if    ($export eq "summary") { summary()          }
elsif ($export eq "html")    { html_table()       }
elsif ($export =~ "^miss")   { print_missed("\t") }
else                         { print_delim("\t")  }


#
# subroutines
#


sub load_multi {

	#
	# first locate the multi-data directory
	#
	
	my $multi_dir;
	
	if ($session =~ /[0-9a-f]{8}/) {
	
		$multi_dir = catdir($fs{tmp}, "tesresults-$session", "multi");
	}
	else {
	
		$multi_dir = catdir($file{tess}, "multi");
	}
	
	#
	# get the textlist
	#
	
	@others = @{$meta{MTEXTLIST}};

	#
	# check every text
	#

	# this holds the data
	
	my %multi;

	# progress

	print STDERR "reading " . scalar(@others) . " files\n";
	
	my $pr = ProgressBar->new(scalar(@others));
	
	for my $other (@others) {
	
		$pr->advance;
	
		my $file_other = catfile($multi_dir, $other);
		
		$multi{$other} = retrieve($file_other);
	}
	
	return \%multi;
}

#
# output subroutines
#

sub summary {
	
	print "tesserae returned $meta{TOTAL} results\n";
	
	for (1..5) {
		
		my $rate =  $total[$_] > 0 ? sprintf("%.2f", $count[$_]/$total[$_]) : 'NA';
		my $score = $count[$_] > 0 ? sprintf("%.2f", $score[$_]/$count[$_]) : 'NA';
		
		print join("\t", $_, $count[$_], $total[$_], $rate, $score) . "\n";
	}
	
	my $rate =  $total[6] > 0 ? sprintf("%.2f", $count[6]/$total[6]) : 'NA';
	my $score = $count[6] > 0 ? sprintf("%.2f", $score[6]/$count[6]) : 'NA';
	
	print join("\t", "comm.", $count[6], $total[6], $rate, $score) . "\n";
}

sub html_table {
	
	my $mode = 'html';

	if ($sort eq 'score') {
		
		@order = sort { $bench[$a]->get('score')  <=> $bench[$b]->get('score') }
					sort { $bench[$a]->get('target_unit') <=> $bench[$b]->get('target_unit') }
					sort { $bench[$a]->get('source_unit') <=> $bench[$b]->get('source_unit') }	
					@order;
	}	
	elsif ($sort eq 'type') {
		
		@order = sort { $bench[$a]->get('type')   <=> $bench[$b]->get('type') }
					sort { $bench[$a]->get('score')  <=> $bench[$b]->get('score') }
					sort { $bench[$a]->get('target_unit') <=> $bench[$b]->get('target_unit') }
					sort { $bench[$a]->get('source_unit') <=> $bench[$b]->get('source_unit') }	
					@order;		
	}
	else {
		
		@order = sort { $bench[$a]->get('target_unit') <=> $bench[$b]->get('target_unit') }
					sort { $bench[$a]->get('source_unit') <=> $bench[$b]->get('source_unit') }	
					@order;
	}
	
	if ($rev) { @order = reverse @order }
	
	my $frame = load_frame(catfile($fs{html}, "check_recall.html"));
	
	my $table_data ="";
	
	for my $i (@order) {
	
		my $unit_id_target = $bench[$i]->get('target_unit');
		my $unit_id_source = $bench[$i]->get('source_unit');
	
		# note marked words
	
		my %marked_target;
		my %marked_source;
		
		for (keys %{$match_target{$unit_id_target}{$unit_id_source}}) { 
		
			$marked_target{$_} = 1;
		}
		
		for (keys %{$match_source{$unit_id_target}{$unit_id_source}}) {
		
			$marked_source{$_} = 1;
		}

		# generate the phrases
		
		my $phrase_target;
		
		for (@{$unit{target}[$unit_id_target]{TOKEN_ID}}) {
		
			if (defined $marked_target{$_}) {
				$phrase_target .= "<span class=\"matched\">$token{target}[$_]{DISPLAY}</span>";
			}
			else {
				$phrase_target .= $token{target}[$_]{DISPLAY};
			}
		}
		
		my $phrase_source;
		
		for (@{$unit{source}[$unit_id_source]{TOKEN_ID}}) {
		
			if (defined $marked_source{$_}) {
				$phrase_source .= "<span class=\"matched\">$token{source}[$_]{DISPLAY}</span>";
			}
			else {
				$phrase_source .= $token{source}[$_]{DISPLAY};
			}
		}
		
		$table_data .= table_row($mode,
			$bench[$i]->get('target_loc'),
			$phrase_target,
			$bench[$i]->get('source_loc'),
			$phrase_source,
			$bench[$i]->get('type'),
			sprintf("%.${dec}f", $bench[$i]->get('score')),
			(defined $bench[$i]->get('auth') ? join(",", @{$bench[$i]->get('auth')}) : "")
		);
	}

	my $recall_stats;
	
	for (1..5) {
		
		my $rate =  $total[$_] > 0 ? sprintf("%.2f", $count[$_]/$total[$_]) : 'NA';
		my $score = $count[$_] > 0 ? sprintf("%.2f", $score[$_]/$count[$_]) : 'NA';
		
		$recall_stats .= table_row($mode, 
			$_, 
			$count[$_], 
			$total[$_], 
			$rate, 
			$score
			);
	}
	
	my $rate =  $total[6] > 0 ? sprintf("%.2f", $count[6]/$total[6]) : 'NA';
	my $score = $count[6] > 0 ? sprintf("%.2f", $score[6]/$count[6]) : 'NA';
	
	$recall_stats .= table_row($mode, 
		"comm.", 
		$count[6], 
		$total[6], 
		$rate, 
		$score
		);
	
	$frame =~ s/<!--recall-stats-->/$recall_stats/;
	
	$frame =~ s/<!--parallels-->/$table_data/;

	print $frame;
}

sub html_no_table {
    my $frame;

    my $frame = load_frame(catfile($fs{html}, "check_recall.html"));
    
	print $frame;
}

sub table_row {

	my ($mode, @cell) = @_;

	if ($mode eq "text") {
		
		for (0..$#cell) {
	
			my $w = $w[$_] || 10;
	
			$cell[$_] = sprintf("%-${w}s", $cell[$_]);
		}
	}
	
	my $row_open  = $mode eq "html" ? "\t<tr><td>" : "";
	my $row_close = $mode eq "html" ? "\t</td></tr>\n" : "\n";
	my $spacer    = $mode eq "html" ? "</td><td>" : " | ";
	
	my $row = $row_open . join($spacer, @cell) . $row_close;
	
	return $row;
}

sub print_delim {
	
	my $delim = shift;
	
	print STDERR "writing output\n";
	
	#
	# print header with settings info
	#
	
	my $stoplist = join(" ", @{$meta{STOPLIST}});
	my $filtertoggle = $meta{FILTER} ? 'on' : 'off';

	
	print "# Tesserae Multi-text results\n";
	print "#\n";
	print "# session   = $session\n";
	print "# source    = $meta{SOURCE}\n";
	print "# target    = $meta{TARGET}\n";
	print "# unit      = $meta{UNIT}\n";
	print "# feature   = $meta{FEATURE}\n";
	print "# stopsize  = $meta{STOP}\n";
	print "# stbasis   = $meta{STBASIS}\n";
	print "# stopwords = $stoplist\n";
	print "# max_dist  = $meta{DIST}\n";
	print "# dibasis   = $meta{DIBASIS}\n";
	print "# cutoff    = $meta{CUTOFF}\n";
	print "# filter    = $filtertoggle\n";

	if ($process_multi) {
	
		print "# multitext = " . join(" ", @{$meta{MTEXTLIST}}) . "\n";
		print "# m_cutoff  = $meta{MCUTOFF}\n";
	}
	
	my @header = qw(
		"RESULT"
		"TARGET_PHRASE"
		"TARGET_BOOK"
		"TARGET_LINE"
		"TARGET_TEXT"
		"SOURCE_PHRASE"
		"SOURCE_BOOK"
		"SOURCE_LINE"
		"SOURCE_TEXT"
		"SHARED"
		"SCORE"
		"TYPE"
		"AUTH");
		
	if ($process_multi) {
	
		push @header, qw/"OTHER_TEXTS" "OTHER_TOTAL"/;
		
		if ($process_multi > 1) {
		
			push @header, map { "\"$_\"" } @others;
		}
	}
	
	print join ($delim, @header) . "\n";

	my $pr = ProgressBar->new(scalar(keys %score));
		
	my $i = 0;

	for my $unit_id_target (keys %score) {
	
		$pr->advance();

		for my $unit_id_source ( keys %{$score{$unit_id_target}} ) {
				
			# a guide to which tokens are marked in each text
		
			my %marked_target;
			my %marked_source;
			
			# collect the keys
			
			my %seen_keys;
	
			for (keys %{$match_target{$unit_id_target}{$unit_id_source}}) { 
			
				$marked_target{$_} = 1;
			
				$seen_keys{join("-", sort keys %{$match_target{$unit_id_target}{$unit_id_source}{$_}})} = 1;
			}
			
			for (keys %{$match_source{$unit_id_target}{$unit_id_source}}) {
			
				$marked_source{$_} = 1;
	
				$seen_keys{join("-", sort keys %{$match_source{$unit_id_target}{$unit_id_source}{$_}})} = 1;
			}
		
			# format the list of all unique shared words
	
			my $keys = join("; ", keys %seen_keys);

			# get the score
		
			my $score = sprintf("%.${dec}f", $score{$unit_id_target}{$unit_id_source});

			# get benchmark data

			my $type = $type{$unit_id_target}{$unit_id_source} || "";
			
			my $auth = "";
			
			if (defined $auth{$unit_id_target}{$unit_id_source}) {
			
				$auth = '"' . join(",", @{$auth{$unit_id_target}{$unit_id_source}}) . '"';
			}
			
			#
			# now prepare the csv record for this match
			#

			my @row;
		
			# result serial number
		
			push @row, ++$i;
		
			# target phrase id
			
			push @row, $unit_id_target;
		
			# target locus
			
			my $loc_target = $unit{target}[$unit_id_target]{LOCUS};
		
			push @row, (split('\.', $loc_target));
		
			# target phrase
		
			my $phrase = "";
				
			for my $token_id_target (@{$unit{target}[$unit_id_target]{TOKEN_ID}}) {
		
				if ($marked_target{$token_id_target}) { $phrase .= "**" }
		
				$phrase .= $token{target}[$token_id_target]{DISPLAY};

				if ($marked_target{$token_id_target}) { $phrase .= "**" }
			}
		
			push @row, "\"$phrase\"";
					
			# source phrase id
			
			push @row, $unit_id_source;
					
			# source locus
			
			my $loc_source = $unit{source}[$unit_id_source]{LOCUS};
						
			push @row, (split('\.', $loc_source));
			
			# source phrase
			
			$phrase = "";
			
			for my $token_id_source (@{$unit{source}[$unit_id_source]{TOKEN_ID}}) {
			
				if ($marked_source{$token_id_source}) { $phrase .= "**" }
			
				$phrase .= $token{source}[$token_id_source]{DISPLAY};
				
				if ($marked_source{$token_id_source}) { $phrase .= "**" }
			}
					
			push @row, "\"$phrase\"";
		
			# keywords
			
			push @row, "\"$keys\"";

			# score

			push @row, $score;
	
			# benchmark data
			
			push @row, ($type, $auth);
		
			# multi-text search
			
			if ($process_multi) {
		
				my $other_texts = 0;
				my $other_total = 0;
			
				my %m;
				@m{@others} = ("") x scalar(@others);
			
				for my $other (@others) {
			
					if (defined $multi{$other}{$unit_id_target}{$unit_id_source}) {
					
						my @loci;
						
						for (sort {$a <=> $b} keys %{$multi{$other}{$unit_id_target}{$unit_id_source}}) {
							
							my $locus = $multi{$other}{$unit_id_target}{$unit_id_source}{$_}{LOCUS};
							my $score = $multi{$other}{$unit_id_target}{$unit_id_source}{$_}{SCORE};
							$score = sprintf("%.${dec}f", $score);
							
							push @loci, "$locus ($score)";
						}
						
						$m{$other} = '"' . join("; ", @{loci}) . '"';
	
						$other_texts++;
											
						$other_total += scalar(@loci);
					}
				}
			
				push @row, ($other_texts, $other_total);
			
				push @row, @m{@others} if $process_multi > 1;
			}
		
			# print row
		
			print join($delim, @row) . "\n";
		}
	}
}


sub print_missed {
	
	my $delim = shift;
		
	print STDERR "writing output\n";
	
	#
	# print header with settings info
	#
	
	my $stoplist = join(" ", @{$meta{STOPLIST}});
	my $filtertoggle = $meta{FILTER} ? 'on' : 'off';

	
	print "# Tesserae missed results\n";
	print "#\n";
	print "# session   = $session\n";
	print "# source    = $meta{SOURCE}\n";
	print "# target    = $meta{TARGET}\n";
	print "# unit      = $meta{UNIT}\n";
	print "# feature   = $meta{FEATURE}\n";
	print "# stopsize  = $meta{STOP}\n";
	print "# stbasis   = $meta{STBASIS}\n";
	print "# stopwords = $stoplist\n";
	print "# max_dist  = $meta{DIST}\n";
	print "# dibasis   = $meta{DIBASIS}\n";
	print "# cutoff    = $meta{CUTOFF}\n";
	print "# filter    = $filtertoggle\n";
	
	my @header = qw(
		"RESULT"
		"TARGET_BOOK"
		"TARGET_LINE"
		"TARGET_TEXT"
		"SOURCE_BOOK"
		"SOURCE_LINE"
		"SOURCE_TEXT"
		"NSHARED"
		"SHARED"
		"TYPE"
		"AUTH");
			
	print join ($delim, @header) . "\n";

	my $pr = ProgressBar->new(scalar(@missed));

	for my $i (0..$#missed) {
	
		$pr->advance();

		my $rec = $bench[$missed[$i]];

		my $unit_id_target = $rec->get('unit_t');
		my $unit_id_source = $rec->get('unit_s');
		my $type = $rec->get('type');
		my $auth = defined $rec->get('auth') ? join(",", @{$rec->get('auth')}) : "";
			
		# do a tess search on these two phrases

		my %mini_results = %{minitess($unit_id_target, $unit_id_source, $meta{STOPLIST})};
		
		# get the marked words if any
		
		my %marked_target = %{$mini_results{marked_target}};
		my %marked_source = %{$mini_results{marked_source}};
		
		# format the list of all unique shared words
		
		my $nkeys = scalar(@{$mini_results{seen_keys}});
	
		my $keys = join("; ", @{$mini_results{seen_keys}});

		#
		# now prepare the csv record for this match
		#

		my @row;
	
		# result serial number
	
		push @row, ++$i;
	
		# target locus
		
		my $loc_target = $unit{target}[$unit_id_target]{LOCUS};
	
		push @row, (split('\.', $loc_target));
	
		# target phrase
		
		my $phrase = "";
			
		for my $token_id_target (@{$unit{target}[$unit_id_target]{TOKEN_ID}}) {
	
			if ($marked_target{$token_id_target}) { $phrase .= "**" }
	
			$phrase .= $token{target}[$token_id_target]{DISPLAY};

			if ($marked_target{$token_id_target}) { $phrase .= "**" }
		}
		
		push @row, "\"$phrase\"";
				
		# source locus
		
		my $loc_source = $unit{source}[$unit_id_source]{LOCUS};
					
		push @row, (split('\.', $loc_source));
		
		# source phrase
		
		$phrase = "";
		
		for my $token_id_source (@{$unit{source}[$unit_id_source]{TOKEN_ID}}) {
		
			if ($marked_source{$token_id_source}) { $phrase .= "**" }
		
			$phrase .= $token{source}[$token_id_source]{DISPLAY};
			
			if ($marked_source{$token_id_source}) { $phrase .= "**" }
		}
				
		push @row, "\"$phrase\"";
	
		# keywords
		
		push @row, ($nkeys, "\"$keys\"");

		# benchmark data
		
		push @row, ($type, $auth);
		
		# print row
	
		print join($delim, @row) . "\n";
	}
}

# perform the equivalent of a tesserae search on just two phrases

sub minitess {

	my %unit_id;
	my $stoplistref;
	
	my %results;

	($unit_id{target}, $unit_id{source}, $stoplistref) = @_;
	
	my @stoplist = @$stoplistref;
	
	#
	# for each phrase, create an index of word tokens by their stems
	#
	
	my %index;
		
	for my $text (qw/target source/) {
		
		my $lang = Tesserae::lang($name{$text});
	
		for my $token_id (@{$unit{$text}[$unit_id{$text}]{TOKEN_ID}}) {

			next unless $token{$text}[$token_id]{TYPE} eq "WORD";
		
			my $word = $token{$text}[$token_id]{FORM};

			for my $feat (@{Tesserae::feat($lang, $meta{FEATURE}, $word)}) {
			
				push @{$index{$feat}{$text}}, $token_id;
			}
		}
	}
	
	for (@stoplist) {
	
		delete $index{$_} if defined $index{$_};
	}
	
	#
	# check the index for stems that occur in both phrases
	#
	
	my %marked;
	my %seen_keys;
	
	for my $feat (keys %index) {
	
		next unless defined ($index{$feat}{target} and $index{$feat}{source});
		
		# mark all tokens that share a common stem
		
		for my $text (qw/target source/) {
			
			my $lang = Tesserae::lang($name{$text});
		
			for my $token_id (@{$index{$feat}{$text}}) {
			
				$marked{$text}{$token_id} = 1;
				
				my @feats = @{Tesserae::feat($lang, $meta{FEATURE}, $token{$text}[$token_id]{FORM})};
				
				$seen_keys{join("-", sort @feats)} = 1;
			}
		}
	}
	
	$results{marked_target} = $marked{target}   || {};
	$results{marked_source} = $marked{source}   || {};
	$results{seen_keys}     = [keys %seen_keys];
	
	return \%results;
}


sub load_frame {
    my ($file) = shift;
    my $frame;
    
    open (my $fh, "<:utf8", $file) or die "Can't read $file: $!";
    
    while (my $line = <$fh>) {
        $frame .= $line;
    }
    
    close ($fh);

    $frame =~ s/\/\*bench\*\/.*\/\*bench\*\//"$bench"/g;
    $frame =~ s/\/\*sort\*\/.*\/\*sort\*\//"$sort"/g;
    if (defined $session) {
        $frame =~ s/\/\*session\*\/.*\/\*session\*\//"$session"/g;        
    }

    return $frame;
}
