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
	
	$self->{COUNT}    = 0;
	$self->{PROGRESS} = 0;
	$self->{FILE}  = File::Spec::Functions::catfile($session, ".progress");
	$self->{DONE}     = 0;
	$self->{MESSAGE}  = "Please wait...";
	
	bless($self);
	
	$self->init();

	if ($terminus <= 0) {
		$self->finish();
	}

	$self->draw();
	
	return $self;
}

sub init {

	my $self = shift;
	my $file = $self->{FILE};

	open(my $fh, ">", $file) or die "Can't write $file: $!";
	print $fh JSON::encode_json({msg=>$self->{MESSAGE}, progress=>"0", updated=>time});
	close($fh);
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
		
	if ($self->{COUNT}/$self->{END} > $self->{PROGRESS} + .005) {
	
		$self->{PROGRESS} = $self->{COUNT} / $self->{END};

		my $file=$self->{FILE};
		open (my $fh, ">", $file) or die "Can't write $file: $!";	
		print $fh JSON::encode_json({
			msg => $self->{MESSAGE},
			progress => sprintf("%.0f", 100 * $self->{PROGRESS}),
			updated => time
		});
		close ($fh);
	}
	
	if ($self->{COUNT} >= $self->{END}) {
				
		$self->finish();
	}	
}

sub finish {

	my $self = shift;

	return if $self->{DONE};

	$self->{PROGRESS} = $self->{COUNT} / $self->{END};
	
	my $file=$self->{FILE};
	open (my $fh, ">", $file) or die "Can't write $file: $!";	
	print $fh JSON::encode_json({msg => "Finished!", progress=>"100", updated=>time});	
	close $fh;
	
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

sub message {

	my ($self, $message) = @_;

	$self->{MESSAGE} = $message;
}

1;
