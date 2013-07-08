package Nephia::TestApp;
use strict;
use warnings;
use Nephia plugins => [qw/Teng/];
use utf8;

path '/' => sub {
    return {
        template => 'index.html',
        title    => config->{appname},
        envname  => config->{envname},
        apppath  => 'lib/' . __PACKAGE__ .'.pm',
    };
};

get '/person/:id' => sub {
    my $id = path_param('id');
    return res { 422 } unless $id =~ /^[0-9]+$/;

    my $row = teng->lookup('person', { id => $id });
    return res { 404 } unless $row;

    return {
        id => $id,
        name => $row->get_column('name'),
        age => $row->get_column('age'),
    };
};

post '/register' => sub {
    my $name = param->{name};
    return res { 422 } unless $name;
    my $age = param->{age};
    return res { 422 } unless $age =~ /^[0-9]+$/;

    my $id = teng->fast_insert('person', { name => $name, age => $age });

    return {
        id => $id,
        name => $name,
        age => $age,
    };
};

1;

=head1 NAME

MyApp - Web Application

=head1 SYNOPSIS

  $ plackup

=head1 DESCRIPTION

MyApp is web application based Nephia.

=head1 AUTHOR

clever guy

=head1 SEE ALSO

Nephia

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

