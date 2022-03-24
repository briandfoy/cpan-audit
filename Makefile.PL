package CPAN::Audit;
use strict;
use warnings;

=encoding utf8

=head1 The build file for CPAN::Audit

This build file is a modulino; it works as both a build script and
a module.

To build the distribution, run this file normally:

	% perl Makefile.PL

But, it's more interesting than that. You can load it with C<require>
and call C<arguments> to get the data structure it passes to
C<WriteMakefile>:

	my $package = require '/path/to/Makefile.PL';
	my $arguments = $package->arguments;

Note that C<require>-ing a file makes an entry in C<%INC> for exactly
that name. If you try to C<require> another file with the same name,
even from a different path, C<require> thinks it has already loaded
the file. As such, I recommend you always require the full path to the
file.

The return value of the C<require> is a package name (in this case,
the name of the main module. Use that to call the C<arguments> method.

Even if this distribution needs a higher version of Perl, this bit
only needs v5.8. You can play with the data structure with a primitive
Perl.

=cut

use File::Spec::Functions qw(catfile);

my $module    = __PACKAGE__;
( my $dist = $module ) =~ s/::/-/g;

my $github    = 'https://github.com/briandfoy/cpan-audit';
my $main_file = catfile( 'lib', split /::/, "$module.pm" );

my $advisory_repo = 'git@github.com:briandfoy/cpan-security-advisory.git';

sub MY::postamble {
	my $file = __FILE__;
    return <<"POSTAMBLE";

######################################################################
# Postamble from $file

cpan-security-advisory:
\t- git submodule add $advisory_repo

cpan-security-advisory/LICENSE: submodules

.PHONY: submodules
submodules: cpan-security-advisory
\t- git submodule init
\tgit submodule update --remote

# End postamble
######################################################################

POSTAMBLE
}

my %WriteMakefile = (
	'MIN_PERL_VERSION' => 5.008,

	'NAME'          => $module,
	'AUTHOR'        => 'Viacheslav Tykhanovskyi <viacheslav.t@gmail.com>',
	'ABSTRACT_FROM' => $main_file,
	'VERSION_FROM'  => $main_file,
	'LICENSE'       => 'perl_5',

	'CONFIGURE_REQUIRES' => {
		'ExtUtils::MakeMaker'   => '6.64',
		'File::Spec::Functions' => '0',
		},

	'BUILD_REQUIRES' => {
		'YAML::Tiny'            => '0',
		},

	'EXE_FILES' => [
		'script/cpan-audit',
		],

	'TEST_REQUIRES' => {
		'Capture::Tiny'   => '0',
		'HTTP::Tiny'      => '0',
		'IO::Interactive' => '0',
		'JSON'            => '0',
		'Test::More'      => '0.98',
		},

	'PREREQ_PM'     => {
		'CPAN::DistnameInfo'    => '0',
		'Module::CoreList'      => '5.20181020',
		'Module::CPANfile'      => '0',
		'PerlIO::gzip'          => '0',
		'Pod::Usage'            => '1.69',
		},

	'META_MERGE' => {
		'meta-spec' => { version => 2 },
		resources => {
			repository => {
				type => 'git',
				url  => "$github.git",
				web  => $github,
				},
			bugtracker => {
				web    => "$github/issues",
				},
			homepage => $github,
			},
		},

	clean => { FILES => "$dist-*" },
	);

sub arguments { \%WriteMakefile }

sub all_modules {
	my @keys = qw(CONFIGURE_REQUIRES BUILD_REQUIRES PREREQ_PM TEST_REQUIRES);

	my @modules = map { keys %$_ } @WriteMakefile{@keys};
	}

do_it() unless caller;
sub do_it {
	require File::Spec;
	my $MM ='ExtUtils::MakeMaker';
	my $MM_version =
		eval{ "$MM " . $WriteMakefile{'CONFIGURE_REQUIRES'}{'ExtUtils::MakeMaker'} }
			||
		"$MM 6.64";
	eval "use $MM_version; 1" or die "Could not load $MM_version: $@";
	eval "use Test::Manifest 1.21"
		if -e File::Spec->catfile( qw(t test_manifest) );

	my $arguments = arguments();
	my $minimum_perl = $arguments->{MIN_PERL_VERSION} || '5.008';
	eval "require $minimum_perl;" or die $@;

	WriteMakefile( %$arguments );
	}


no warnings;
__PACKAGE__;
