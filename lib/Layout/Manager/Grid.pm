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

        my $width = 1;
        if(exists($cons->{width})) {
            $width = $cons->{width};
        }

        my $height = 1;
        if(exists($cons->{height})) {
            $height = $cons->{height};
        }

        $co->x($ox + ($cell_width * $col));
        $co->y($oy + ($cell_height * $row));
        $comp->width($cell_width * $width);
        $comp->height($cell_height * $height);

        $comp->prepared(1);
    }

    return 1;
});

__PACKAGE__->meta->make_immutable;

no Moose;

1;
__END__
=head1 NAME

Layout::Manager::Grid - Simple grid-based layout manager.

=head1 DESCRIPTION

Layout::Manager::Grid is a layout manager places components into evenly
divided cells.

When you instantiate a Grid manager, you must supply it with a count of how
many rows and columns it will have.  For example, a Grid with 1 column and
2 rows would look like:

  +--------------------------------+
  |                                |
  |           component 1          |
  |                                |
  +--------------------------------+
  |                                |
  |           component 2          |
  |                                |
  +--------------------------------+

The container is divided into as many <rows> * <columns> cells, with each
taking up an equal amount of space.  A grid with 3 columns and 2 rows would
create 6 cells that consume 33% of the width and 50% of the height.

Components are placed by specifying the cell they reside in via the row and 
column number.

  $container->add_component($comp, { row => 1, column => 3 });

  $container->add_component($comp, { row => 1, column => 2, height => 2 });
  
Optionally, you may choose to override the default C<width> or C<height> of 1.
Setting it to a something else will cause the component to consume that many
rows or columns worth of space.

Grid is similar to Java's
L<GridLayout|http://java.sun.com/docs/books/tutorial/uiswing/layout/grid.html>.

=head1 SYNOPSIS

  my $lm = Layout::Manager::Grid->new(rows => 1, columns => 2);
  
  $lm->add_component($comp1, { row => 1, column => 1 });
  $lm->add_component($comp2, { row => 1, column => 2 });

  $lm->do_layout($container);

=head1 METHODS

=head2 new (rows => $row, columns => $columns)

Creates a new Layout::Manager::Grid.  Requires C<rows> and C<columns>.

=head2 columns

The number of columns in this Grid.

=head2 rows

The number of rows in this Grid.

=head2 do_layout

Size and position the components in this layout.

=back

=head1 AUTHOR

Cory Watson, C<< <gphat@cpan.org> >>

=head1 COPYRIGHT & LICENSE

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.