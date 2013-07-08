package Nephia::Plugin::Teng;
use 5.008005;
use strict;
use warnings;
use Nephia::DSLModifier;
use Teng::Schema::Loader;
use DBI;

our $VERSION = "0.01";
our $TENG;
our @RUN_SQL;

sub database_do ($) {
    my $sql = shift;
    push @RUN_SQL, $sql;
}

sub _on_connect_do {
    my $dbh = _create_dbh();
    for my $sql (@RUN_SQL) {
        $dbh->do($sql);
    }
}

sub teng(@) {
    my $caller = caller;

    return _worker_teng($caller);
}

sub _worker_teng {
    my $caller = shift;
    $TENG ||= _create_teng($caller);
}

sub _create_teng {
    my $caller = shift;
    my $config = origin('config')->()->{'Plugin::Teng'};
    my $pkg = $caller.'::DB';

    _on_connect_do();

    my $teng =
        Teng::Schema::Loader->load(
            dbh => _create_dbh(),
            namespace => $pkg
        );

    for my $plugin (@{$config->{plugins}}) {
        $pkg->load_plugin($plugin);
    }

    return $teng;
};

sub _create_dbh {
    my $config = origin('config')->()->{'Plugin::Teng'};
    return DBI->connect(
        @{$config->{connect_info}}
    );
}

1;
__END__

=encoding utf-8

=head1 NAME

Nephia::Plugin::Teng - Simple ORMapper Plugin For Nephia

=head1 SYNOPSIS

    use Nephia plugins => [qw/Teng/];

    path '/person/:id' => sub {
        my $id = path_param('id');
        my $row = teng->lookup('person', { id => $id });
        return res { 404 } unless $row;

        return {
            id => $id,
            name => $row->get_column('name'),
            age => $row->get_column('age'),
        };
    };

Read row from person table in database in this code.

=head1 DESCRIPTION

=head2 configuration - configuration for Teng.

configuration file:

    'Plugin::Teng' => {
        connect_info => ['dbi:SQLite:dbname=data.db'],
        plugins => [qw/Lookup Pager/]
    },

The "connect_info" is connect information for L<DBI>.

Enumerate in "plugins" option if you want load Teng plugins.

=head2 teng - Create Teng Object

"teng" DSL create the Teng Object.

=head2 database_do - load SQL before plackup.

In this example to create table before plackup.

in controller :

    database_do "CREATE DATABASE IF EXISTS person (id INTEGER, name TEXT, age INTEGE)";

    path '/' => sub {
        ...
    };

=head1 SEE ALSO

L<Nephia>

L<Teng>

=head1 LICENSE

Copyright (C) macopy.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

mackee E<lt>macopy123[attttt]gmai.comE<gt>

=cut

