package Nephia::Plugin::Teng;
use 5.008005;
use strict;
use warnings;
use Nephia::DSLModifier;
use Teng::Schema::Loader;
use DBI;

use constant {
    # connect level
    PER_REQUEST => 1,
    PER_WORKER  => 2,
    PER_CALL    => 3,
};

our $VERSION = "0.01";
our $TENG;

sub teng(@) {
    my $caller = caller;
    my $config = origin('config')->()->{'Plugin::Teng'};

    if (exists $config->{connect_level} && $config->{connect_level} == PER_WORKER) {
        return _worker_teng($caller);
    }

    my $ctx = origin('context')->();

    if (!$ctx->{_TENG} || (exists $config->{connect_level} && $config->{connect_level} == PER_CALL)) {
        $ctx->{_TENG} = _create_teng($caller);
    }

    origin('context')->($ctx);

    return $ctx->{_TENG};
}

sub _worker_teng {
    my $caller = shift;
    $TENG ||= _create_teng($caller);
}

sub _create_teng {
    my $caller = shift;
    my $config = origin('config')->()->{'Plugin::Teng'};
    my $pkg = $caller.'::DB';
    my $teng =
        Teng::Schema::Loader->load(
            dbh => DBI->connect($config->{dsn}, $config->{user}, $config->{password}, $config->{attr}),
            namespace => $pkg
        );

    for my $plugin (@{$config->{plugins}}) {
        $pkg->load_plugin($plugin);
    }

    return $teng;
};

1;
__END__

=encoding utf-8

=head1 NAME

Nephia::Plugin::Teng - It's new $module

=head1 SYNOPSIS

    use Nephia::Plugin::Teng;

=head1 DESCRIPTION

Nephia::Plugin::Teng is ...

=head1 LICENSE

Copyright (C) mackee.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

mackee E<lt>macopy123[attttt]gmai.comE<gt>

=cut

