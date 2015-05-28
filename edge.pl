# This script is intended to modify tesresults data to replace score information with the distance from the edge of the line/phrase. James Gawley, April 2015
use Getopt::Long;
use Storable qw(nstore retrieve);
use Data::Dumper;
use FindBin;
#use Tesserae;
my $unit = 'phrase';
my $edge = 'beginning';
my $edge_measure = 'target';
my $comp = 'target';
my $bargraph = 'none';
my $quiet = 0;
my $random = 0;
GetOptions (
	'bargraph=s' => \$bargraph,
	'quiet' => \$quiet,
	'random' => \$random,
	'unit=s' => \$unit,
	'edge=s' => \$edge, #Options are 'beginning', 'end', or 'both' (the latter chooses the closest edge)
	'edge-measure=s' => \$edge_measure,	#When considering only the closest edge, which poem determines the boundary to use?
	'compare=s' => \$comp # Which poem's matchword locations should be considered? Options are 'target', 'source', or 'both'. The latter option compares the edge distance in one poem to the edge distance in the other. What 'distance' means depends on the value of $edge.
);
my %target   = %{ retrieve("$FindBin::Bin/$ARGV[0]") }; #First argument is the match.target file
my @data   = @{ retrieve("$FindBin::Bin/$ARGV[1]") }; # Second argument is the data/v3/_.phrase file for the target
my %score   = %{ retrieve("$FindBin::Bin/$ARGV[2]") }; # The third argument is the tesresults match.score file	
my @source_data   = @{ retrieve("$FindBin::Bin/$ARGV[3]") }; # Fourth argument is the data/v3/_.phrase or .line file for the source
my %source   = %{ retrieve("$FindBin::Bin/$ARGV[4]") }; # Fifth argument is the match.source file
my @target_tokens   = @{ retrieve("$FindBin::Bin/$ARGV[5]") }; # Sixth argument is the data/v3/_.phrase file, which is used to check whether random TOKEN_IDs are words or not.
my $token_line_numbers;
#If the unit is line, not phrase, invert the array of line->tokenID which would be stored in the @data array.
if ($unit eq 'line') {
	for (0..$#data) { #open each lineID and pull out the tokens
		
		my $linenumber = $_;
		
		my @toks = @{${$data[$_]}{'TOKEN_ID'}}; #@data is an array filled with hashes, whose 'TOKEN_ID' keys contain arrays
		foreach my $tokid (@toks) {
			$token_line_numbers[$tokid] = $linenumber; #This should result in array whose keys are token IDs, and which contains corresponding line ids		
			
		}
	}
}
my $source_line_numbers;
if ($unit eq 'line') {
	for (0..$#source_data) { #open each lineID and pull out the tokens
		
		my $linenumber = $_;
		
		my @toks = @{${$source_data[$_]}{'TOKEN_ID'}}; #@data is an array filled with hashes, whose 'TOKEN_ID' keys contain arrays
		foreach my $tokid (@toks) {
			$source_line_numbers[$tokid] = $linenumber; #This should result in array whose keys are token IDs, and which contains corresponding line ids		
			
		}
	}
}
my @hist_array_target;
for (0..9) { 
	$hist_array_target[$_] = 0;
}
foreach $phrase_id_target (keys %target) {
	foreach $phrase_id_source (keys %{$target{$phrase_id_target}}) {
		#create an array to store the token IDs for this match.
		my @token_ids;
		foreach $token_id_target (keys %{$target{$phrase_id_target}{$phrase_id_source}}) {
			push (@token_ids, $token_id_target);
		}
		
		#Load the array of token IDs of matchwords in the source document
		my @source_token_ids;
		foreach $token_id_source (keys %{$source{$phrase_id_target}{$phrase_id_source}}) {
			push (@source_token_ids, $token_id_source);
		}
		
		
		
		#At this point, sort the token ids. This is necessary to look at first or last matchwords.
		my @token_ids = sort { $a <=> $b } @token_ids;
		my @source_token_ids = sort { $a <=> $b } @source_token_ids;
				
		#Now we have the first (or last) Token ID in the match, along with its unit ID in both target and source.
		#Compare the Token ID of the first matchword with the Token ID of the first word in the phrase itself.
		my $unit_id_target;
		my $unit_id_source;
		my %unit_hash_target; #If $edge = 'both', then there will be multiple lines for each matching phrase.
		my %unit_hash_source;
		if ($unit eq 'phrase') {
			$unit_id_target = $phrase_id_target;
			$unit_id_source = $phrase_id_source;			
		}	
		if ($unit eq 'line') {
			if ($edge eq 'beginning') {
				$unit_id_target = $token_line_numbers[$token_ids[0]]; # This should return the line id # of the line containing the first matchword in the intertextual phrase
				$unit_id_source = $source_line_numbers[$source_token_ids[0]]; 
			}
			if ($edge eq 'end') {
				$unit_id_target = $token_line_numbers[$token_ids[$#token_ids]]; # This should return the line id # of the line containing the first matchword in the intertextual phrase
				$unit_id_source = $source_line_numbers[$source_token_ids[$#source_token_ids]];
			}
			
			 if ($edge eq 'both') {
			 	foreach my $match_id (@token_ids) { 			# For every matchword's token ID...
			 		my $line = $token_line_numbers[$match_id];	# retrieve the line ID...
			 		$unit_hash_target{$line} = 1; 				# and store it as a hash key.
			 	}
			 	foreach my $match_id (@source_token_ids) { 		# Do the same for the source phrase.
			 		my $line = $source_line_numbers[$match_id];	
			 		$unit_hash_source{$line} = 1; 				
			 	}
			 	
			 }
		}
		unless ($quiet == 1) {
			unless ($edge eq 'both') {
				print "Target phrase ID: $phrase_id_target \t Line: $unit_id_target Tokens: " . join (" ", @token_ids);
				print "\nSource phrase ID: $phrase_id_source \t Line: $unit_id_source Tokens: " . join (" ", @source_token_ids);
			}
			if ($edge eq 'both') {
				print "Target phrase ID: $phrase_id_target \t Lines: " . join (',', (keys %unit_hash_target)) . "Tokens: " . join (" ", @token_ids);
				print "\nSource phrase ID: $phrase_id_source \t Lines: " . join (',', (keys %unit_hash_source)) . "Tokens: " . join (" ", @source_token_ids);		
			}		
		}
		my @tok_array;
		my %tok_hash;
		my @source_array;
		my %source_hash;
		unless ($edge eq 'both') { #Retrieve the token IDs contained in the pertinent line.
			my %unit_hash = %{$data[$unit_id_target]};
			my %source_unit_hash = %{$source_data[$unit_id_source]};
			@tok_array = @{$unit_hash{'TOKEN_ID'}};
			@source_array = @{$source_unit_hash{'TOKEN_ID'}};		
		}
		else { #If there's more than one line involved, there should be a whole set of tokenIDs.
			foreach my $match_id (keys %unit_hash_target) {
				my %line_hash = %{$data[$match_id]};
				$tok_hash{$match_id} = \@{$line_hash{'TOKEN_ID'}}; #This hash is now key: lineID of a line from the target with a matchword in it; value: all the tokenID from that line.
			}
			foreach my $match_id (keys %unit_hash_source) {
				my %line_hash = %{$source_data[$match_id]};
				$source_hash{$match_id} = \@{$line_hash{'TOKEN_ID'}}; #This hash is now key: lineID of a line from the target with a matchword in it; value: all the tokenID from that line.
			}									
		}
		
		unless ($quiet == 1) {	
			unless ($edge eq 'both') {
				print "\nTokens in target phrase: " . join (' ', @tok_array);
				print "\nTokens in source phrase: " . join (' ', @source_array);
			}
			else {
				print "\nTokens in target lines:";
				foreach my $lineID (keys %tok_hash) {
					print "\n\tLine $lineID: " . join (',', @{$tok_hash{$lineID}});
				} 
				print "\nTokens in source lines:";
				foreach my $lineID (keys %source_hash) {
					print "\n\tLine $lineID: " . join (',', @{$source_hash{$lineID}});
				} 				
			}
		}
	
	
	
		######
		#Generate the bargraph.
		######

			my $barscore = "";
			my @rand_words;
			#Generate random bargraph results to replace the real ones if --random is flagged.
			for my $it (0..$#token_ids) {

				#Currently assumes $edge is set to $both, and therefore more than one line has to be accounted for.
				my @ids;
				foreach my $line_id (keys %tok_hash) {
					push (@ids, $line_id);
				}
				
				
				my $chosen_line = int(rand($#ids+1));
				print "\nChosen line: $ids[$chosen_line]. Selection of lines: " . join (' ', @ids);
				my @chosen_array = @{$tok_hash{$ids[$chosen_line]}}; #This should be an array of token ids from the randomly selected line that's part of the match.
				my $chosen_token = int(rand($#chosen_array));
				my $chosen_token = int(rand($#chosen_array));
				my $chosen_token = int(rand($#chosen_array));
				if (${$target_tokens[$chosen_array[$chosen_token]]}{'TYPE'} ne 'WORD') {#Check whether this token is a word or something else. @target_tokens
					print "\nNon-word token: $chosen_array[$chosen_token] ${$target_tokens[$chosen_array[$chosen_token]]}{'TYPE'}";
#					my $useless = <STDIN>;		
					$chosen_token++;
					print "\nNew token: $chosen_array[$chosen_token] ${$target_tokens[$chosen_array[$chosen_token]]}{'TYPE'}";
#					my $useless = <STDIN>;		
					if ($#chosen_array < $chosen_token or ${$target_tokens[$chosen_array[$chosen_token]]}{'TYPE'} ne 'WORD') {
						srand();
						redo;
					}
					else {
						print "\nSuccess!!!"
					}
				}
				my $noflag = 0;
				foreach my $prev (@rand_words) {
					if ($prev == $chosen_array[$chosen_token]) {
						$noflag++;
						print "\nPreviously used token: $chosen_array[$chosen_token]." . join (' ', @rand_words);
					}
				}
				if ($noflag > 0) {
					srand();
					redo;
				}
		
				$rand_words[$it] = $chosen_array[$chosen_token];
				
			} #Now there should be an array of equal size to the @token_ids array which contains randomly chosen tokens from that phrase, spread out randomly over all involved lines.
			

			print "\nRandom token array: " . join (',', @rand_words);
			
		my @alph = ("A".."Z");
		for my $pos (0..$#token_ids) {
			my $match_id;
			if ($random == 0) {
				$match_id = $token_ids[$pos];
			}
			else {
				$match_id = $rand_words[$pos];
			}

			#For each token ID of a matchword, retrieve the set of token ids from its line in the target
			my $line_id = $token_line_numbers[$match_id];
			my %line_hash = %{$data[$line_id]};
			my @line_array = @{$line_hash{'TOKEN_ID'}};
	
			#
			if ($bargraph eq 'compressed') {			
				#Grab the first and last token ID for the line, take the difference, divide by ten.
				$tenth = ($line_array[$#line_array] - $line_array[0]) / 10;
			
				#Build an array of delineations between the 1st and tenth 10% groupings
				#Save the information to replace the score if the --bargraph flag is set.
				# $barscore will contain the percentile locations of every matchword as a string.
				# This way, the results can be later filtered by rank or commentator parallel and the location info retrieved and counted.
				my @increment;
				for (0..9) {
					$increment[$_] = $line_array[0] + (($_ + 1) * $tenth);
				}
				#For each step in the increment array, 
				foreach my $i (0..$#increment) {
					if ($match_id <= $increment[$i]) { #This tests what percentile we're in. 
						my $perc = $i;
						$hist_array_target[$i]++;
						$barscore .= "$i";
						print "\nMatch ID: $match_id";
						print "\nPercentile info: $barscore";
#						my $useless = <STDIN>;
						last;
					}
				}
			}
			if ($bargraph eq 'natural') {						
				my $num = $match_id - $line_array[0];
				$barscore .= "$alph[$num]";
				print "\nMatch ID: $match_id";
				print "\nPercentile info: $barscore";

			}
			
		}
		my $edge_distance;
		if ($edge eq 'beginning') { #the 'edge' value determines whether distance is measured from the beginning or the end of a unit.
			if ($comp eq 'target') {
				$edge_distance = $token_ids[0] - $tok_array[0];
			}
			if ($comp eq 'source') {
				$edge_distance = $source_token_ids[0] - $source_array[0];
			}
			if ($comp eq 'both') {
				my $target_distance = ($token_ids[0] - $tok_array[0]) / 2;
				my $source_distance = ($source_token_ids[0] - $source_array[0]) / 2;
				$edge_distance = abs($target_distance - $source_distance);
			}
		}
		if ($edge eq 'end') {
			if ($comp eq 'target') {
				$edge_distance = $tok_array[$#tok_array] - $token_ids[$#token_ids];
			}
			if ($comp eq 'target') {
				$edge_distance = $source_array[$#tok_array] - $source_token_ids[$#source_token_ids];
			}
			if ($comp eq 'both') {
				my $target_distance = ($tok_array[$#tok_array] - $token_ids[$#token_ids]) / 2;
				my $source_distance = ($source_array[$#source_array] - $source_token_ids[$#source_token_ids]) /2;
				$edge_distance = abs($target_distance - $source_distance);
			}
			print "\nLast token in target line: $tok_array[$#tok_array]\tLast token in match: $token_ids[$#token_ids]";
			print "\nLast token in source line: $source_array[$#source_array]\tLast token in match: $source_token_ids[$#source_token_ids]";
		}
		
		if ($edge eq 'both') {
			#The 'edge = both' feature takes the lesser of the two distances: beginning or end. 
			#This value is generated for each poem, and so that target, source, or the difference between them can be considered.
			#calculate both distances (end and beginning) for the target
			
			# It's necessary to retrieve the line arrays (of all token ids in the line) for both the first and last matchwords.
			# Pull the line ids for the first and last lines.
			# This insane dereference: @{$unit_hash_target{$token_line_numbers[$token_ids[0]]}} gives the array of tokens in the line which contains the first matchword.
			print "\n First token: $token_ids[0]";
			print "\n First token's line number: $token_line_numbers[$token_ids[0]]";
			print "\n First token's line's array reference: $tok_hash{$token_line_numbers[$token_ids[0]]}";
			print "\n First matchword's line: " . join (',',  @{$tok_hash{$token_line_numbers[$token_ids[0]]}});
			print "\n First Token_ID: ${$tok_hash{$token_line_numbers[$token_ids[0]]}}[0]";
			print "\n Last matchword's line: " . join (',',  @{$tok_hash{$token_line_numbers[$token_ids[$#token_ids]]}});	
			print "\n Last Token_ID ${$tok_hash{$token_line_numbers[$token_ids[$#token_ids]]}}[$#{$tok_hash{$token_line_numbers[$token_ids[$#token_ids]]}}]";	
			
				
			my $target_distance_beginning = abs($token_ids[0] - ${$tok_hash{$token_line_numbers[$token_ids[0]]}}[0]) / 2;
			my $target_distance_end = abs(${$tok_hash{$token_line_numbers[$token_ids[$#token_ids]]}}[$#{$tok_hash{$token_line_numbers[$token_ids[$#token_ids]]}}] - $token_ids[$#token_ids]) / 2;
			print "\nEdge dist. beginning: $target_distance_beginning";
			print "\nEdge dist. end: $target_distance_end";
			#same for source
			my $source_distance_beginning = abs($source_token_ids[0] - $source_array[0]) / 2;						
			my $source_distance_end = abs($source_array[$#source_array] - $source_token_ids[$#source_token_ids]) /2;
			my $source_distance_beginning = abs($source_token_ids[0] - ${$source_hash{$source_line_numbers[$source_token_ids[0]]}}[0]) / 2;
			my $source_distance_end = abs(${$source_hash{$source_line_numbers[$source_token_ids[$#source_token_ids]]}}[$#{$source_hash{$source_line_numbers[$source_token_ids[$#source_token_ids]]}}] - $source_token_ids[$#source_token_ids]) / 2;
			#figure out which is smaller: beginning or end
			my $target_distance;
			if ($target_distance_beginning < $target_distance_end) {
				$target_distance = $target_distance_beginning;
			}
			else {
				$target_distance = $target_distance_end;
			}
			my $source_distance;
			if ($source_distance_beginning < $source_distance_end) {
				$source_distance = $source_distance_beginning;
			}
			else {
				$source_distance = $source_distance_end;			
			}
			if ($comp eq 'both') {
				$edge_distance = abs($target_distance - $source_distance);
			}
			if ($comp eq 'target') {
				$edge_distance = $target_distance;
			}
			if ($comp eq 'source') {
				$edge_distance = $source_distance;
			}
		}
		
		if ($comp ne 'both') {
			$edge_distance = $edge_distance; #Tesserae tokens include both blank spaces and punctuation. 
			# Since is it impossible to account for punctuation once results have been calculated, the division by two only accounts for the tokens which 
			# consist of spaces between words.
		}
		if ($bargraph ne 'none') {
			print "\n'Barscore': '$barscore'\n";
			$barscore =~ s/0/A/g;
			$barscore =~ s/1/B/g;
			$barscore =~ s/2/C/g;
			$barscore =~ s/3/D/g;						
			$barscore =~ s/4/E/g;			
			$barscore =~ s/5/F/g;			
			$barscore =~ s/6/G/g;
			$barscore =~ s/7/H/g;
			$barscore =~ s/8/I/g;
			$barscore =~ s/9/J/g;
			print "Converted: $barscore";
			$edge_distance = "\"$barscore\"";
		}
		
		print "\nEdge distance: $edge_distance\n";
#		my $useless = <STDIN>;
		
#		print "Target phrase: $phrase_id_target \t Source phrase: $phrase_id_source \t First matchword: $token_ids[0] Edge distance: $edge_distance\n";
		${$score{"$phrase_id_target"}}{"$phrase_id_source"} = $edge_distance;
		
#		print join (' ', @tok_array);
#		my $useless = <STDIN>;
		
	}
}
for my $i (0..$#hist_array_target) {
	print "$i: $hist_array_target[$i]\n";
}
print "(" . join (',', @hist_array_target) . ")\n";
nstore \%score,  "$ARGV[2]";
