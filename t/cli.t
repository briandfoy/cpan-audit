use strict;
use warnings;
use lib 't/lib';
use Test::More;
use TestCommand;

subtest 'help is printed' => sub {
	my @args = ( [], [qw(--help)] );
	foreach my $args ( @args ) {
		subtest "help is printed with <@$args>" => sub {
			local $ENV{PERL5OPTS} = do { no warnings; "-w $ENV{PERL5OPTS}" };
			my ( $stdout, $stderr, $exit ) = TestCommand->command(@$args);

			is $stdout,   '';
			like $stderr, qr/Usage:.*cpan-audit/ms;
			unlike $stderr, qr/^Argument "main" isn't numeric/m; # GitHub #41
			is $exit, 2;
			};
		}
};

subtest 'version is printed' => sub {
	local $ENV{PERL5OPTS} = do { no warnings; "-w $ENV{PERL5OPTS}" };
    my ( $stdout, $stderr, $exit ) = TestCommand->command('--version');

    like $stdout, qr/cpan-audit version \d+\.\d+/;
    unlike $stderr, qr/^Argument "main" isn't numeric/m; # GitHub #41
    is $exit,   0;
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
