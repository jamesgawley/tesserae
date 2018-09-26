use strict;
use warnings;

#
# Read configuration file
#

# modules necessary to read config file

use Cwd qw/abs_path/;
use File::Spec::Functions;
use FindBin qw/$Bin/;
use Data::Dumper;

# read config before executing anything else

my $lib;

BEGIN {

	# look for configuration file
	
	$lib = $Bin;
	
	my $oldlib = $lib; # keep a copy of the cgi directory
	
	my $pointer;
			
	while (1) {

		$pointer = catfile($lib, '.tesserae.conf'); # cgi/.tesserae.conf
	
		if (-r $pointer) {
		
			open (FH, $pointer) or die "can't open $pointer: $!"; 
			
			$lib = <FH>;
			
			chomp $lib;
			
			last;
		}
									
		$lib = abs_path(catdir($lib, '..')); # move backward one folder
		
		if (-d $lib and $lib ne $oldlib) { # if the current directory exists and it's not the first directory...
		
			$oldlib = $lib;			# use the current directory next time.
			
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

## load additional modules necessary for this script

use CGI qw/:standard/;
use Storable qw(nstore retrieve);
use File::Path qw(mkpath rmtree);
use Encode;
use Lingua::Stem qw(stem);
use File::Slurp;

my $cts_ref = Tesserae::load_cts_map();

my %cts_hash = %{$cts_ref};

my $path = catfile($fs{text}, 'la');

my @files = grep { -f } map { catfile $path, $_ } read_dir $path;

@files = grep {$_ =~ /\.tess$/ } @files;

my @sub_dirs = grep { -d } map { catfile $path, $_ } read_dir $path;

my @assigned = grep {$_ =~ /latinLit\:tmv/} values %cts_hash;

@assigned = sort @assigned;

foreach my $file (@files) {

	$file =~ s/^.+?\/la\///;

	$file =~ s/\.tess$//;
	
	# if the work doesn't currently have a cts urn...
	
	unless ($cts_hash{$file}) {
	
		#find out if there's a partial match for the author
		
		my $author = $file;
		
		$author =~ s/^(.+)\..+$/$1/;
	
		# make a list of all the hashes that exactly match this author name
	
		my @same_author = grep {$_ =~ /^$author\./} keys %cts_hash; 
		
		# convert those text names to cts text urns
		
		my @same_author_urns;
		
		foreach my $text (@same_author) {
		
			push @same_author_urns, $cts_hash{$text};
		
		}
		
		my $author_urn; # the whole urn up to and including the number of the author
		
		my $textnumber; #the number of the text, the last part of the urn (no 'tmv')
		
		my $text_id; # this will contain the full text identification string, including collection.

		my $text_urn; # the entire urn
		
		if (scalar @same_author_urns > 0) { # scenarios where this author has been seen before

			# find the author urn and make sure all the entries with the $author string have that urn
		
			$same_author_urns[0] =~ /^(.+\:latinLit\:[a-zA-Z]+\d+)/;
			
			$author_urn = $1;
		
			my @verification = grep {$_ =~ $author_urn} values @same_author_urns;
			
			unless (scalar @same_author_urns == scalar @verification) {
			
				print "\nAuthor urn string: $author_urn\n";
			
				for (0..$#same_author_urns) {
				
					print "$same_author_urns[$_] \t $same_author[$_]\n";
				
				}
				
				print "\n verification: \n";
				
				foreach my $auth (@verification) {
				
					print "$auth\n";
				
				}
				
				die "Unable to verify that all urns for $author match";
			
			}
			
			# make up a new document id # for this thing
			
			# start by finding the highest assigned id # so far. alphanumeric sorting should be fine.

			#find out if any texts from this author have already been added to the tmv collection
			
			@same_author_urns = grep {$_ =~ /\.tmv\d+/} @same_author_urns;

			if (scalar @same_author_urns > 0) {
				#if some of these are tmv texts, it's necessary to find all the tmv text ids
				
				my @tmv_ids;
				
				foreach my $urn (@same_author_urns) {
					
					$urn =~ /\.tmv(\d+)/;
					
					push @tmv_ids, $1;
				
				}
			
				@tmv_ids = sort {$b cmp $a} @tmv_ids;
				
				$textnumber = $tmv_ids[0] + 1;
				
				#The author id comes from the other collection, but the text id comes from us
				
				# scenario 1: the author exists only in another collection so far; all author urns the same
				
				# scenario 2: the author originally came from another collection but we've seen him before; all author urns the same
				
				#scenario 3: the author exists only in the tmv collection but he's been seen before; all author urns the same
				
				$text_urn = $author_urn . ".tmv" . sprintf("%03d", $textnumber);
				

			}
			else { #if they're all from another collection, then start from 1
			
				#name the author after the other collection
			
				$text_urn = $author_urn . ".tmv" . sprintf("%03d", 1);
			
			}		
			
			# this completes the scenarios where the author exists somewhere in the collection
		
		}
		else {
			# if the author is new, he needs an author id assignment and a text id #
		
			#find the highest currently assigned author id.
			
			my $high_id = 0;
			
			if ($assigned[$#assigned]) {
			
				$assigned[$#assigned] =~ /\latinLit\:tmv(\d+)/;
				
				$high_id = $1;
							
			}

			
			my $author_id = $high_id + 1;
			
			$author_urn = "urn:cts:latinLit:tmv" . sprintf("%04d", $author_id);
			
			$text_id = "tmv" . sprintf("%03d", 1);
			
			$text_urn = "$author_urn.$text_id";
		
			push @assigned, $text_urn;
						
		}
		
		$cts_hash{$file} = $text_urn;
		
		#print "$file => $text_urn\n";
	
	}

}

# now add all the subdirectory files

foreach my $path (@sub_dirs) {

	# get all the subdirectory files
	
	my @fragments = grep { -f } map { catfile $path, $_ } read_dir $path;
	
	foreach my $sub_text (@fragments) {
	
		#get the name of the fragment file
		
		$sub_text =~ /\/la\/.+\/(.+)\.part\.(\d+)/;
		
		$cts_hash{"$1.part.$2"} = "$cts_hash{$1}:$2";
	
	}

}

my $cts_filepath = catfile($fs{data}, 'common', 'cts_list.py');

open my $ctsfile, ">:utf8", $cts_filepath or die $!;

print $ctsfile "{";

my @sorted_titles = sort keys %cts_hash;

for (0..$#sorted_titles) {

	my $text = $sorted_titles[$_];

	print $ctsfile "'$text':'$cts_hash{$text}'";
	
	unless ($_ == $#sorted_titles) {
	
		print $ctsfile ",\n";
	
	}

}

print $ctsfile "}";

my $search_path = build_cts_path('lucan.bellum_civile', 'vergil.aeneid');
print $search_path;




















