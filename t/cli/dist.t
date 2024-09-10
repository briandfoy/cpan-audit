use strict;
use warnings;
use lib 't/lib';
use Test::More;
use TestCommand;

subtest 'command: dist' => sub {
	my $expected_reports = 14;
	my( $stdout, $stderr, $exit ) = TestCommand->command( 'dist', 'perl', '5.024004' );

	unlike $stdout, qr/CPANSA-perl-2023-47(?:100|038)/, 'CVE-2023-471100 nor CVE-2023-47028 are in the reports';
	is $exit, 64 + $expected_reports, "there are $expected_reports reports";
};

done_testing;
