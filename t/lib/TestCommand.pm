package TestCommand;
use strict;
use warnings;
use Capture::Tiny qw(capture);

sub command {
	my( $class, @args ) = @_;

	my ( $stdout, $stderr, $rc ) = capture {
		system $^X, '-Ilib', 'script/cpan-audit', '--no-corelist', @args;
		};

	my( $ran, $signal, $exit, $coredump );

	$ran = $rc > -1;

	if( $ran ) {
		$exit     = $rc >> 8;
		$coredump = $rc & 128;
		$signal   = $rc & 127;
		}

	return ( $stdout, $stderr, $exit, $signal, $coredump, $ran );
	}

1;
