#!/usr/bin/env perl

=head1 NAME

daemon-search.pl - run searches queued from the web

=head1 SYNOPSIS

daemon-search.pl &

=head1 DESCRIPTION

Checks the beanstalk tube "tesserae" for jobs queued using init-session.pl,
and runs them when they arrive.

=head1 OPTIONS AND ARGUMENTS

=item B<--help>

Print usage and exit.

=back

=head1 KNOWN BUGS

=head1 SEE ALSO

=head1 COPYRIGHT

University at Buffalo Public License Version 1.0.
The contents of this file are subject to the University at Buffalo Public License Version 1.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at http://tesserae.caset.buffalo.edu/license.txt.

Software distributed under the License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for the specific language governing rights and limitations under the License.

The Original Code is daemon-search.pl.

The Initial Developer of the Original Code is Research Foundation of State University of New York, on behalf of University at Buffalo.

Portions created by the Initial Developer are Copyright (C) 2007 Research Foundation of State University of New York, on behalf of University at Buffalo. All Rights Reserved.

Contributor(s): Chris Forstall

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

use Beanstalk::Client;
use JSON;
use Data::Dumper;

# initialize some variables

my $help = 0;
my $logfile = catfile($fs{tmp}, "deamon-search.log");

# get user options

GetOptions(
	'help'  => \$help
);

# print usage if the user needs help
	
if ($help) {

	pod2usage(1);
}

# connect to beanstalk tube
my $client = Beanstalk::Client->new({
   server => "localhost",
   default_tube => "tesserae"
});

# loop forever
while (1) {
   my $job = $client->reserve;
   my $ref_search = decode_json($job->data);

   # run tesserae search;
   run_tess_search($job->id, $ref_search);

   $job->delete;   
}

#
# subroutines
#

# run a tesserae search
sub run_tess_search {
   my ($id, $ref) = @_;
   
   my %params = %$ref;

   $params{session} = sprintf("%08x", hex($id));

   my $command = join(" ",
      catfile($fs{cgi}, "read-table.pl"),
      map {join(" ", "--$_", $params{$_})} keys %params
   );

   my $fh;
   eval {
      open ($fh, ">>:utf8", $logfile)
   };
   if ($@) {
      warn "Can't write to log $logfile: $@"
   } else {
      my $date = localtime;
      print $fh join("\t", $date, $id, $command) . "\n";
      close($fh)
   }
   
   system($command);
}
