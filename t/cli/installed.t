use strict;
use warnings;
use lib 't/lib';
use Test::More;
use TestCommand;

subtest 'command: installed' => sub {
    my( $stdout, $stderr, $exit ) = TestCommand->command( 'installed', 'lib' );

    like $stderr, qr/Collecting all installed modules/;
    is $stdout,   '';
    is $exit,     0;
};

done_testing;
