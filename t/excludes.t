use Test::More;

my $class = 'CPAN::Audit::Filter';
my @class_methods = qw(new);
my @instance_methods = qw(excludes);

subtest sanity => sub {
	use_ok( $class );
	can_ok( $class, @class_methods );
	};

subtest 'no args' => sub {
	my $object = $class->new;
	isa_ok( $object, $class );
	can_ok( $object, @instance_methods );
	};

subtest 'one args' => sub {
	my $object = $class->new( 'excludes' );
	isa_ok( $object, $class );
	can_ok( $object, @instance_methods );
	};

done_testing();
