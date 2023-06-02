use strict;
use warnings;
use lib 't/lib';
use Test::More;
use TestCommand;

subtest 'command: modules' => sub {
    my ( $stdout, $stderr, $exit ) = TestCommand->command( 'modules', 'CPAN' );

    like $stdout, qr/CPANSA-CPAN-2009-01/;
    like $stdout, qr/CPANSA-CPAN-2020-16156/;
    is $stderr,   '';
    isnt $exit,   0;
};

subtest 'command: modules with two modules' => sub {
    my ( $stdout, $stderr, $exit ) = TestCommand->command( 'modules', 'CPAN', 'Mojolicious;>8.40,<9.20' );

    like $stdout, qr/CPANSA-CPAN-2009-01/;
    like $stdout, qr/CPANSA-CPAN-2020-16156/;
    like $stdout, qr/CPANSA-Mojolicious-2022-03/;
    is $stderr,   '';
    isnt $exit,   0;
};

subtest 'command: modules, with excluded result' => sub {
    my ( $stdout, $stderr, $exit ) = TestCommand->command( 'modules', 'CPAN', 'Mojolicious;>8.40,<9.20','--exclude' => 'CPANSA-CPAN-2009-01', '--exclude' => 'CPANSA-Mojolicious-2022-03' );
    unlike $stdout, qr/CPANSA-CPAN-2009-01/;
    like $stdout, qr/CPANSA-CPAN-2020-16156/;
    unlike $stdout, qr/CPANSA-Mojolicious-2022-03/;
    is $stderr,   '';
    isnt $exit,   0;
};

subtest 'command: modules, with excluded results from file' => sub {
    my $file = 't/data/modules_excludes';
    ok( -e $file, 'File that should be there is there' );
    my ( $stdout, $stderr, $exit ) = TestCommand->command( 'modules', 'CPAN', 'Mojolicious;>8.40,<9.20', '--exclude-file' => $file );

    unlike $stdout, qr/CPANSA-CPAN-2009-01/;
    like $stdout, qr/CPANSA-CPAN-2020-16156/;
    unlike $stdout, qr/CPANSA-Mojolicious-2022-03/;
    is $stderr,   '';
    isnt $exit,   0;
};

subtest 'command: modules, with excluded results from non-existent file' => sub {
    my $file = 't/data/not-there';
    ok( ! -e $file, 'File that should not exist is not there' );
    my ( $stdout, $stderr, $exit ) = TestCommand->command( 'modules', 'CPAN', 'Mojolicious;>8.40,<9.20', '--exclude-file' => $file );

    like $stdout, qr/CPANSA-CPAN-2009-01/;
    like $stdout, qr/CPANSA-CPAN-2020-16156/;
    like $stdout, qr/CPANSA-Mojolicious-2022-03/;

    like $stderr, qr/unable to open exclude_file/;
};

subtest 'command: unknown modules' => sub {
    my ( $stdout, $stderr, $exit ) = TestCommand->command( 'modules', 'Unknown' );

    like $stderr, qr/Module 'Unknown' is not in database/;
    is $stdout,  '';
};

subtest 'command: unknown modules (mixed)' => sub {
    my ( $stdout, $stderr, $exit ) = TestCommand->command( 'modules', 'CPAN', 'Unknown' );

    like $stderr, qr/Module 'Unknown' is not in database/;
    like $stdout, qr/CPANSA-CPAN-2009-01/;
    like $stdout, qr/CPANSA-CPAN-2020-16156/;
};

subtest 'command: invalid invocation' => sub {
    my ( $stdout, $stderr, $exit ) = TestCommand->command( 'modules' );

    is $stdout,   '';
    like $stderr, qr/Error: Usage: /;
    isnt $exit,   0;
};

done_testing;
