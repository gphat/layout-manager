package Layout::Manager::Flow;
use Moose;

extends 'Layout::Manager';

use Moose::Util::TypeConstraints;

enum 'Layout::Manager::Flow::Anchors' => qw(north south east west);

has 'anchor' => (
    is => 'rw',
    isa => 'Layout::Manager::Flow::Anchors',
    default => sub { 'north' }
);

has 'used' => (
    is => 'rw',
    isa => 'ArrayRef',
    default => sub { [0, 0] }
);

override('do_layout', sub {
    my ($self, $container) = @_;

    super;

    my $bbox = $container->inside_bounding_box;

    my $cwidth = $bbox->width;
    my $cheight = $bbox->height;

    my $edge = 0;

    my $anch = $self->anchor;

    foreach my $c (@{ $container->components }) {
        my $comp = $c->{component};

        my $size = 0;

        if($anch eq 'north') {
            $size = $comp->minimum_height;
            $comp->origin->x(0);
            $comp->origin->y($edge);
            $comp->width($cwidth);
            $comp->height($size);
        } elsif($anch eq 'south') {
            $size = $comp->minimum_height;
            $comp->origin->x(0);
            $comp->origin->y($cheight - $edge - $size);
            $comp->width($cwidth);
            $comp->height($size);
        } elsif($anch eq 'east') {
            $size = $comp->minimum_width;
            $comp->origin->x($cwidth - $edge - $size);
            $comp->origin->y(0);
            $comp->width($size);
            $comp->height($cheight);
        } else {
            $size = $comp->minimum_width;
            $comp->origin->x($edge);
            $comp->origin->y(0);
            $comp->width($size);
            $comp->height($cheight);
        }

        $edge += $size;
    }

    if(($anch eq 'north') || ($anch eq 'south')) {
        $self->used([$cwidth, $edge]);
    } else {
        $self->used([$edge, $cheight]);
    }
});

__PACKAGE__->meta->make_immutable;

no Moose;

1;
__END__
=head1 NAME

Layout::Manager::Flow - Directional layout manager

=head1 DESCRIPTION

Layout::Manager::Flow is a layout manager that anchors components in one of
the four cardinal directions.  The first comp

When you instantiate a Flow manager, you may supply it with an anchor value
which may be one of north, south, east or west.  The example below shows
how the default anchor value of 'north' works when you add two components.

                 north
  +--------------------------------+
  |           component 1          |
  +--------------------------------+
  |           component 2          |
  +--------------------------------+
  |                                |
  |                                |
  |                                |
  +--------------------------------+

Components are placed in the order they are added.  If two items are added
with a  'north' anchor then the first item will be rendered above the
second.  Components will be expanded to take up all space perpendicular to
their anchor.  North and south will expand widths while east and west will
expand heights.

Flow is similar to Java's
L<FlowLayout|http://java.sun.com/docs/books/tutorial/uiswing/layout/flow.html>
it does not, however, center or wrap components.  These features may be added
in the future if they are needed.

=head1 SYNOPSIS

  my $lm = Layout::Manager::Flow->new(anchor => 'north');
  
  $lm->add_component($comp1);
  $lm->add_component($comp2);

  $lm->do_layout($container);

=head1 METHODS

=head2 Constructor

=over 4

=item I<new>

Creates a new Layout::Manager::Flow.

=back

=head2 Instance Methods

=over 4

=item I<anchor>

The direction this manager is anchored.  Valid values are north, south, east
and west.

=item I<do_layout>

Size and position the components in this layout.

=item I<used>

Returns the amount of space used an arrayref in the form of
[ $width, $height ].

=back

=head1 AUTHOR

Cory Watson, C<< <gphat@cpan.org> >>

Infinity Interactive, L<http://www.iinteractive.com>

=head1 COPYRIGHT & LICENSE

Copyright 2008 by Infinity Interactive, Inc.

L<http://www.iinteractive.com>

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.