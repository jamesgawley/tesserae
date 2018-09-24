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

my %cts_hash = %{$cts_hash};

my $path = catfile($fs{texts}, 'la');

my @files = grep { -d } map { catfile $path, $_ } read_dir $path;

my @sub_dirs = grep { -d } map { catfile $path, $_ } read_dir $path;

my @assigned = grep {$_ =~ /mqdq/} keys %cts_hash;

foreach my $file (@files) {

	print "$file\n";

}




























