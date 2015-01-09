#!/usr/bin/env perl

=head1 NAME

textlist.pl - create dropdown lists for web interface

=head1 SYNOPSIS

textlist.pl I<LANG> [I<LANG> ...]

=head1 DESCRIPTION

Create html snippets containing <select> elements which will be imported
by the advanced search page on the web interface.

=head1 OPTIONS AND ARGUMENTS

=head1 KNOWN BUGS

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

The Original Code is textlist.pl.

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

# load additional modules necessary for this script

use Storable qw(nstore retrieve);
use File::Basename;

#
# these lines set language-specific variables
# such as what is a letter and what isn't
#

my %abbr;
my $file_abbr = catfile($fs{data}, 'common', 'abbr');
	
if ( -s $file_abbr )	{  %abbr = %{retrieve($file_abbr)} }

my %lang;
my $file_lang = catfile($fs{data}, 'common', 'lang');

if (-s $file_lang )		{ %lang = %{retrieve($file_lang)} }

#
# get files to be processed from cmd line args
#  - sort into two bins: complete texts and partial
#

while (my $lang = shift @ARGV) {

	my @text = @{Tesserae::get_textlist($lang, -sort => 1)};

	my @full;
	my %part;
	
	for my $file_name (@text) {
	
		if ($file_name =~ /(.*)\.part\.(.*)/) {
		
			my ($work_name, $part_name) = ($1, $2);
			
			if ($part_name =~ /\.(.*)/) {
			
				$part_name = $1;
			}
			else {
			
				$part_name = "Book " . $part_name;
			}
		
			push @{$part{$work_name}}, {
				file => $file_name,
				part => $part_name};
		}
		else {
		
			push @full, $file_name;
		}
	} 

	#
	# write three textlists: source, target, multi
	#                                                     

                   
	my $base = catfile($fs{html}, "textlist.$lang");
	
	dropdown("$base.l.php", \@full);
	dropdown("$base.r.php", \@full, \%part);
}

#
# convert file name to nice display name
#

sub display {

	my $name = shift;
	
	my $display = $name;

	$display =~ s/\./ - /g;
	$display =~ s/\_/ /g;

	$display =~ s/(^|\s)([[:alpha:]])/$1 . uc($2)/eg;

	return $display;
}

#
# populate dropdown
#

sub dropdown {

	my ($file, $full, $part) = @_;
	my @full = @$full;
	my %part = $part ? %$part : ();
	
	open (FH, ">:utf8", $file) or die "can't write to $file: $!";
	
	for my $name (@full) {

		my $category  = Tesserae::check_prose_list($name) ? 'prose' : 'verse';

		if (defined $part{$name}) {
		
			print FH sprintf("<optgroup label=\"%s\">\n", display($name));
			
			print FH sprintf("   <option value=\"%s\">%s - Full Text</option>\n", 
				$name, 
				display($name));
	
			for (@{$part{$name}}) {
				
				my $file_name = $_->{file};
				my $part_name = $_->{part};
				
				print FH sprintf("   <option value=\"%s\" class=\"%s\">%s - %s</option>\n",
						$file_name,
						$category,
				      display($name),
				      display($part_name));
			}
			
			print FH "</optgroup>\n";
		}
		else {
		
			print FH sprintf("<option value=\"%s\" class=\"%s\">%s</option>\n",
				$name,
				$category,
				display($name));
		}
	}
	
	close FH;
}

