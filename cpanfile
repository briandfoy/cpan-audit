requires 'perl', '5.010001';

requires 'CPAN::DistnameInfo';
requires 'Encode', '3.12';
requires 'IO::Interactive';
requires 'Module::CPANfile';
requires 'Module::CoreList', '5.20181020';
requires 'PerlIO::gzip';
requires 'Pod::Usage',       '1.69';
requires 'version';

on 'test' => sub {
    requires 'Capture::Tiny', '0.24';
    requires 'Test::CPAN::Changes';
    requires 'Test::Manifest';
    requires 'Test::More', '0.98';
};

on 'development' => sub {
    requires 'HTTP::Tiny';
    requires 'JSON';
    requires 'Data::Dumper';
    requires 'File::Basename';
};
