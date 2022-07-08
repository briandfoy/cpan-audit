package CPAN::Audit::Exclude;
use strict;
use warnings;

our $VERSION = "1.001";

sub new {
    my($class, %params) = @_;

    my $self = bless {}, $class;
    $self->{exclude} = $params{exclude} // [];

    return $self;
}

sub is_excluded {
    my($self, $advisory) = @_;

    return 0 unless (@{$self->{exclude}});

    my %ids = map { ($_ => 1) } grep { defined } ($advisory->{id}, @{$advisory->{cves}});

    return 1 if (grep { $ids{$_} } @{$self->{exclude}});
    return 0;
}

1;
