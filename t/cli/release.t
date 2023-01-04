use strict;
use warnings;
use lib 't/lib';
use Test::More;
use TestCommand;

subtest 'command: release' => sub {
    my ( $stdout, $stderr, $exit ) = TestCommand->command( 'release', 'CPAN' );

    like $stdout, qr/CPANSA-CPAN-2009-01/;
    like $stdout, qr/CPANSA-CPAN-2020-16156/;
    is $stderr,   '';
    isnt $exit,   0;
};

subtest 'command: release, with excluded result' => sub {
    my ( $stdout, $stderr, $exit ) = TestCommand->command( 'release', 'CPAN', '--exclude' => 'CPANSA-CPAN-2009-01' );

    unlike $stdout, qr/CPANSA-CPAN-2009-01/;
    like $stdout, qr/CPANSA-CPAN-2020-16156/;
    is $stderr,   '';
    isnt $exit,   0;
};

subtest 'command: module, with excluded results from file' => sub {
    my ( $stdout, $stderr, $exit ) = TestCommand->command( 'release', 'CPAN', '--exclude-file' => 't/data/excludes' );

    unlike $stdout, qr/CPANSA-CPAN-2009-01/;
    like $stdout, qr/CPANSA-CPAN-2020-16156/;
    is $stderr,   '';
    isnt $exit,   0;
};

subtest 'command: unknown release' => sub {
    my ( $stdout, $stderr, $exit ) = TestCommand->command( 'release', 'Unknown' );

    like $stderr, qr/Distribution 'Unknown' is not in database/;
    is $stdout,   '';
    isnt $exit,    0;
};

subtest 'command: invalid invocation' => sub {
    my ( $stdout, $stderr, $exit ) = TestCommand->command( 'release' );

    like $stderr, qr/Error: Usage: /;
    is $stdout,   '';
    isnt $exit,   0;
};

done_testing;
