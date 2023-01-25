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

subtest 'json, corelist' => sub {
    my( $stdout, $stderr, $exit ) = capture {
        system( $^X, '-Ilib', 'script/cpan-audit', '--json', 'deps', 't/data/cpanfiles' );
    	};

    unlike $stdout, qr/Discovered \d+/;
    is $stderr, '';

    my $result_hash = JSON::decode_json( $stdout );
    isa_ok( $result_hash, ref {} );
    isa_ok( $result_hash->{meta}, ref {} );
    ok( $result_hash->{meta}{total_advisories} >= 1, "found one or more advisories" );
	};

subtest 'json, no corelist' => sub {
    my( $stdout, $stderr, $exit ) = capture {
        system( $^X, '-Ilib', 'script/cpan-audit', '--json', '--no-corelist', 'deps', 't/data/cpanfiles' );
    	};

    unlike $stdout, qr/Discovered \d+/;
    is $stderr, '';

    my $result_hash = JSON::decode_json( $stdout );
    isa_ok( $result_hash, ref {} );
    isa_ok( $result_hash->{meta}, ref {} );
    is( $result_hash->{meta}{total_advisories}, 1, "found exactly one advisory" );
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
            },
            module2dist => {
                'Catalyst' => 'Catalyst-Runtime',
            },
        };

        return $db;
    }
}

