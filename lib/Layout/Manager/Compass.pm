package Layout::Manager::Compass;
use Moose;

use MooseX::AttributeHelpers;

extends 'Layout::Manager';

override('do_layout', sub {
    my ($self, $container, $parent) = @_;

    my $bbox = $container->inside_bounding_box;

    my $cwidth = $bbox->width;
    my $cheight = $bbox->height;

    my %edges = (
        north => {
            components => [],
            width => 0,
            height => 0
        },
        south => {
            components => [],
            width => 0,
            height => 0
        },
        east => {
            components => [],
            width => 0,
            height => 0
        },
        west => {
            components => [],
            width => 0,
            height => 0
        },
        center => { components => [], width => 0, height => 0}
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

        if(lc($args) eq 'c') {

            push(@{ $edges{center}->{components} }, $comp);
        } elsif($args eq 'n') {

            push(@{ $edges{north}->{components} }, $comp);
            $edges{north}->{height} += $comp->minimum_height;
            $edges{north}->{width} = 0;
        } elsif($args eq 's') {

            push(@{ $edges{south}->{components} }, $comp);
            $edges{south}->{height} += $comp->minimum_height;
            $edges{south}->{width} = 0;
        } elsif($args eq 'e') {

            push(@{ $edges{east}->{components} }, $comp);
            $edges{east}->{height} = 0;
            $edges{east}->{width} += $comp->minimum_width;
        } elsif($args eq 'w') {

            push(@{ $edges{west}->{components} }, $comp);
            $edges{west}->{height} = 0;;
            $edges{west}->{width} += $comp->minimum_width;
        } elsif($args eq 'c') {

            push(@{ $edges{center}->{components} }, $comp);
            $edges{center}->{height} += $comp->minimum_height;
            $edges{center}->{width} = 0;
        } else {

            die("Unknown direction '$args' for component $comp.");
        }
    }

    # Each of these loops iterate over their respective edge and 'fit' each
    # component in the order they were added.

    my $xaccum  = $bbox->origin->x + $bbox->width;
    my $east_height = $cheight - $edges{north}->{height} - $edges{south}->{height};
    # my $east_width = 0;
    foreach my $comp (@{ $edges{east}->{components} }) {
        # If the size we have available in the east slot is greater than the
        # minimum height of the component then we'll resize.
        if($east_height > $comp->minimum_height) {
            $comp->height($east_height);
        }

        $self->_geassign($edges{east}->{height}, $comp->height);
        $xaccum -= $comp->width;
        $comp->origin->x($xaccum);
        $comp->origin->y($bbox->origin->y + $edges{north}->{height});
    }

    $xaccum = $bbox->origin->x;
    my $west_height = $cheight - $edges{north}->{height} - $edges{south}->{height};
    my $west_width = 0;
    foreach my $comp (@{ $edges{west}->{components} }) {
        if($west_height > $comp->minimum_height) {
            $comp->height($west_height);
        }
        $comp->origin->y($bbox->origin->y + $edges{north}->{height});

        # Give a sub-container a chance to size itself since we've given
        # it all the information we can.
        # TODO Check::ISA
        if($comp->can('do_layout')) {
            $self->_layout_container($comp);
        }

        $self->_geassign($edges{west}->{height}, $comp->height);
        $comp->origin->x($xaccum + $west_width);
        $west_width += $comp->width;
    }

    my $yaccum = $bbox->origin->y;
    my $north_width = $cwidth - $edges{east}->{width} - $edges{west}->{width};
    foreach my $comp (@{ $edges{north}->{components} }) {
        if($north_width > $comp->minimum_width) {
            $comp->width($north_width);
        }
        $comp->origin->x($bbox->origin->x + $edges{west}->{width});

        # Give a sub-container a chance to size itself since we've given
        # it all the information we can.
        # TODO Check::ISA
        if($comp->can('do_layout')) {
            $self->_layout_container($comp);
        }

        $comp->origin->y($yaccum);
        $yaccum += $comp->height;
    }

    $yaccum = $bbox->origin->y + $bbox->height;
    my $south_width = $cwidth - $edges{east}->{width} - $edges{west}->{width};
    foreach my $comp (@{ $edges{south}->{components} }) {
        if($south_width > $comp->minimum_width) {
            $comp->width($south_width);
        }
        $comp->origin->x($bbox->origin->x + $edges{west}->{width});

        # Give a sub-container a chance to size itself since we've given
        # it all the information we can.
        # TODO Check::ISA
        if($comp->can('do_layout')) {
            $self->_layout_container($comp);
        }

        $comp->origin->y($yaccum - $comp->height);
        $yaccum -= $comp->height;
    }

    # Compass layout uses a minimum of height and width for the 4 edges and
    # then allocates all leftover space equally to items in the center.  This
    # section does the center fitting.

    my $cen_height = $cheight - $edges{north}->{height} - $edges{south}->{height};
    my $cen_width = $cwidth - $edges{east}->{width} - $edges{west}->{width};

    my $ccount = scalar(@{ $edges{center}->{components} });
    if($ccount) {
        my $per_height = $cen_height / $ccount;

        my $i = 1;
        foreach my $comp (@{ $edges{center}->{components}}) {
            $comp->height($per_height);
            $comp->width($cen_width);

            $comp->origin->x($bbox->origin->x + $edges{west}->{width});
            $comp->origin->y($bbox->origin->y + $edges{north}->{height} + ($per_height * ($i - 1)));

            # TODO Check::ISA
            if($comp->can('do_layout')) {
                $self->_layout_container($comp);
            }

            $i++;
        }
    }

    # use Data::Dumper;
    # print Dumper(\%used);

    # Determine what our minimum height and width is
    my $min_height = $edges{north}->{height} + $edges{south}->{height}
        + $edges{east}->{height} + $edges{west}->{height}
        + $edges{center}->{height};
    my $min_width = $edges{north}->{width} + $edges{south}->{width}
        + $edges{east}->{width} + $edges{west}->{width}
        + $edges{center}->{width};

    # Increase the minimum height and width of the container to accomodate
    # the laid out components.
    $container->minimum_width($container->minimum_width + $min_width);
    $container->minimum_height($container->minimum_height + $min_height);

    # If the width and height of the container are not sufficient, expand
    # them.
    if($container->width < $container->minimum_width) {
        $container->width($container->minimum_width);
    }
    if($container->height < $container->minimum_height) {
        $container->height($container->minimum_height);
    }

    #super;
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
takes up all possible space.

In other words, the center area will expand to take up all space that is NOT
used by components placed at the edges.

Components are placed in the order they are added.  If two items are added
to the 'north' position then the first item will be rendered on top of the
second.

Items in the center split the available space, heightwise.  Two center
components will each take up 50% of the available height and 100% of the
available width.

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