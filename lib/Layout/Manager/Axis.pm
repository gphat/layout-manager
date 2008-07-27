package Layout::Manager::Axis;
use Moose;

use MooseX::AttributeHelpers;

extends 'Layout::Manager';

override('do_layout', sub {
    my ($self, $container, $parent) = @_;

    my $bbox = $container->inside_bounding_box;

    my $cwidth = $bbox->width;
    my $cheight = $bbox->height;

    my %edges = (
        north => { components => [], width => $cwidth, height => 0 },
        south => { components => [], width => $cwidth, height => 0 },
        east => { components => [], width => 0, height => $cheight },
        west => { components => [], width => 0, height => $cheight },
        center => { components => [], width => $cwidth, height => $cheight }
    );

    # This loop takes each component and adds it's width and height to the
    # 'edge' on which is positioned.  At the end will know how much width and
    # height we need for each edge.
    foreach my $c (@{ $container->components }) {

        my $comp = $c->{component};

        next unless defined($comp) && $comp->visible;

        # Set each component to it's minimum size for now
        $comp->width($comp->minimum_width);
        $comp->height($comp->minimum_height);

        my $args = lc(substr($c->{args}, 0, 1));

        if($comp->can('do_layout')) {
            $self->_layout_container($comp);
        }

        if(($args) eq 'c') {

            push(@{ $edges{center}->{components} }, $comp);
        } elsif($args eq 'n') {

            push(@{ $edges{north}->{components} }, $comp);
            $edges{north}->{height} += $comp->minimum_height;
            $edges{east}->{height} -= $comp->minimum_height;
            $edges{west}->{height} -= $comp->minimum_height;
            $edges{center}->{height} -= $comp->minimum_height;

        } elsif($args eq 's') {

            push(@{ $edges{south}->{components} }, $comp);
            $edges{south}->{height} += $comp->minimum_height;
            $edges{east}->{height} -= $comp->minimum_height;
            $edges{west}->{height} -= $comp->minimum_height;
            $edges{center}->{height} -= $comp->minimum_height;
        } elsif($args eq 'e') {

            push(@{ $edges{east}->{components} }, $comp);
            $edges{east}->{width} += $comp->minimum_width;
            $edges{north}->{width} -= $comp->minimum_width;
            $edges{south}->{width} -= $comp->minimum_width;
            $edges{center}->{width} -= $comp->minimum_width;
        } elsif($args eq 'w') {

            push(@{ $edges{west}->{components} }, $comp);
            $edges{west}->{width} += $comp->minimum_width;
            $edges{north}->{width} -= $comp->minimum_width;
            $edges{south}->{width} -= $comp->minimum_width;
            $edges{center}->{width} -= $comp->minimum_width;
        } else {

            die("Unknown direction '$args' for component $comp.");
        }
    }

    # Relayout the west
    my $x = $bbox->origin->x;
    my $y = $bbox->origin->y + $edges{north}->{height};
    foreach my $comp (@{ $edges{west}->{components} }) {
        $comp->origin->x($x);
        $comp->origin->y($y);
        $comp->height($edges{center}->{height});
        if($comp->can('do_layout')) {
            $comp->do_layout($comp);
        }
        $x += $comp->width;
    }

    # Relayout the east
    $x = $bbox->origin->x + $bbox->width;
    $y = $bbox->origin->y + $edges{north}->{height};
    foreach my $comp (@{ $edges{east}->{components} }) {

        $x -= $comp->width;

        $comp->origin->x($x);
        $comp->origin->y($y);
        $comp->height($edges{center}->{height});
        if($comp->can('do_layout')) {
            $comp->do_layout($comp);
        }
    }

    # Relayout the south
    $x = $bbox->origin->x + $edges{west}->{width};
    $y = $bbox->origin->y + $cheight;
    foreach my $comp (@{ $edges{south}->{components} }) {

        $y -= $comp->height;

        $comp->origin->x($x);
        $comp->origin->y($y);
        $comp->width($edges{center}->{width});
        if($comp->can('do_layout')) {
            $comp->do_layout($comp);
        }
    }

    # Relayout the north
    $x = $bbox->origin->x + $edges{west}->{width};
    $y = $bbox->origin->y;
    foreach my $comp (@{ $edges{north}->{components} }) {

        $comp->origin->x($x);
        $comp->origin->y($y);
        $comp->width($edges{center}->{width});
        if($comp->can('do_layout')) {
            $comp->do_layout($comp);
        }
        $y += $comp->width;
    }

    # Relayout the center
    $x = $bbox->origin->x + $edges{west}->{width};
    $y = $bbox->origin->y + $edges{north}->{height};
    my $ccount = scalar(@{ $edges{center}->{components} });
    my $per = $edges{center}->{height} / $ccount;
    my $i = 0;
    foreach my $comp (@{ $edges{center}->{components} }) {

        $comp->origin->x($x);
        $comp->origin->y($y + ($i * $per));
        $comp->width($edges{center}->{width});
        $comp->height($per);
        if($comp->can('do_layout')) {
            $comp->do_layout($comp);
        }
        $i++;
    }

});

sub _layout_container {
    my ($self, $comp) = @_;

    $comp->do_layout($comp, $self);
    if($comp->minimum_width > $comp->width) {
        $comp->width = $comp->minimum_width;
    }
    if($comp->minimum_height > $comp->height) {
        $comp->height = $comp->minimum_height;
    }
}

sub _geassign {
    $_[1] = $_[2] if $_[2] > $_[1];
};

__PACKAGE__->meta->make_immutable;

no Moose;

1;
__END__
=head1 NAME

Layout::Manager::Compass - Compass based layout

=head1 DESCRIPTION

Layout::Manager::Compass is a layout manager that takes hints based on the
four cardinal directions (north, east, south and west) plus a center area that
takes up all remaining space.

In other words, the center area will expand to take up all space that is NOT
used by components placed at the edges.  Components at the north and south
edges will take up the full width of the container.

  +--------------------------------+
  |  x  |        north       |  x  |
  +-----+--------------------+-----+
  |     |                    |     |
  |  w  |                    |  e  |
  |  e  |       center       |  a  |
  |  s  |                    |  s  |
  |  t  |                    |  t  |
  +-----+--------------------+-----+
  |  x  |      south         |  x  |
  +--------------------------------+

Components are placed in the order they are added.  If two items are added
to the 'north' position then the first item will be rendered above the
second.  The height of the north edge will equal the height of both components
combined.

Items in the center split the available space, heightwise.  Two center
components will each take up 50% of the available height and 100% of the
available width.

Compass is basically an implementation of Java's
L<BorderLayout|http://java.sun.com/docs/books/tutorial/uiswing/layout/border.html>

=head1 SYNOPSIS

  my $lm = Layout::Manager::Compass->new();
  
  $lm->add_component($comp1, 'north');
  $lm->add_component($comp2, 'east');

  $lm->do_layout($container);


=head1 POSITIONING

When you add a component with I<add_component> the second argument should be
one of: north, south, east, west or center.  Case doesn't matter.  You can
also just provide the first letter of the word and it will do the same thing.

=head1 METHODS

=head2 Constructor

=over 4

=item I<new>

Creates a new Layout::Manager::Compass.

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