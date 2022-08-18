use v5.10;
use Test::More;

my $class = 'CPAN::Audit::Filter';
my @class_methods = qw(new);
my @instance_methods = qw(excludes ignored_count);

subtest sanity => sub {
	use_ok( $class );
	can_ok( $class, @class_methods );
	};

subtest 'no args' => sub {
	my $filter = $class->new;
	isa_ok( $filter, $class );
	can_ok( $filter, @instance_methods );
	};

subtest 'one args' => sub {
	my $warning;
	local $SIG{__WARN__} = sub { $warning .= $_[0] };
	my $filter = $class->new( 'excludes' );
	# diag( "Warning was <$warning>" );
	like( $warning, qr/Odd number/, 'Odd number of elements warns' );
	isa_ok( $filter, $class );
	can_ok( $filter, @instance_methods );
	};

subtest 'two args' => sub {
	my $id = 'Some-Package-2022-001';
	my $filter = $class->new( exclude => [ $id ] );

	isa_ok( $filter, $class );
	can_ok( $filter, @instance_methods );

	subtest 'nothing to ignore' => sub {
		my $rc = $filter->excludes( { id => 'xyz' } );
		ok( ! $rc, 'excludes returns false when it does not exclude' );
		is( $filter->ignored_count, 0, 'ignored_count returns 0 when it does not exclude' );
		};

	subtest 'something to ignore' => sub {
		my $rc = $filter->excludes( { id => $id } );
		ok( $rc, 'excludes returns true when it does exclude' );
		is( $filter->ignored_count, 1, 'ignored_count returns 1 when it does exclude' );
		};

	};

done_testing();
