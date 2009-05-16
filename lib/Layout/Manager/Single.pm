package Layout::Manager::Single;
use Moose;

extends 'Layout::Manager';

override('do_layout', sub {
    my ($self, $container) = @_;

    return 0 if $container->prepared && $self->_check_container($container);

    my $bbox = $container->inside_bounding_box;
    my $cwidth = $bbox->width;
    my $cheight = $bbox->height;
    my $x = $bbox->origin->x;
    my $y = $bbox->origin->y;

    my $count = 0;
    foreach my $comp (@{ $container->components }) {

        next unless defined($comp) && $comp->visible;

        $comp->width($cwidth);
        $comp->height($cheight);
        $comp->origin->x($x);
        $comp->origin->y($y);

        if($comp->can('do_layout')) {
            $comp->do_layout($comp);
        } else {
            #$comp->prepared(1);
        }
    }

    $container->prepared(1);
    return 1;
});

__PACKAGE__->meta->make_immutable;

no Moose;

1;
__END__
=head1 NAME

Layout::Manager::Single - One-size vertical layout manager

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