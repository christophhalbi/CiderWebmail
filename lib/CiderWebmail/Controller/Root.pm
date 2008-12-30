package CiderWebmail::Controller::Root;

use strict;
use warnings;
use base 'Catalyst::Controller';

use CiderWebmail::Headercache;
use List::Util qw(reduce);

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config->{namespace} = '';

=head1 NAME

CiderWebmail::Controller::Root - Root Controller for CiderWebmail

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=cut

=head2 auto

Only logged in users may use this product.

=cut

sub auto : Private {
    my ($self, $c) = @_;


    if ($c->authenticate({ realm => "CiderWebmail" })) {
        $c->stash( headercache => CiderWebmail::Headercache->new($c) );

        my $tree = $c->model->folder_tree($c);
        CiderWebmail::Util::add_foldertree_uri_view($c, { path => undef, folders => $tree->{folders}});

        $c->stash({
            folder_tree => $tree,
        });

        return 1;
    } else {
        return 0;
    }
}

sub login : Local {
    my ( $self, $c ) = @_;
    my $username = $c->req->param('username');
    my $password => $c->req->param('password');

    my $model = $c->model();
}

sub index : Private {
    my ( $self, $c ) = @_;
    my $model = $c->model();
    my $folders = $c->stash->{folders};
    my %folders = %{ $c->stash->{folders_hash} };
    my $folder =  exists $folders{INBOX}
        ? $folders{INBOX}   # good guess
        : reduce { $a->{name} lt $b->{name} ? $a : $b } @$folders; # or just the first
    $c->res->redirect($folder->{uri_view});
}

=head2 end

Attempt to render a view, if needed.

=cut 

sub end : ActionClass('RenderView') {}

=head1 AUTHOR

Stefan Seifert

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
