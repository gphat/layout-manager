package Layout::Manager::Compass;
use Moose;

with 'Layout::Manager';

sub layout {
    my ($self) = @_;

    foreach my $comp (@{ $self->components }) {
        next unless(defined($comp));


    }
}

1;
__END__
=head1 NAME

Layout::Manager::Compass

=head1 DESCRIPTION

Layout::Manager::Border is a layout manager that takes hints based on the
four cardinal directions (north, east, south and west) plus a center area that
takes up all possible space.

In other words, the center area will expand to take up all space that is NOT
used by components placed at the edges.

Components are placed in the order they are added.  If two items are added
to the 'north' position then the first item will be rendered on top of the
second.

=head1 SYNOPSIS

  Layout::Manager::Compass;

=head1 METHODS

=head2 Constructor

=over 4

=item new

Creates a new Layout::Manager::Border.

=back

=head2 Methods

=over 4

=back

=head1 AUTHOR

Cory Watson, C<< <cory.watson at iinteractive.com> >>

=head1 COPYRIGHT & LICENSE

Copyright 2008 by Infinity Interactive, Inc.

L<http://www.iinteractive.com>

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.