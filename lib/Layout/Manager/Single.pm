package Layout::Manager::Single;
use Moose;

extends 'Layout::Manager';

sub do_layout {
    my ($self, $container) = @_;

    die("Need a container") unless defined($container);
    return unless $self->component_count;

    my $cheight = $container->inside_height;
    my $cwidth = $container->inside_width;

    my $count = 0;
    foreach my $c (@{ $self->components }) {

        my $comp = $c->{component};
        $comp->width($cwidth);
        $comp->height($cheight);
        $comp->origin->x($comp->padding->left + $comp->margins->left + $comp->border->width);
        $comp->origin->x($comp->padding->top + $comp->margins->top + $comp->border->width);

        if($comp->can('do_layout')) {
            $comp->do_layout($comp);
        }
    }
}

1;
__END__
=head1 NAME

Layout::Manager::Single

=head1 DESCRIPTION

Lays out all components in a single position.  All components are set to the
height and width of the container and positioned at the offsets.  This
basically stacks them all vertically.

=head1 SYNOPSIS

  my $lm = Layout::Manager::Single->new();
  
  $lm->add_component($comp1);
  $lm->add_component($comp2);

  $lm->do_layout($container);

=head1 METHODS

=head2 Constructor

=over 4

=item I<new>

Creates a new Layout::Manager::Single.

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