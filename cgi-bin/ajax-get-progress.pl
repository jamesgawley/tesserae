#!/usr/bin/env perl

=head1 NAME

ajax-get-progress.pl - Retrieve progress/completion status for a task

=head1 SYNOPSIS

ajax-get-progress.pl [OPTIONS] <I<name> | --session I<session_id>> [--task I<task>]

=head1 DESCRIPTION

This script checks F<.progress> for status of ongoing tasks and prints what it finds 
there to stdout.

Meant to be called from the web interface, for drawing progress bars, figuring
out when results are ready.

Options:

=over

=item --session I<session_id>

When this option is given, the results are read not from a local, named session, but rather from a previously-created session file in C<tmp/> having id I<session_id>.  This is useful if the results you want to read were generated from the web interface.

=itme I<task>

Check .task.F<progress>, instead of F<.progress>. For batch, multi- searches.

=item B<--quiet>

Don't write progress info to STDERR.

=item B<--help>

Print this message and exit.

=back

=head1 KNOWN BUGS

The F<task> argument is unimplemented.

=head1 SEE ALSO

=head1 COPYRIGHT

University at Buffalo Public License Version 1.0.
The contents of this file are subject to the University at Buffalo Public License Version 1.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at http://tesserae.caset.buffalo.edu/license.txt.

Software distributed under the License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for the specific language governing rights and limitations under the License.

The Original Code is ajax-get-progress.pl.

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
use Beanstalk::Client;
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

# determine file from session id
my $session;
my $task;

# help flag
my $help;

my $file;

if ($no_cgi) {
   # command-line arguments

   GetOptions(
      'session=s' => \$session,
      'task=s' => \$task,
      'quiet' => \$quiet,
      'help' => \$help 
   );

   # if help requested, print usage
   if ($help) {
      pod2usage( -verbose => 2 );
   }

   $file = shift @ARGV;
} else {
   # cgi arguments

	$session = $query->param('session') || die "no session specified from web interface";
   $task = $query->param('task');

	my %h = ('-charset'=>'utf-8', '-type'=>'application/json');
	print header(%h);

	$quiet = 1;
}

if (defined $session) {
   $file = catdir($fs{tmp}, "tesresults-" . $session);
} else {
   unless (defined $file) {
      die "No session specified";
   }
}


# if it has a session id, check queue

my $queued = 0;

if (defined $session) {
   my $client = Beanstalk::Client->new({
      server => "localhost",
      default_tube => "tesserae"
   });

   if ($client->peek(hex($session))) {
      $queued = 1;
   }
}

# next, does it have a directory in tmp/
my %progress;

if (-d $file) {
   my $file_pb = catfile($file, ".progress");
   if (-e $file_pb) {
      for (1..10) {
         eval {
            open (my $fh, "<:utf8", $file_pb);
            my $jsondata = <$fh>;
            %progress = %{decode_json($jsondata)};
         };
         last unless $@;
         $progress{status} = "READ ERROR";
      }
   }
}  

if (! defined $progress{status}) {
   if ($queued) {
      $progress{status} = "QUEUED";
   } else {
      $progress{status} = "NOT FOUND";
   }
}

if (! defined $progress{progress}) {
   $progress{progress} = 0;
}

print encode_json(\%progress) . "\n";
