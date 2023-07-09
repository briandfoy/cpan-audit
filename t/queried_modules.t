use strict;
use warnings;
use lib 'lib', 't/lib';

use Capture::Tiny qw(capture);
use JSON;

use Test::More;

my $class = "CPAN::Audit";

subtest 'setup' => sub {
	use_ok( $class ) or BAIL_OUT( "$class did not compile: $@" );
	};

subtest 'deps queried_modules' => sub {
    my( $stdout, $stderr, $exit ) = capture {
        system( $^X, '-Ilib', 'script/cpan-audit', '--json', 'deps', 't/data/queried_modules' );
    	};

    is $stderr, '';

    my $result_hash = JSON::decode_json( $stdout );
    isa_ok( $result_hash, ref {} );
    isa_ok( $result_hash->{dists}, ref {} );
    is_deeply( $result_hash->{dists}{'Catalyst-Runtime'}{queried_modules}, ['Catalyst'], "Queried 'Catalyst'" );

    my %check = map { $_ => 1 } @{ $result_hash->{dists}{'Mojolicious'}{queried_modules} || [] };
    is_deeply( \%check, { 'Mojo::File' => 1, 'Mojo::UserAgent' => 1 }, "Queried 'Mojo::File' and 'Mojo::UserAgent'" );
	};

subtest 'module queried_modules Mojolicious' => sub {
    my( $stdout, $stderr, $exit ) = capture {
        system( $^X, '-Ilib', 'script/cpan-audit', '--json', 'module', 'Mojo::File' );
    	};

    is $stderr, '';

    my $result_hash = JSON::decode_json( $stdout );
    isa_ok( $result_hash, ref {} );
    isa_ok( $result_hash->{dists}, ref {} );
    is( $result_hash->{dists}{'Catalyst-Runtime'}{queried_modules}, undef, "Did not query 'Catalyst'" );
    is_deeply( $result_hash->{dists}{'Mojolicious'}{queried_modules}, ['Mojo::File'], "Queried 'Mojo::File'" );
	};

subtest 'module queried_modulesi Catalyst' => sub {
    my( $stdout, $stderr, $exit ) = capture {
        system( $^X, '-Ilib', 'script/cpan-audit', '--json', 'module', 'Catalyst' );
    	};

    is $stderr, '';

    my $result_hash = JSON::decode_json( $stdout );
    isa_ok( $result_hash, ref {} );
    isa_ok( $result_hash->{dists}, ref {} );
    is_deeply( $result_hash->{dists}{'Catalyst-Runtime'}{queried_modules}, ['Catalyst'], "Queried 'Catalyst'" );
    is( $result_hash->{dists}{'Mojolicious'}{queried_modules}, undef, "Did not query 'Mojo::File' and 'Mojo::UserAgent'" );
	};

subtest 'modules queried_modules' => sub {
    my( $stdout, $stderr, $exit ) = capture {
        system( $^X, '-Ilib', 'script/cpan-audit', '--json', 'modules', 'Catalyst', 'Mojo::File', 'Mojo::UserAgent' );
    	};

    is $stderr, '';

    my $result_hash = JSON::decode_json( $stdout );
    isa_ok( $result_hash, ref {} );
    isa_ok( $result_hash->{dists}, ref {} );
    is_deeply( $result_hash->{dists}{'Catalyst-Runtime'}{queried_modules}, ['Catalyst'], "Queried 'Catalyst'" );

    my %check = map { $_ => 1 } @{ $result_hash->{dists}{'Mojolicious'}{queried_modules} || [] };
    is_deeply( \%check, { 'Mojo::File' => 1, 'Mojo::UserAgent' => 1 }, "Queried 'Mojo::File' and 'Mojo::UserAgent'" );
	};

done_testing;

BEGIN {
	use CPAN::Audit::DB;
    no warnings 'redefine';

    sub CPAN::Audit::DB::db {
        my $db = {
            'dists' => {
                'Catalyst-Runtime' => {
                    'advisories' => [
                        {
                            'affected_versions' => '<5.90020',
                            'cves' => [],
                            'description' => 'A sample advisory for a test',
                            'distribution' => 'Catalyst-Runtime',
                            'fixed_versions' => '>=5.90020',
                            'id' => 'CPANSATest-Catalyst-Runtime-2013-01',
                            'references' => [
                            ],
                            'reported' => '2013-01-23'
                        },
                    ],
                    'main_module' => 'Catalyst::Runtime',
                    'versions' => [
                        {
                            'date' => '2021-01-01T18:10:00',
                            'version' => '5.00',
                        },
                        {
                            'date' => '2022-01-01T18:10:00',
                            'version' => '5.70',
                        },
                    ],
                },
		'Mojolicious' => {
		    'advisories' => [
		        id => 1,
			fixed_versions => '>=8',
		    ]
		}
            },
            module2dist => {
                'Catalyst'        => 'Catalyst-Runtime',
                'Mojo::File'      => 'Mojolicious',
                'Mojo::UserAgent' => 'Mojolicious',
            },
        };

        return $db;
    }
}

