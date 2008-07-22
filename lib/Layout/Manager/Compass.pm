package Layout::Manager::Compass;
use Moose;

use MooseX::AttributeHelpers;

extends 'Layout::Manager';

override('do_layout', sub {
    my ($self, $container) = @_;

    die("Need a container") unless defined($container);
    return unless $container->component_count;

    my $bbox = $container->inside_bounding_box;

    my $cwidth = $bbox->width;
    my $cheight = $bbox->height;

    my %edges = (
        north => {
            components => [],
            # Honor the container's edges
            width => 0,
            height => $bbox->origin->y
        },
        south => {
            components => [],
            width => 0,
            # Honor the container's edges
            height => $cheight - ($bbox->origin->y + $bbox->height)
        },
        east => {
            components => [],
            # Honor the container's edges
            width => $cwidth - ($bbox->origin->x + $bbox->width),
            height => 0
        },
        west => {
            components => [],
            # Honor the container's edges
            width => $bbox->origin->x,
            height => 0
        },
        center => { components => [], width => 0, height => 0}
    );

    my $count = 0;
    foreach my $c (@{ $container->components }) {

        my $comp = $c->{component};

        next unless defined($comp) && $comp->visible;

        my $args = lc(substr($c->{args}, 0, 1));

        if(lc($args) eq 'c') {

            push(@{ $edges{center}->{components} }, $comp);
        } elsif($args =~ /^n/) {

            push(@{ $edges{north}->{components} }, $comp);
            $edges{north}->{height} += $comp->minimum_height;
            $edges{north}->{width} += $comp->minimum_width;
        } elsif($args eq 's') {

            push(@{ $edges{south}->{components} }, $comp);
            $edges{south}->{height} += $comp->minimum_height;
            $edges{south}->{width} += $comp->minimum_width;
        } elsif($args eq 'e') {

            push(@{ $edges{east}->{components} }, $comp);
            $edges{east}->{height} += $comp->minimum_height;
            $edges{east}->{width} += $comp->minimum_width;
        } elsif($args eq 'w') {

            push(@{ $edges{west}->{components} }, $comp);
            $edges{west}->{height} += $comp->minimum_height;
            $edges{west}->{width} += $comp->minimum_width;
        } elsif($args eq 'c') {

            push(@{ $edges{center}->{components} }, $comp);
            $edges{center}->{height} += $comp->minimum_height;
            $edges{center}->{width} += $comp->minimum_width;
        } else {
            die("Unknown direction '$args' for component $count.");
        }

        $count++;
    }

    my $xaccum  = $cwidth;
    foreach my $comp (@{ $edges{east}->{components} }) {

        # TODO Are paddings / margings being honored here and below?
        $comp->height($container->height - $edges{north}->{height} - $edges{south}->{height});
        $comp->width($comp->minimum_width);
        $comp->origin->x($xaccum - $comp->width);
        $comp->origin->y($edges{north}->{height});
        $xaccum -= $comp->width;
    }

    $xaccum = $bbox->origin->x;
    foreach my $comp (@{ $edges{west}->{components} }) {
        $comp->height($container->height - $edges{north}->{height} - $edges{south}->{height});
        $comp->width($comp->minimum_width);
        $comp->origin->x($xaccum);
        $comp->origin->y($edges{north}->{height});
        $xaccum += $comp->width;
    }

    my $yaccum = $bbox->origin->y;
    foreach my $comp (@{ $edges{north}->{components} }) {
        $comp->height($comp->minimum_height);
        $comp->width($container->width - $edges{east}->{width} - $edges{west}->{width});
        $comp->origin->x($edges{west}->{width});
        $comp->origin->y($yaccum);
        $yaccum += $comp->height;
    }

    $yaccum = $cheight;
    foreach my $comp (@{ $edges{south}->{components} }) {
        $comp->height($comp->minimum_height);
        $comp->width($container->width - $edges{east}->{width} - $edges{west}->{width});
        $comp->origin->x($edges{west}->{width});
        $comp->origin->y($yaccum - $comp->height);
        $yaccum -= $comp->height;
    }

    my $cen_height = $cheight - $edges{north}->{height} - $edges{south}->{height};
    my $cen_width = $cwidth - $edges{east}->{width} - $edges{west}->{width};

    my $ccount = scalar(@{ $edges{center}->{components}});
    if($ccount) {
        my $per_height = $cen_height / $ccount;

        my $i = 1;
        foreach my $comp (@{ $edges{center}->{components}}) {
            $comp->height($per_height);
            $comp->width($cen_width);

            $comp->origin->x($edges{west}->{width});
            $comp->origin->y($edges{north}->{height} + ($per_height * ($i - 1)));

            $i++;
        }
    }

    foreach my $c (@{ $container->components }) {

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