use strict;
use warnings;
use lib 't/lib';
use Test::More;
use TestCommand;

subtest 'help is printed' => sub {
    my ( $stdout, $stderr, $exit ) = TestCommand->command();

    is $stdout,   '';
    like $stderr, qr/Usage:.*cpan-audit/ms;
    isnt $exit,   0;
};

subtest 'Github #34 - no message method' => sub {
    my ( $stdout, $stderr, $exit ) = TestCommand->command('installed', '--verbose');

	# should exit with 64 + N, where N is the number of advisories.
	# there shouldn't be that many. It certainly shouldn't exit with
	# 255.
    ok(
    	$exit >= 64 && $exit <= 126,
    	'installed --verbose does not have a run time fatal error'
    	) or diag( "exit value was <$exit>" );
};

done_testing;
