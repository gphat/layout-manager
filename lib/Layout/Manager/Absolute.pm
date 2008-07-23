package Layout::Manager::Absolute;
use Moose;

extends 'Layout::Manager';

override('do_layout', sub {
    my ($self, $container) = @_;

    die("Need a container") unless defined($container);
    return unless $self->component_count;

    foreach my $c (@{ $self->components }) {

        my $comp = $c->{component};

        next unless defined($comp) && $comp->visible;

        if($comp->can('do_layout')) {
            $comp->do_layout($comp);
        }
    }
});

__PACKAGE__->meta->make_immutable;

no Moose;

1;
__END__
=head1 NAME

Layout::Manager::Absolute - No frills layout manager

=head1 DESCRIPTION

Does nothing.  Expects that all components will be positioned already.

=head1 SYNOPSIS

  my $lm = Layout::Manager::Absolute->new;
  
  $lm->add_component($comp1);
  $lm->add_component($comp2);

  $lm->do_layout($container);

=head1 METHODS

=head2 Constructor

=over 4

=item I<new>

Creates a new Layout::Manager::Absolute.

=back

=head2 Instance Methods

=over 4

=item I<do_layout>

Size and position the components in this layout.

=back

=head1 AUTHOR

Cory Watson, C<< <gphat@cpan.org> >>

Infinity Interactive, L<http://www.iinteractive.com>

=head1 COPYRIGHT & LICENSE

Copyright 2008 by Infinity Interactive, Inc.

L<http://www.iinteractive.com>

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.