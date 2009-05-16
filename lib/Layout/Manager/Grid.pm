package Layout::Manager::Grid;
use Moose;

extends 'Layout::Manager';

use Carp qw(croak);

has 'rows' => (
    is => 'rw',
    isa => 'Int',
    required => 1
);

has 'columns' => (
    is => 'rw',
    isa => 'Int',
    required => 1
);

override('do_layout', sub {
    my ($self, $container) = @_;

    super;

    my $bbox = $container->inside_bounding_box;

    my $cwidth = $bbox->width;
    my $cheight = $bbox->height;

    my $cell_width = $cwidth / $self->columns;
    my $cell_height = $cheight / $self->rows;

    my $ox = $bbox->origin->x;
    my $oy = $bbox->origin->y;

    for(my $i = 0; $i < scalar(@{ $container->components }); $i++) {
        my $comp = $container->get_component($i);

        next unless defined($comp) && $comp->visible;

        my $cons = $container->get_constraint($i);
        croak('Constraint must be a hashref containing row and column.')
            unless (ref($cons) eq 'HASH' && (exists($cons->{row}) && (exists($cons->{column}))));

        my $co = $comp->origin;

        my $row = $cons->{row};
        $row = $self->rows if $row > $self->rows;
        my $col = $cons->{column};
        $col = $self->columns if $col > $self->columns;

        $co->x($ox + ($cell_width * $col));
        $co->y($oy + ($cell_height * $row));
        $comp->width($cell_width);
        $comp->height($cell_height);

        $comp->prepared(1);
    }

    return 1;
});

__PACKAGE__->meta->make_immutable;

no Moose;

1;
__END__
=head1 NAME

Layout::Manager::Grid - Directional layout manager

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
It does not, however, center or wrap components.  These features may be added
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