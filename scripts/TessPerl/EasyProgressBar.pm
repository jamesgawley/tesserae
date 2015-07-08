require Exporter;
use POSIX ();
use File::Spec::Functions;
use JSON;

our @ISA = qw(Exporter);

our @EXPORT = qw(ProgressBar AJAXProgress);

# how to draw a simple progress bar

package ProgressBar;
	
sub new {
	my $self = {};
	
	shift;
	
	my $terminus = shift || die "ProgressBar->new() called with no final value";
	
	$self->{END} = $terminus;
	
	my $quiet = shift || 0;
	
	$self->{COUNT}    = 0;
	$self->{PROGRESS} = 0;
	$self->{DONE}     = 0;
	$self->{T0}       = time;
	$self->{QUIET}    = $quiet;
	
	bless($self);
	
	$self->draw();
		
	return $self;
}

sub advance {

	my $self = shift;
	
	my $incr = shift;
	
	$self->{COUNT} += ($incr || 1);
	
	if ($self->{COUNT}/$self->{END} > $self->{PROGRESS} + .025) {
		
		$self->{PROGRESS} = $self->{COUNT} / $self->{END};

		$self->draw();
	}
	
	if ($self->{COUNT} >= $self->{END}) {
	
		$self->finish();
	}
}

sub set {

	my $self = shift;
	
	my $new = shift || 0;
	
	$self->{COUNT} = $new;
	
	$self->draw();
}

sub draw {

	my $self = shift;
		
	unless ($self->{QUIET} or $self->{DONE}) {
		
		my $bars = POSIX::floor($self->{PROGRESS} * 40);
	
		print STDERR "\r" . "0% |" . ("#" x $bars) . (" " x (40 - $bars)) . "| 100%" ;
	}
}

sub finish {

	my $self = shift;

	unless ($self->{QUIET} or $self->{DONE}) {

		print STDERR "\r" . "0% |" . ("#" x 40) . "| 100%\n";
	}
	
	$self->{DONE} = 1;	
}

sub progress {
	
	my $self = shift;
	
	return $self->{PROGRESS};
}

sub count {

	my $self = shift;
	
	return $self->{COUNT};
}

sub terminus {

	my $self = shift;
	
	my $new = shift;
	
	if (defined $new) {
	
		$self->{END} = $new;
		
		$self->draw();
	}
	
	return $self->{END};
}


#
# AJAX progress bar
# 

package AJAXProgress;

sub new {
	my $self = {};
	
	shift;
	
	my $terminus = shift;
	
	$self->{END} = $terminus;
	
	my $session = shift;
	
	$self->{COUNT} = 0;
	$self->{PROGRESS} = 0;
	$self->{FILE} = File::Spec::Functions::catfile($session, ".progress");
	$self->{DONE} = 0;
   $self->{T0} = time;
	$self->{MESSAGE} = "Please wait...";
   $self->{STATUS} = "WORKING";
	
	bless($self);
	
	$self->init();
	
	$self->draw();
	
	return $self;
}

sub init {

	$| = 1;

	print "<div class=\"pr_container\">\n";
	print "<table class=\"pr_bar\">\n";
	print "<tr>";
	print "<td class=\"pr_spacer\">0%</td>";
	print "<td class=\"pr_spacer\"></td>" x 38;
	print "<td class=\"pr_spacer\">100%</td>";
	print "</tr>\n";
	print "<tr>";
}

sub advance {

	my $self = shift;
	
	my $incr = shift;
	
	$self->{COUNT} += ($incr || 1);
	
	$self->draw();
}

sub set {

	my $self = shift;
	
	my $new = shift || 0;
	
	$self->{COUNT} = $new;
	
	$self->draw();
}

sub draw {

	my $self = shift;

	return if $self->{DONE};
		
	if ($self->{COUNT}/$self->{END} > $self->{PROGRESS} + .025) {
	
		my $oldbars = POSIX::floor($self->{PROGRESS} * 40);
	
		$self->{PROGRESS} = $self->{COUNT} / $self->{END};
	
		my $bars = POSIX::floor($self->{PROGRESS} * 40);
									
		my $add = "<td class=\"pr_unit\">.</td>" x ($bars - $oldbars);
	
		print $add;
	}
	
	if ($self->{COUNT} >= $self->{END}) {
				
		$self->finish();
	}

	return $self;
}

sub advance {
	my ($self, $incr) = @_;

	$self->{COUNT} += ($incr || 1);	
	$self->check_incr;
}

sub set {
	my ($self, $new) = @_;
	
   if (defined $new) {
      $self->{COUNT} = $new;
      $self->check_incr;
   }
}

sub check_incr {
   my $self = shift;
   
   return if $self->{DONE};

   if ($self->{COUNT}/$self->{END} > $self->{PROGRESS} + .005) {
      $self->draw;
   } elsif ($self->{COUNT} >= $self->{END}) {
      $self->finish;
   }
}

sub draw {
	my $self = shift;

	$self->{PROGRESS} = $self->{COUNT} / $self->{END};

	my $file=$self->{FILE};
   eval {
      open (my $fh, ">", $file);
      print $fh JSON::encode_json({
         msg => $self->{MESSAGE},
         progress => sprintf("%.0f", 100 * $self->{PROGRESS}),
         runtime => time - $self->{T0},
         status => $self->{STATUS}
      });
      close ($fh);
   };
   if ($@) {
      warn "Can't write progress to $file: $@";
   }
}

sub finish {
	my $self = shift;

	$self->{COUNT} = $self->{END};
   $self->{MESSAGE} = "Finished!";
   $self->{DONE} = 1;

   $self->draw;
}

sub progress {
	my $self = shift;
	
	return $self->{PROGRESS};
}

sub count {
	my $self = shift;
	
	return $self->{COUNT};
}

sub terminus {
	my ($self, $new) = @_;
	
	if (defined $new) {	
		$self->{END} = $new;
		$self->check_incr;
	}
	
	return $self->{END};
}

sub message {
	my ($self, $message) = @_;

	$self->{MESSAGE} = $message;
   $self->draw;
}

sub set_status {
   my ($self, $status) = @_;
   
   $self->{STATUS} = $status;
   $self->draw;
}

1;
