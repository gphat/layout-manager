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

has 'wrap' => (
    is => 'rw',
    isa => 'Bool',
    default => sub { 0 }
);

override('do_layout', sub {
    my ($self, $container) = @_;

    my $bbox = $container->inside_bounding_box;

    my $cwidth = $bbox->width;
    my $cheight = $bbox->height;

    my $ox = $bbox->origin->x;
    my $oy = $bbox->origin->y;

    my $anch = $self->anchor;

    my @lines;
    my $yused = $oy;
    my $xused = $ox;

    my $line = 0;
    for(my $i = 0; $i < scalar(@{ $container->components }); $i++) {
        my $comp = $container->get_component($i);

        next unless defined($comp) && $comp->visible;

        unless(defined($lines[$line])) {
            $lines[$line] = {
                tallest => 0,
                widest => 0,
                height => $oy,
                width => $ox,
                components => []
            };
        }

        $comp->width($comp->minimum_width);
        $comp->height($comp->minimum_height);

        # Keep up with the tallest component we find
        if($comp->height > $lines[$line]->{tallest}) {
            $lines[$line]->{tallest} = $comp->height;
        }
        # Keep up with the widest component we find
        if($comp->height > $lines[$line]->{widest}) {
            $lines[$line]->{widest} = $comp->height;
        }

        my $co = $comp->origin;

        if($anch eq 'north') {

            # No wrapping
            $co->x($ox);
            $co->y($lines[$line]->{height});
            $lines[$line]->{height} += $comp->height;
            unless($lines[$line]->{width}) {
                $lines[$line]->{width} = $comp->width;
            }
        } elsif($anch eq 'south') {

            # No wrapping
            $co->x($ox);
            $co->y($cheight - $comp->height - $lines[$line]->{height});
            $lines[$line]->{height} += $comp->height;
            unless($lines[$line]->{width}) {
                $lines[$line]->{width} = $comp->width;
            }
        } elsif($anch eq 'east') {

            if(
                # It doesn't matter if we are supposed to wrap if we have
                # no width, we'll make this thing as big as it needs to be
                ($cwidth > 0) &&
                # if we are wrapping
                ($self->wrap) &&
                # and the current component would overflow...
                ($lines[$line]->{width} + $comp->width > $cwidth) &&
                scalar(@{ $lines[$line]->{components} })
            ) {
                # We've been asked to wrap and this component is too wide
                # to fit.  Move down by the height of the tallest component
                # then reset the tallest variable.
                $yused += $lines[$line]->{tallest};
                $co->x($cwidth - $comp->width - $ox);
                $co->y($yused);

                $line++;
                $lines[$line]->{width} += $comp->width;
                $lines[$line]->{tallest} += $comp->height;
            } else {
                $co->x($cwidth - $comp->width - $lines[$line]->{width});
                $co->y($yused);
                $lines[$line]->{width} += $comp->width;
            }
        } else {
            # WEST
            if(
                # It doesn't matter if we are supposed to wrap if we have
                # no width, we'll make this thing as big as it needs to be
                ($cwidth > 0) &&
                # if we are wrapping
                ($self->wrap) &&
                # and the current component would overflow...
                ($lines[$line]->{width} + $comp->width > $cwidth) &&
                scalar(@{ $lines[$line]->{components} })
            ) {
                # We've been asked to wrap and this component is too wide
                # to fit.  Move down by the height of the tallest component
                # then reset the tallest variable.
                $yused += $lines[$line]->{tallest};
                $co->x($ox);
                $co->y($yused);

                $line++;
                $lines[$line]->{width} += $comp->width;
                $lines[$line]->{tallest} += $comp->height;
            } else {
                $co->x($lines[$line]->{width});
                $co->y($yused);
                $lines[$line]->{width} += $comp->width;
            }
        }
        push(@{ $lines[$line]->{components} }, $comp);
    }


    my $fwidth = 0;
    my $fheight = 0;
    if(($anch eq 'north') || ($anch eq 'south')) {
        #$self->used([$cwidth, $edge]);
        foreach my $l (@lines) {
            $fheight += $l->{height};
            if($l->{width} > $fwidth) {
                $fwidth += $l->{width};
            }
        }
        $self->used([$fwidth, $fheight]);
        $container->minimum_width($fwidth);
        $container->minimum_height($fheight);
    } else {
        foreach my $l (@lines) {
            $fheight += $l->{tallest};
            if($l->{width} > $fwidth) {
                $fwidth += $l->{width};
            }
        }
        $self->used([$fwidth, $fheight]);
        $container->minimum_width($fwidth);
        $container->minimum_height($fheight);
    }
    super;
    return 1;
});

__PACKAGE__->meta->make_immutable;

no Moose;

1;
__END__
=head1 NAME

Layout::Manager::Flow - Directional layout manager

=head1 DESCRIPTION

Layout::Manager::Flow is a layout manager that anchors components in one of
the four cardinal directions.

When you instantiate a Flow manager, you may supply it with an anchor value
which may be one of north, south, east or west.  The example below shows
how the default anchor value of north works when you add two components.

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
with a 'north' anchor then the first item will be rendered above the
second.  Components will be expanded to take up all space perpendicular to
their anchor.  North and south will expand widths while east and west will
expand heights.

Flow is similar to Java's
L<FlowLayout|http://java.sun.com/docs/books/tutorial/uiswing/layout/flow.html>.
It does not, however, center components.  This features may be added in the
future if they are needed.

=head1 SYNOPSIS

  my $lm = Layout::Manager::Flow->new(anchor => 'north');
  
  $lm->add_component($comp1);
  $lm->add_component($comp2);

  $lm->do_layout($container);

=head1 ATTRIBUTES

=head2 anchor

The direction this manager is anchored.  Valid values are north, south, east
and west.

=head2 used

Returns the amount of space used an arrayref in the form of C<[ $width, $height ]>.

=head2 wrap

If set to a true value, then component will be 'wrapped' when they do not
fit.  B<This currently only works for East and West anchored layouts.>

=head1 METHODS

=head2 do_layout

Size and position the components in this layout.

=head1 AUTHOR

Cory Watson, C<< <gphat@cpan.org> >>

=head1 COPYRIGHT & LICENSE

Copyright 2008 by Cory G Watson

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.