# Contributing

## Updating the advisories

The advisories are actually in a separate GitHub repo,
[briandfoy/cpan-security-advisory](https://github.com/briandfoy/cpan-security-advisory)
that's a submodule of this repo. Follow the instructions for that
repo to add or update advisories.

## Updating the module

If you don't have the *cpan-security-advisory* directory, you need to
set that up:

	% perl Makefile.PL
	% make submodules

If you already had the submodule, you may need to update it before you
start work:

	% git submodule update --remote

Once you have the submodule set up, you can regenerate *lib/CPAN/Audit/DB.pm*:

	% make generate
