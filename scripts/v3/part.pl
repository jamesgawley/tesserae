#!/usr/bin/env perl

=head1 NAME

part.pl - partition tesserae texts

=head1 SYNOPSIS

part.pl [options] NAME [, NAME, ...]

=head1 DESCRIPTION

Reads the *already ingested* text and tries to create useful divisions. 
Produces a table linking human-friendly part numbers to token ids for use with
the I<--mask-target-first>, I<--mask-target-last>, I<--mask-source-first>, and
I<--mask_source-last> flags.

=head1 OPTIONS AND ARGUMENTS

=over

=item I<NAME>

Name of tesserae text[s].

=item B<--quiet>

Don't print debugging info to stderr.

=item B<--help>

Print usage and exit.

=back

=head1 KNOWN BUGS

=head1 SEE ALSO

=head1 COPYRIGHT

University at Buffalo Public License Version 1.0.
The contents of this file are subject to the University at Buffalo Public License Version 1.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at http://tesserae.caset.buffalo.edu/license.txt.

Software distributed under the License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for the specific language governing rights and limitations under the License.

The Original Code is part.pl.

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

use Storable;
use Data::Dumper;
use JSON;

# initialize some variables

my $quiet = 0;
my $help = 0;

# get user options

GetOptions(
    'quiet' => \$quiet,
	'help' => \$help
);

# print usage if the user needs help
	
if ($help) {

	pod2usage(1);
}

# get files to be processed from cmd line args

my @files = @ARGV;
my @names = sort @{Tesserae::process_file_list(\@files)};

unless (@names) {

	print STDERR "No files specified\n";
	pod2usage(2);
}

for my $name (@names) {
    my $file = catfile($fs{data}, 'v3', Tesserae::lang($name), $name, $name);
    my @line;
    
    # try to load tokens; if this fails, the text isn't installed
    eval {
        @line = @{retrieve("$file.line")};
    };
    if ($@) {
        warn "$name: Storable error \"$@\". Did you run add_column? Skipping.";
        next;
    }
    
    # look for major divisions
    my @div = @{major_div(\@line)};
        
    # if there are too many top-level division, group them
    # if (scalar(@line)/scalar(@div) < 500) {
    #   @div = @{regroup(\@div)};
    # }
    
    if ($#div == 0) {
        $div[0]{name} = "Full Text";
    } else {
        unshift @div, {
          name => "Full Text",
          first => 0,
          last => $div[-1]{last}  
        };
    }
    
    print join("\t", $name, encode_json(\@div)) . "\n";
}


# subroutines

sub major_div {
    my $ref = shift;
    my @line = @$ref;
    
    my @div=({name=>"__OMIT__"});
    
    for my $line_id (0..$#line) {
        my $loc = $line[$line_id]{LOCUS};
        
        my @loc_seg = split(/\./, $loc);
        my $this_div;
        if ($#loc_seg > 0) {
            $this_div = $loc_seg[0];
        } else {
            $this_div = "#";
        }
        
        if ($this_div ne $div[-1]{name}) {
            $div[-1]{last} = $line_id-1;
            push @div, {name=>$this_div, first => $line_id};
        }
    }
    
    $div[-1]{last} = $#line;
    shift @div;

    return \@div;
}

sub regroup {
    my $ref = shift;
    my @div = @$ref;
    
    if ($#div < 1) {
        return \@div;
    }
    
    my $nlines = $div[-1]{last};
    
    my $half = int(scalar(@div) / 2);
    
    my $groupsize;
    my $best_score = 100000;
    
    for ($half, 10, 5, 2) {
        my $wholegroups = int(scalar(@div) / $_);
        my $leftoverdiv = scalar(@div) % $_;
        
        my $last_line_whole = $div[$wholegroups*$_-1]{last};
        my $avg_lines_whole = int($last_line_whole/$wholegroups);
        my $leftoverlines = $nlines - $last_line_whole;
        
        my $diff_avg = abs(900 - $avg_lines_whole);
        my $diff_left = abs(450 - abs(450 - $leftoverlines));

        my $score = $diff_avg + $diff_left;
                
        if ($score < $best_score) {
            $groupsize = $_;
            $best_score = $score;
        }
    }
                    
    my @newdiv;
    my $wholegroups = int(scalar(@div) / $groupsize);
    
    for (my $i = 0; $i <= $wholegroups - 1; $i++) {
        my $firstdivid = $i * $groupsize;
        my $lastdivid = ($i + 1) * $groupsize - 1;
        $newdiv[$i]{first} = $div[$firstdivid]{first};
        $newdiv[$i]{last} = $div[$lastdivid]{last};
        $newdiv[$i]{name} = join("-", $div[$firstdivid]{name}, $div[$lastdivid]{name});
    }

    my $firstdivleft = $wholegroups * $groupsize;
    my $firstlineleft = $div[$firstdivleft]{first};
    my $nleft = $div[-1]{last} - $firstlineleft;
    
    if ($nleft > 300) {
        push @newdiv, {
            first => $firstlineleft,
            last => $div[-1]{last},
            name => join("-", $div[$firstdivleft]{name}, $div[-1]{name})
        };
    }
    else {
        $newdiv[-1]{last} = $div[-1]{last};
        
        my @oldname = split(/-/, $newdiv[-1]{name});
        $newdiv[-1]{name} = join("-", $oldname[0], $div[-1]{name});
    }
    
    return \@newdiv;
}
