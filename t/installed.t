use strict;
use warnings;
use Test::More;
use CPAN::Audit::Installed;

subtest 'installed' => sub {
    my @deps = _build(
        db => {
            module2dist => {
                Catalyst  => 'Catalyst-Runtime',
                'DBD::Pg' => 'DBD-Pg',
            },
            dists       => {
                'Catalyst-Runtime' => {
                    main_module => 'Catalyst',
                    advisories  => [
                        {
                            id => 'CPANSA-Catalyst-2018-01'
                        }
                    ]
                },
                'DBD-Pg' => {
                    main_module => 'DBD::Pg',
                    advisories => [ ],
                },
            }
        }
    )->find('t/data/installed');

    is_deeply \@deps,
      [
        {
            'dist'    => 'Catalyst-Runtime',
            'version' => '5.0'
        },
      ];
};

done_testing;

sub _build { CPAN::Audit::Installed->new(@_) }
