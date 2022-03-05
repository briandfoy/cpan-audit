requires 'perl', '5.008001';

requires 'CPAN::DistnameInfo';
<<<<<<< HEAD
requires 'IO::Interactive';
requires 'Module::CPANfile';
requires 'Pod::Usage',       '1.69';
=======
>>>>>>> 161f792 (Add PerlIO::gzip, and alphabetize list)
requires 'Module::CoreList', '5.20181020';
requires 'Module::CPANfile';
requires 'PerlIO::gzip';
requires 'Pod::Usage',       '1.69';
requires 'version';

on 'test' => sub {
    requires 'Test::More', '0.98';
    requires 'Capture::Tiny';
};
