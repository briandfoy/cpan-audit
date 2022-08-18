use strict;
use warnings;
use lib 't/lib';
use Test::More;
use TestCommand;

subtest 'command: module' => sub {
    my ( $stdout, $stderr, $exit ) = TestCommand->command( 'module', 'CPAN' );

    like $stdout, qr/CPANSA-CPAN-2009-01/;
    like $stdout, qr/CPANSA-CPAN-2020-16156/;
    is $stderr,   '';
    isnt $exit,   0;
};

subtest 'command: module, with excluded result' => sub {
    my ( $stdout, $stderr, $exit ) = TestCommand->command( 'module', 'CPAN', '--exclude' => 'CPANSA-CPAN-2009-01' );

    unlike $stdout, qr/CPANSA-CPAN-2009-01/;
    like $stdout, qr/CPANSA-CPAN-2020-16156/;
    is $stderr,   '';
    isnt $exit,   0;
};

subtest 'command: module, with excluded results from file' => sub {
    my $file = 't/data/excludes';
    ok( -e $file, 'File that should be there is there' );
    my ( $stdout, $stderr, $exit ) = TestCommand->command( 'module', 'CPAN', '--exclude-file' => $file );

    unlike $stdout, qr/CPANSA-CPAN-2009-01/;
    like $stdout, qr/CPANSA-CPAN-2020-16156/;
    is $stderr,   '';
    isnt $exit,   0;
};

subtest 'command: module, with excluded results from non-existent file' => sub {
    my $file = 't/data/not-there';
    ok( ! -e $file, 'File that should not exist is not there' );
    my ( $stdout, $stderr, $exit ) = TestCommand->command( 'module', 'CPAN', '--exclude-file' => $file );

    like $stdout, qr/CPANSA-CPAN-2009-01/;
    like $stdout, qr/CPANSA-CPAN-2020-16156/;

    like $stderr, qr/unable to open exclude_file/;
    isnt $exit,   0;
};

subtest 'command: unknown module' => sub {
    my ( $stdout, $stderr, $exit ) = TestCommand->command( 'module', 'Unknown' );

    like $stdout, qr/Module 'Unknown' is not in database/;
    is $stderr,   '';
    is $exit,     0;
};

subtest 'command: invalid invocation' => sub {
    my ( $stdout, $stderr, $exit ) = TestCommand->command( 'module' );

    is $stdout,   '';
    like $stderr, qr/Error: Usage: /;
    isnt $exit,   0;
};

done_testing;
