use strict;
use warnings;
use lib 'lib', 't/lib';
use Capture::Tiny qw(capture);
use CPAN::Audit::DB;
use CPAN::Audit;
use CPAN::Audit::Discover;
use File::Temp qw(tempfile);
use Test::More;

subtest 'json file' => sub {
    my ($temp_fh, $json_file) = tempfile( 'tempXXXXX', SUFFIX => '.json', UNLINK => 0 );
    close $temp_fh;

    my $audit = CPAN::Audit->new(
        json        => $json_file,
        no_corelist => $json_file,
    );

    my( $stdout, $stderr, $exit ) = capture {
        $audit->command(qw[deps t/data/cpanfiles/cpanfile]);
    };

    like $stdout, qr/Discovered 1 dependencies/;
    is $stderr,   '';
    is $exit,     1;

    my $json = do { local ( @ARGV, $/ ) = $json_file; <> };
    like $json, qr/CPANSATest/;

    unlink $json_file;
};

done_testing;

{
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

