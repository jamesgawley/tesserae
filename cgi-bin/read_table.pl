#!/usr/bin/env perl

=head1 NAME

read_table.pl - Perform a Tesserae search.

=head1 SYNOPSIS

read_table.pl --target I<target_text> --source I<source_text>
[OPTIONS]

=head1 DESCRIPTION

This script compares two texts in the Tesserae corpus and returns a list of
"parallels", pairs of textual units which share common features. These
parallels are organized in a set of hashes which are saved as a binaries
using Storable. These files, kept together in a directory named for the
session, can be read and formatted in a user-friendly way with the companion
script B<read_bin.pl>.

This script is primarily called as a cgi executable from the web interface.
Called as a cgi, it creates a new session id for the results and saves them
to the Tesserae F<tmp/> directory. It then redirects the browser to
B<read_bin.pl> which mediates viewing the results.

It can also be run from the command line. In this case, the results are
written to a new directory given a user-specified session name (or
"tesresults" by default).

The names of the source and target texts to be searched must be specified.
B<Target> means the alluding (more recent) text. B<Source> is the alluded-to
(earlier) text.

The name of a text is identical to its filename without the F<.tess>
extension. For example, our benchmark test is to search for allusions to
Vergil's Aeneid in Book 1 of Lucan's Bellum Civile. The file containing the
Aeneid is F<texts/la/vergil.aeneid.tess> and that containing just the first
book of Pharsalia is
F<texts/la/lucan.bellum_civile/lucan.bellum_civile.part.1.tess>. Thus, a
default search, taking Lucan as the alluder and Vergil as the alluded-to, is
run like this:

 % cgi-bin/read_table.pl --source vergil.aeneid \
                         --target lucan.bellum_civile.part.1

=head1 OPTIONS

=over

=item --unit <line|phrase>

Specifies the textual units to be compared. Choices currently are
B<line> (the default) which compares verse lines or B<phrase>, which
compares grammatical phrases. For now we assume that the punctuation marks
[.;:?] delimit phrases.

=item --feature <word|stem|syn>

This specifies the features set to match against. B<word> only allows
matches on forms that are identical. B<stem> (the default), allows matches
on any inflected form of the same stem. B<syn> matches not only forms of the
same headword but also other headwords taken to be related in meaning.
B<stem> and B<syn> only work if the appropriate dictionaries are installed.

=item --stop I<N>

The number of stop words (stems, etc.) to use. Matches on any of these are
excluded from results. The stop list is calculated by ordering all the 
features (see above) in the stoplist basis (see below) by frequency and taking
the top I<N>. The default is 10.

=item --stbasis <corpus|target|source|both>

A string indicating the source for the ranked list of features from which the
stoplist is taken. B<corpus> derives the stoplist from the entire corpus; 
B<source>, uses only the source; B<target>, only the target; and B<both> (the
default) uses the source and target but nothing else.

=item --dist I<N>

This sets the maximum distance between matching words. For two units (one in
the source and one in the target) to be considered a match, each must have
at least two words common to the other (regardless of the feature on which
they matched). It's generally true that in good allusions these words are
close together in both units. Setting the maximum distance to I<N> means
that matches where the sum of the distances in the two matched phrases
exceeds I<N> words will be excluded. The default distance is 10. If you don't
want to limit distance, set I<N> to something bigger than the number of
tokens in a unit, e.g., 999. Note that adjacent words are considered to
have a distance of 1, words separated by a single intervening word have a 
distance of 2, and so on.

=item --dibasis <span|freq>

Distance basis is a string indicating the way to calculate the distance
between matching words in a parallel (matching pair of units). B<span> adds
together the distance in words between the two farthest-apart words in each
phrase. The default option is B<freq>, which uses the distance between the
two words with the lowest frequencies (in their own text only), adding the
frequency-based distances of the target and source units together.

=item --binary I<name>

This is the name to be given to the session. Tesserae will create a new
directory with this name and save there the Storable binaries containing
your results. The default is B<tesresults>.

=item --quiet

Don't write progress info to STDERR.

=item --help

Print this message and exit.

=back

The values of all these options should be printed to STDERR when you run the
script from the command-line, and should also be saved with the results.

=head1 KNOWN BUGS

=head1 SEE ALSO

B<cgi-bin/read_bin.pl>

=head1 COPYRIGHT

University at Buffalo Public License Version 1.0. The contents of this file
are subject to the University at Buffalo Public License Version 1.0 (the
"License"); you may not use this file except in compliance with the License.
You may obtain a copy of the License at
http://tesserae.caset.buffalo.edu/license.txt.

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
the specific language governing rights and limitations under the License.

The Original Code is read_table.pl.

The Initial Developer of the Original Code is Research Foundation of State
University of New York, on behalf of University at Buffalo.

Portions created by the Initial Developer are Copyright (C) 2007 Research
Foundation of State University of New York, on behalf of University at
Buffalo. All Rights Reserved.

Contributor(s): Chris Forstall <cforstall@gmail.com>, James Gawley.

Alternatively, the contents of this file may be used under the terms of
either the GNU General Public License Version 2 (the "GPL"), or the GNU
Lesser General Public License Version 2.1 (the "LGPL"), in which case the
provisions of the GPL or the LGPL are applicable instead of those above. If
you wish to allow use of your version of this file only under the terms of
either the GPL or the LGPL, and not to allow others to use your version of
this file under the terms of the UBPL, indicate your decision by deleting
the provisions above and replace them with the notice and other provisions
required by the GPL or the LGPL. If you do not delete the provisions above,
a recipient may use your version of this file under the terms of any one of
the UBPL, the GPL or the LGPL.

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

use CGI qw/:standard/;
use Storable qw(nstore retrieve);
use File::Path qw(mkpath rmtree);
use Encode;

binmode STDERR, 'utf8';

#
# set some parameters
#

# time for benchmark

my $t0 = time;

# source means the alluded-to, older text

my $source;

# target means the alluding, newer text

my $target;

# unit means the level at which results are returned: 
# - choice right now is 'phrase' or 'line'

my $unit = "line";

# feature means the feature set compared: 
# - choice is 'word' or 'stem'

my $feature = "stem";

# stopwords is the number of words on the stoplist

my $stopwords = 10;

# stoplist_basis is where we draw our feature
# frequencies from: source, target, or corpus

my $stoplist_basis = "corpus";

# output file

my $file_results = "tesresults";

# session id

my $session = "NA";

# is the program being run from the web or
# from the command line?

my $query = CGI->new() || die "$!";

my $no_cgi = defined($query->request_method()) ? 0 : 1;

# print debugging messages to stderr?

my $quiet = 0;

# maximum distance between matching tokens

my $max_dist = 999;

# metric for measuring distance

my $distance_metric = "freq";

# filter multi-results if passing off to multitext.pl

my $multi_cutoff = 0;                  

# text list to pass on to multitext.pl

my @include;

# cache param to pass on to check-recall.pl

my $recall_cache = 'rec';

# help flag

my $help;

# print benchmark times?

my $bench = 0;

# what frequency table to use in scoring

my $score_basis;

# subset text units to search

my $mask_target_first;
my $mask_target_last;
my $mask_source_first;
my $mask_source_last;

# which script should mediate the display of results

my $frontend = 'default';
my %redirect;

GetOptions( 
	'source=s' => \$source,
	'target=s' => \$target,
	'unit=s' => \$unit,
	'feature=s' => \$feature,
	'stopwords=i' => \$stopwords, 
	'stbasis=s' => \$stoplist_basis,
	'binary=s' => \$file_results,
	'distance=i' => \$max_dist,
	'dibasis=s' => \$distance_metric,
	'score=s' => \$score_basis,
	'benchmark' => \$bench,
	'no-cgi' => \$no_cgi,
    'mask-target-first=i' => \$mask_target_first,
    'mask-target-last=i' => \$mask_target_last,
    'mask-source-first=i' => \$mask_source_first,
    'mask-source-last=i' => \$mask_source_last,                        
	'quiet' => \$quiet,
	'help' => \$help
);

#
# print usage info if help flag set
#

if ($help) {

	pod2usage(-verbose => 2);
}

# default score basis set by Tesserae.pm

unless (defined $score_basis)  { 
	
	$score_basis = $Tesserae::feature_score{$feature} || 'word';
}

# html header
#
# put this stuff early on so the web browser doesn't
# give up

unless ($no_cgi) {

	print header();

	my $stylesheet = "/css/style.css";

	print <<END;

<html>
<head>
	<title>Tesserae results</title>
	<link rel="stylesheet" type="text/css" href="$stylesheet" />
END

	#
	# determine the session ID
	# 

	# open the temp directory
	# and get the list of existing session files

	opendir(my $dh, $fs{tmp}) || die "can't opendir $fs{tmp}: $!";

	my @tes_sessions = grep { /^tesresults-[0-9a-f]{8}/ && -d catfile($fs{tmp}, $_) } readdir($dh);

	closedir $dh;

	# sort them and get the id of the last one

	@tes_sessions = sort(@tes_sessions);

	$session = $tes_sessions[-1];

	# then add one to it;
	# if we can't determine the last session id,
	# then start at 0

	if (defined($session)) {

	   $session =~ s/^.+results-//;
	}
	else {

	   $session = "0"
	}

	# put the id into hex notation to save space and make it look confusing

	$session = sprintf("%08x", hex($session)+1);

	# open the new session file for output

	$file_results = catfile($fs{tmp}, "tesresults-$session");
}


#
# abbreviations of canonical citation refs
#

my $file_abbr = catfile($fs{data}, 'common', 'abbr');
my %abbr = %{ retrieve($file_abbr) };

# if web input doesn't seem to be there, 
# then check command line arguments

if ($no_cgi) {

	unless (defined ($source and $target)) {

		pod2usage( -verbose => 1);
	}
}
else {

	$source = $query->param('source');
	$target = $query->param('target');
	$unit = $query->param('unit') || $unit;
	$feature = $query->param('feature') || $feature;
	$stopwords = defined($query->param('stopwords')) ? $query->param('stopwords') : $stopwords;
	$stoplist_basis = $query->param('stbasis') || $stoplist_basis;
	$max_dist = $query->param('dist') || $max_dist;
	$distance_metric = $query->param('dibasis') || $distance_metric;
	$score_basis = $query->param('score') || $score_basis;
	$frontend = $query->param('frontend') || $frontend;
	$multi_cutoff = $query->param('mcutoff') || $multi_cutoff;
	@include = $query->param('include');
	$recall_cache = $query->param('recall_cache') || $recall_cache;
    $mask_target_first = $query->param('mask_target_first');
    $mask_target_last = $query->param('mask_target_last');
    $mask_source_first = $query->param('mask_source_first');
    $mask_target_first = $query->param('mask_source_last');
	
	unless (defined $source) {
	
		die "read_table.pl called from web interface with no source";
	}
	unless (defined $target) {
	
		die "read_table.pl called from web interface with no target";
	}
		
	$quiet = 1;
	
	# how to redirect browser to results

	%redirect = ( 
		default  => "/cgi-bin/read_bin.pl?session=$session",
		recall   => "/cgi-bin/check-recall.pl?session=$session;cache=$recall_cache",
		fulltext => "/cgi-bin/fulltext.pl?session=$session",
		multi    => "/cgi-bin/multitext.pl?session=$session;mcutoff=$multi_cutoff;list=1"
	);

	
	print <<END;
	<meta http-equiv="Refresh" content="0; url='$redirect{$frontend}'">
	</head>
	<body>
		<div class="waiting">
		<p>
			Searching...
		</p>
END

}

#
# force unit=phrase if either work is prose
#
# Note: This is a hack!  Fix later!!

if (Tesserae::check_prose_list($target) or Tesserae::check_prose_list($source)) {

	$unit = 'phrase';
}

# assume unicode text names are utf8,
# whether input via cmd line or cgi

# $target = decode('utf8', $target);
# $source = decode('utf8', $source);

# if user selected 'feature' as score basis,
# set it to whatever the feature is

if ($score_basis =~ /^feat/) {

	$score_basis = $feature;
}

# print all params for debugging

unless ($quiet) {

	print STDERR "target=$target\n";
	print STDERR "source=$source\n";
	print STDERR "lang(target)=" . Tesserae::lang($target) . "\n";
	print STDERR "lang(source)=" . Tesserae::lang($source) . "\n";		
	print STDERR "feature=$feature\n";
	print STDERR "unit=$unit\n";
	print STDERR "stopwords=$stopwords\n";
	print STDERR "stoplist basis=$stoplist_basis\n";
	print STDERR "max_dist=$max_dist\n";
	print STDERR "distance basis=$distance_metric\n";
	print STDERR "score basis=$score_basis\n";
}


#
# calculate feature frequencies
#

# token frequencies from the target text

my $file_freq_target = select_file_freq($target) . ".freq_score_" . $score_basis;
my %freq_target = %{Tesserae::stoplist_hash($file_freq_target)};

# token frequencies from the source text

my $file_freq_source = select_file_freq($source) . ".freq_score_" . $score_basis;
my %freq_source = %{Tesserae::stoplist_hash($file_freq_source)};

#
# basis for stoplist is feature frequency from one or both texts
#

my @stoplist = @{load_stoplist($stoplist_basis, $stopwords)};

unless ($quiet) { print STDERR "stoplist: " . join(",", @stoplist) . "\n"}


#
# read data from table
#


unless ($quiet) {
	
	print STDERR "reading source data\n";
}

my $file_source = catfile($fs{data}, 'v3', Tesserae::lang($source), $source, $source);

my @token_source   = @{ retrieve("$file_source.token") };
my @unit_source    = @{ retrieve("$file_source.$unit") };
my %index_source   = %{ retrieve("$file_source.index_$feature")};

unless ($quiet) {

	print STDERR "reading target data\n";
}

my $file_target = catfile($fs{data}, 'v3', Tesserae::lang($target), $target, $target);

my @token_target   = @{ retrieve("$file_target.token") };
my @unit_target    = @{ retrieve("$file_target.$unit") };
my %index_target   = %{ retrieve("$file_target.index_$feature" ) };

#
# validate masks
#

unless (defined $mask_target_first and $mask_target_first > 0) {
    $mask_target_first = 0;
}
unless (defined $mask_target_last and $mask_target_last <= $#token_target) {
    $mask_target_last = $#token_target;
}
unless (defined $mask_source_first and $mask_source_first > 0) {
    $mask_source_first = 0;
}
unless (defined $mask_source_last and $mask_source_last <= $#token_source) {
    $mask_source_last = $#token_source;
}


print STDERR "mask_target_first=" . ($mask_target_first || "none") . "\n";
print STDERR "mask_target_last=" . ($mask_target_last || "none") . "\n";
print STDERR "mask_source_first=" . ($mask_source_first || "none") . "\n";
print STDERR "mask_source_last=" . ($mask_source_last || "none") . "\n";


#
#
# this is where we calculated the matches
#
#

my $t1 = time;

# this hash holds information about matching units

my %match_target;
my %match_source;
my %match_score;

#
# consider each key in the source doc
#

unless ($quiet) {

	print STDERR "comparing $target and $source\n";
}

# draw a progress bar

my $pr;

if ($no_cgi) {
	$pr = ProgressBar->new(scalar(keys %index_source), $quiet);
}
else {
	$pr = HTMLProgress->new(scalar(keys %index_source));
}

# start with each key in the source

for my $key (keys %index_source) {

	# advance the progress bar

	$pr->advance();

	# skip key if it doesn't exist in the target doc

	next unless ( defined $index_target{$key} );

	# skip key if it's in the stoplist

	next if ( grep { $_ eq $key } @stoplist);

	# link every occurrence in one text to every one in the other text

	for my $token_id_target ( @{$index_target{$key}} ) {        
        next if $token_id_target < $mask_target_first;
        next if $token_id_target > $mask_target_last;

		my $unit_id_target = $token_target[$token_id_target]{uc($unit) . '_ID'};
		
		for my $token_id_source ( @{$index_source{$key}} ) {
            next if $token_id_source < $mask_source_first;
            next if $token_id_source > $mask_source_last;

			my $unit_id_source = $token_source[$token_id_source]{uc($unit) . '_ID'};
			
			$match_target{$unit_id_target}{$unit_id_source}{$token_id_target}{$key} = 1;
			$match_source{$unit_id_target}{$unit_id_source}{$token_id_source}{$key} = 1;
		}
	}
}

print "search>>" . (time-$t1) . "\n" if $no_cgi and $bench;

#
#
# assign scores
#
#

$t1 = time;

# how many matches in all?

my $total_matches = 0;

# draw a progress bar

if ($no_cgi) {

	print STDERR "calculating scores\n" unless $quiet;

	$pr = ProgressBar->new(scalar(keys %match_target), $quiet);
}
else {

	print "<p>Scoring...</p>\n";

	$pr = HTMLProgress->new(scalar(keys %match_target));
}

#
# look at the matches one by one, according to unit id in the target
#

for my $unit_id_target (keys %match_target) {

	# advance the progress bar

	$pr->advance();

	# look at all the source units where the feature occurs
	# sort in numerical order

	for my $unit_id_source (keys %{$match_target{$unit_id_target}}) {
                                     
		# intra-textual matching:
		# 
		# where source and target are the same text, don't match
		# a line with itself
		
		next if ($source eq $target) and ($unit_id_source == $unit_id_target);

		#
		# remove matches having fewer than 2 matching words
		# or matching on fewer than 2 different keys
		#
			
		# check that the target has two matching words
			
		if ( scalar( keys %{$match_target{$unit_id_target}{$unit_id_source}} ) < 2) {
		
			delete $match_target{$unit_id_target}{$unit_id_source};
			delete $match_source{$unit_id_target}{$unit_id_source};
			next;
		}
		
		# check that the source has two matching words
	
		if ( scalar( keys %{$match_source{$unit_id_target}{$unit_id_source}} ) < 2) {
	
			delete $match_target{$unit_id_target}{$unit_id_source};
			delete $match_source{$unit_id_target}{$unit_id_source};
			next;			
		}		
	
		# make sure each phrase has at least two different inflected forms
		
		my %seen_forms;	
		
		for my $token_id_target (keys %{$match_target{$unit_id_target}{$unit_id_source}} ) {
						
			$seen_forms{$token_target[$token_id_target]{FORM}}++;
		}
		
		if (scalar(keys %seen_forms) < 2) {
		
			delete $match_target{$unit_id_target}{$unit_id_source};
			delete $match_source{$unit_id_target}{$unit_id_source};
			next;			
		}	
		
		%seen_forms = ();
		
		for my $token_id_source ( keys %{$match_source{$unit_id_target}{$unit_id_source}} ) {
		
			$seen_forms{$token_source[$token_id_source]{FORM}}++;
		}

		if (scalar(keys %seen_forms) < 2) {
		
			delete $match_target{$unit_id_target}{$unit_id_source};
			delete $match_source{$unit_id_target}{$unit_id_source};
			next;			
		}	
				
		#
		# calculate the distance
		# 
		
		my $distance = dist($match_target{$unit_id_target}{$unit_id_source}, $match_source{$unit_id_target}{$unit_id_source}, $distance_metric);
		
		if ($distance > $max_dist) {
		
			delete $match_target{$unit_id_target}{$unit_id_source};
			delete $match_source{$unit_id_target}{$unit_id_source};
			next;
		}
		
		
		#
		# calculate the score
		#
		
		# score
		
		my $score = score_default($match_target{$unit_id_target}{$unit_id_source}, $match_source{$unit_id_target}{$unit_id_source}, $distance);
				
		# save calculated score, matched words, etc.
		
		$match_score{$unit_id_target}{$unit_id_source} = $score;
		
		$total_matches++;
	}
}

my %feature_notes = (
	
	word => "Exact matching only.",
	stem => "Stem matching enabled.  Forms whose stem is ambiguous will match all possibilities.",
	syn  => "Stem + synonym matching.  This search is still in development.  Note that stopwords may match on less-common synonyms."
	);

print "score>>" . (time-$t1) . "\n" if $no_cgi and $bench;

#
# write binary results
#

$t1 = time;

my %match_meta = (

	SOURCE => $source,
    MSF => $mask_source_first,
    MSL => $mask_source_last,
	TARGET => $target,
    MTF => $mask_target_first,
    MTL => $mask_target_last,
	UNIT => $unit,
	FEATURE => $feature,
	STOP => $stopwords,
	STOPLIST => [@stoplist],
	STBASIS => $stoplist_basis,
	DIST => $max_dist,
	DIBASIS => $distance_metric,
	SESSION => $session,
	SCBASIS => $score_basis,
	COMMENT => $feature_notes{$feature},
	VERSION => $Tesserae::VERSION,
	TOTAL => $total_matches
);


if ($no_cgi) {
	
	print STDERR "writing $file_results\n" unless $quiet;
}
else {

	print "<p>Writing session data.</p>";
}

rmtree($file_results);
mkpath($file_results);
	
nstore \%match_target, catfile($file_results, "match.target");
nstore \%match_source, catfile($file_results, "match.source");
nstore \%match_score,  catfile($file_results, "match.score" );
nstore \%match_meta,   catfile($file_results, "match.meta"  );

if (@include) {

	write_multi_list($file_results, \@include);
}

print "store>>" . (time-$t1) . "\n" if $no_cgi and $bench;

print <<END unless ($no_cgi);

	<p>
      Your search is done.  If you are not redirected automatically, 
      <a href="$redirect{$frontend}">click here</a>.
	</p>
	</div>
</body>
</html>

END


print "total>>" . (time-$t0)  . "\n" if $no_cgi and $bench;

#
# subroutines
#

#
# dist : calculate the distance between matching terms
#
#   used in determining match scores
#   and in filtering out bad results

sub dist {

	my ($match_t_ref, $match_s_ref, $metric) = @_;
	
	my %match_target = %$match_t_ref;
	my %match_source = %$match_s_ref;
	
	my @target_id = sort {$a <=> $b} keys %match_target;
	my @source_id = sort {$a <=> $b} keys %match_source;
	
	my $dist = 0;
	
	#
	# distance is calculated by one of the following metrics
	#
	
	# freq: count all words between (and including) the two lowest-frequency 
	# matching words in each phrase.  NB this is the best metric in my opinion.
	
	if ($metric eq "freq") {
	
		# sort target token ids by frequency of the forms
		
		my @t = sort {$freq_target{$token_target[$a]{FORM}} <=> $freq_target{$token_target[$b]{FORM}}} @target_id; 
			      
		# consider the two lowest;
		# put them in order from left to right
			      
		if ($t[0] > $t[1]) { @t[0,1] = @t[1,0] }
			
		# now go token to token between them, incrementing the distance
		# only if each token is a word.
			
		for ($t[0]..$t[1]) {
		
		  $dist++ if $token_target[$_]{TYPE} eq 'WORD';
		}
			
		# now do the same in the source phrase
			
		my @s = sort {$freq_source{$token_source[$a]{FORM}} <=> $freq_source{$token_source[$b]{FORM}}} @source_id; 
		
		if ($s[0] > $s[1]) { @s[0,1] = @s[1,0] }
			
		for ($s[0]..$s[1]) {
		
		  $dist++ if $token_source[$_]{TYPE} eq 'WORD';
		}
	}
	
	# freq_target: as above, but only in the target phrase
	
	elsif ($metric eq "freq_target") {
		
		my @t = sort {$freq_target{$token_target[$a]{FORM}} <=> $freq_target{$token_target[$b]{FORM}}} @target_id; 
			
		if ($t[0] > $t[1]) { @t[0,1] = @t[1,0] }
			
		for ($t[0]..$t[1]) {
		
		  $dist++ if $token_target[$_]{TYPE} eq 'WORD';
		}
	}
	
	# freq_source: ditto, but source phrase only
	
	elsif ($metric eq "freq_source") {
		
		my @s = sort {$freq_source{$token_source[$a]{FORM}} <=> $freq_source{$token_source[$b]{FORM}}} @source_id; 
		
		if ($s[0] > $s[1]) { @s[0,1] = @s[1,0] }
			
		for ($s[0]..$s[1]) {
		
		  $dist++ if $token_source[$_]{TYPE} eq 'WORD';
		}
	}
	
	# span: count all words between (and including) first and last matching words
	
	elsif ($metric eq "span") {
	
		# check all tokens from the first (lowest-id) matching word
		# to the last.  increment distance only if token is of type WORD.
	
		for ($target_id[0]..$target_id[-1]) {
		
		  $dist++ if $token_target[$_]{TYPE} eq 'WORD';
		}
		
		for ($source_id[0]..$source_id[-1]) {
		
		  $dist++ if $token_source[$_]{TYPE} eq 'WORD';
		}
	}
	
	# span_target: as above, but in the target only
	
	elsif ($metric eq "span_target") {
		
		for ($target_id[0]..$target_id[-1]) {
		
		  $dist++ if $token_target[$_]{TYPE} eq 'WORD';
		}
	}
	
	# span_source: ditto, but source only
	
	elsif ($metric eq "span_source") {
		
		for ($source_id[0]..$source_id[-1]) {
		
		  $dist++ if $token_source[$_]{TYPE} eq 'WORD';
		}
	}
		
	return $dist;
}

sub load_stoplist {

	my ($stoplist_basis, $stopwords) = @_[0,1];
	
	my %basis;
	my @stoplist;
	
	if ($stoplist_basis eq "target") {
		
		my $file = select_file_freq($target) . '.freq_stop_' . $feature;
		%basis = %{Tesserae::stoplist_hash($file)};
	}
	
	elsif ($stoplist_basis eq "source") {
		
		my $file = select_file_freq($source) . '.freq_stop_' . $feature;

		%basis = %{Tesserae::stoplist_hash($file)};
	}
	
	elsif ($stoplist_basis eq "corpus") {

		my $file = catfile($fs{data}, 'common', Tesserae::lang($target) . '.' . $feature . '.freq');
		
		%basis = %{Tesserae::stoplist_hash($file)};
	}
	
	elsif ($stoplist_basis eq "both") {
		
		my $file_target = select_file_freq($target) . '.freq_stop_' . $feature;
		%basis = %{Tesserae::stoplist_hash($file_target)};
		
		my $file_source = select_file_freq($source) . '.freq_stop_' . $feature;
		my %basis2 = %{Tesserae::stoplist_hash($file_source)};
		
		for (keys %basis2) {
		
			$basis{$_} = 0 unless defined $basis{$_};
		
			$basis{$_} = ($basis{$_} + $basis2{$_})/2;
		}
	}
		
	@stoplist = sort {$basis{$b} <=> $basis{$a}} keys %basis;
	
	if ($stopwords > 0) {
		
		if ($stopwords > scalar(@stoplist)) { $stopwords = scalar(@stoplist) }
		
		@stoplist = @stoplist[0..$stopwords-1];
	}
	else {
		
		@stoplist = ();
	}

	return \@stoplist;
}

sub exact_match {

	my ($ref_target, $ref_source) = @_[0,1];

	my @target_id = keys %$ref_target;
	my @source_id = keys %$ref_source;
	
	my @ttokens;
	my @stokens;
		
	for (@target_id) {
	
		push @ttokens, $token_target[$_]{FORM};
	}
	
	for (@source_id) {
		push @stokens, $token_source[$_]{FORM};
	}
	
	@ttokens = @{Tesserae::uniq(\@ttokens)};
	@stokens = @{Tesserae::uniq(\@ttokens)};
	
	my @exact_match = @{Tesserae::intersection(\@ttokens, \@stokens)};
	
	return scalar(@exact_match);
}

sub score_default {
	
	my ($match_t_ref, $match_s_ref, $distance) = @_;
	
	if ($distance == 0) { return -1; }

	my %match_target = %$match_t_ref;
	my %match_source = %$match_s_ref;
	
	my $score = 0;
		
	for my $token_id_target (keys %match_target ) {
									
		# add the frequency score for this term
		
		my $freq = 1/$freq_target{$token_target[$token_id_target]{FORM}}; 
				
		# for 3-grams only, consider how many features the word matches on
				
	if ($feature eq '3gr') {
		
			$freq *= scalar(keys %{$match_target{$token_id_target}});
		}
		
		$score += $freq;
	}
	
	for my $token_id_source ( keys %match_source ) {

		# add the frequency score for this term

		my $freq = 1/$freq_source{$token_source[$token_id_source]{FORM}};
		
		# for 3-grams only, consider how many features the word matches on
				
		if ($feature eq '3gr') {
		
			$freq *= scalar(keys %{$match_source{$token_id_source}});
		}
		
		$score += $freq;
	}
	
	$score = sprintf("%.3f", log($score/$distance));
	
	return $score;
}


# save the list of multi-text searches to session file

sub write_multi_list {
	
	my ($session, $incl) = @_;
	
	my @include = @$incl;
	
	my $file_list = catfile($session, '.multi.list');
	
	open (FH, ">:utf8", $file_list) or die "can't write $file_list: $!";
	
	for (@include) {
	
		print FH $_ . "\n";
	}
	
	close FH;
}

# choose the frequency file for a text

sub select_file_freq {

	my $name = shift;
	
	if ($name =~ /\.part\./) {
	
		my $origin = $name;
		$origin =~ s/\.part\..*//;
		
		if (defined $abbr{$origin} and defined Tesserae::lang($origin)) {
		
			$name = $origin;
		}
	}
	
	my $lang = Tesserae::lang($name);
	my $file_freq = catfile(
		$fs{data}, 
		'v3', 
		$lang, 
		$name, 
		$name
	);
	
	return $file_freq;
}