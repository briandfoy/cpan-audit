# NAME

cpan-audit - Audit CPAN modules

# SYNOPSIS

cpan-audit \[command\] \[options\]

Commands:

    module         [version range]    audit module with optional version range (all by default)
    dist|release   [version range]    audit distribution with optional version range (all by default)
    deps           [directory]        audit dependencies from the directory (. by default)
    installed                         audit all installed modules
    show           [advisory id]      show information about specific advisory

Options:

    --ascii               use ascii output
    --freshcheck|f        check the database for freshness (CPAN::Audit::FreshnessCheck)
    --help|h              show the help message and exit
    --no-color            switch off colors
    --no-corelist         ignore modules bundled with perl version
    --perl                include perl advisories
    --quiet               be quiet
    --verbose             be verbose
    --version             show the version and exit
    --exclude <str>       exclude/ignore the specified advisory/cve (multiple)
    --exclude-file <file> read exclude/ignore patterns from file
    --json <file>         save audit results in JSON format in a file

Examples:

    cpan-audit dist Catalyst-Runtime
    cpan-audit dist Catalyst-Runtime 7.0
    cpan-audit dist Catalyst-Runtime >5.48

    cpan-audit module Catalyst 7.0

    cpan-audit deps .
    cpan-audit deps /path/to/distribution

    cpan-audit installed
    cpan-audit installed local/
    cpan-audit installed local/ --exclude CVE-2011-4116
    cpan-audit installed local/ --exclude CVE-2011-4116 --exclude CVE-2011-123
    cpan-audit installed local/ --exclude-file ignored-cves.txt
    cpan-audit installed --json audit.json

    cpan-audit show CPANSA-Mojolicious-2018-03

# DESCRIPTION

`cpan-audit` is a command line application that checks the modules or
distributions for known vulnerabilities. It is using its internal
database that is automatically generated from a hand-picked database
[https://github.com/briandfoy/cpan-security-advisory](https://github.com/briandfoy/cpan-security-advisory).

`cpan-audit` does not connect to anything, that is why it is
important to keep it up to date. Every update of the internal database
is released as a new version. Ensure that you have the latest database
by updating [CPAN::Audit](https://metacpan.org/pod/CPAN%3A%3AAudit) frequently; the database can change daily.
You can use enable a warning for a possibly out-of-date database by
adding `--freshcheck`, which warns if the database version is older
than a month:

        % cpan-audit --freshcheck ...
        % cpan-audit -f ...

        % env CPAN_AUDIT_FRESH_DAYS=7 cpan-audit -f ...

## Finding dependencies

`cpan-audit` can automatically detect dependencies from the following
sources:

- `Carton`

    Parses `cpanfile.snapshot` file and checks the distribution versions.

- `cpanfile`

    Parses `cpanfile` taking into account the required versions.

It is assumed that if the required version of the module is less than
a version of a release with a known vulnerability fix, then the module
is considered affected.

## Exit values

In prior versions, `cpan-audit` exited with the number of advisories
it found. Starting with 1.001, if there are advisories found, `cpan-audit`
exits with 64 added to that number.

- 0 - normal operation
- 2 - problem with program invocation, such as bad switches or values
- 64+n - advisories found. Subtract 64 to get the advisory count

# LICENSE

Copyright (C) Viacheslav Tykhanovskyi.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.
