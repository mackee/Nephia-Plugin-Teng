requires 'perl', '5.008001';
requires 'Nephia', '>= 0.31';
requires 'Teng', '>= 0.18';
requires 'DBI';

on 'test' => sub {
    requires 'Test::More', '0.98';
    requires 'File::Spec';
    requires 'File::Temp';
    requires 'HTTP::Request::Common';
    requires 'JSON';
    requires 'DBD::SQLite';
};

