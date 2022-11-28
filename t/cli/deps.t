use strict;
use warnings;
use lib 't/lib';
use Test::More;
use TestCommand;

# exclude CVE-2011-4116 explicitly. It's a known issue in File::Temp wrt symlinks.
# It should be safe to use the module the way we use it though.
subtest 'command: deps' => sub {
    my ( $stdout, $stderr, $exit ) = TestCommand->command('deps', '.', '--exclude', 'CVE-2011-4116');

    like $stdout, qr/Discovered \d+ dependencies/;
    is $stderr,   '';
    is $exit,     0;
};

done_testing;
