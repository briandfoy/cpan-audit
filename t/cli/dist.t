use strict;
use warnings;
use lib 't/lib';
use Test::More;
use TestCommand;

# this will be the same as ==5.024004
# CPANSA-perl-2018-6798
# CPANSA-perl-2018-6913
# CPANSA-perl-2018-6797
# CPANSA-perl-2017-12814
# CPANSA-perl-2017-12837

subtest 'command: dist perl version' => sub {
	my $expected_reports = 14;
	my( $stdout, $stderr, $exit ) = TestCommand->command( 'dist', 'perl', '5.024004' );
	is $exit, 64 + $expected_reports, "there are $expected_reports reports";
};

=pod

subtest 'command: dist perl ==version' => sub {
	my $expected_reports = 14;
	my( $stdout, $stderr, $exit ) = TestCommand->command( 'dist', 'perl', '==5.024004' );

	unlike $stdout, qr/CPANSA-perl-2023-47(?:100|038)/, 'CVE-2023-47100 nor CVE-2023-47038 are in the reports';
	is $exit, 64 + $expected_reports, "there are $expected_reports reports";
};

subtest 'command: dist perl >=version' => sub {
	my $expected_reports = 14;
	my( $stdout, $stderr, $exit ) = TestCommand->command( 'dist', 'perl', '>=5.024004' );

	unlike $stdout, qr/CPANSA-perl-2023-47(?:100|038)/, 'CVE-2023-47100 nor CVE-2023-47038 are in the reports';
	is $exit, 64 + $expected_reports, "there are $expected_reports reports";
};

=cut

done_testing;
