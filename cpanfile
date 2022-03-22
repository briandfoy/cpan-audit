requires 'perl', '5.008001';

requires 'CPAN::DistnameInfo';
requires 'IO::Interactive';
requires 'Module::CPANfile';
requires 'Module::CoreList', '5.20181020';
requires 'PerlIO::gzip';
requires 'Pod::Usage',       '1.69';
requires 'version';

on 'test' => sub {
    requires 'Test::More', '0.98';
    requires 'Capture::Tiny';
};
