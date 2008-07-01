package Layout::Manager::Compass;
use Moose;

use MooseX::AttributeHelpers;

with 'Layout::Manager';

has '_north' => (
    metaclass => 'Collection::Array',
    is => 'rw',
    isa => 'ArrayRef',
    default => sub { [] },
    provides => {
        push => '_add_north',
        count => '_north_count',
    }
);

has '_south' => (
    metaclass => 'Collection::Array',
    is => 'rw',
    isa => 'ArrayRef',
    default => sub { [] },
    provides => {
        push => '_add_south',
        count => '_south_count',
    }
);


has '_north_size' => (
    metaclass => 'Counter',
    is => 'rw',
    isa => 'Num',
    default => sub { 0 },
    provides => {
        inc => '_increase_north',
        dec => '_decrease_north',
    }
);

has '_south_size' => (
    metaclass => 'Counter',
    is => 'rw',
    isa => 'Num',
    default => sub { 0 },
    provides => {
        inc => '_increase_south',
        dec => '_decrease_south',
    }
);


sub do_layout {
    my ($self, $container) = @_;

    die("Need a container") unless defined($container);

    # First pass, divvy things up into their respective buckets...
    my $ccount = $self->component_count;
    for(my $i = 0; $i <= $ccount; $i++) {
        my $c = $self->get_component($i);
        next unless(defined($c));

        my $comp = $c->{component};
        my $args = $c->{args};

        # Set the component to it's preferred size, if it's got one
        if($comp->preferred_width != 0) {
            $comp->width = $comp->preferred_width;
        }
        if($comp->preferred_height != 0) {
            $comp->height($comp->preferred_height);
        }

        if(lc($args) =~ /^n/) {
            $self->_add_north($i);
            $self->_increase_north($comp->height);

        } elsif(lc($args) =~ /^s/) {
            $self->_add_south($i);
            $self->_increase_south($comp->height);

        } elsif(lc($args) =~ /^e/) {

        } elsif(lc($args) =~ /^w/) {

        } else {
            die("Unknown argument '$args' for component.");
        }
    }

    # VERTICAL SECTION

    # Now check if any of the sizes are going to be a problem and
    # attempt to 'minimize' any components that are willing.
    while($self->_total_height > $container->height()) {

        # Find northern candidates for minimization
        foreach my $i (@{ $self->_north }) {
            my $cand = $self->get_component($i);
            next unless defined($cand);

            # Try and minimize the candidate
            my $amt = $self->_minimize_component_height($cand->{component});
            if($amt) {
                $self->_decrease_north($amt);

                # If we go too small, add the remainder back to the last sized
                # component.
                if($self->_total_height <= $container->height()) {
                    my $diff = $container->height - $self->_total_height();
                    $cand->{component}->height($cand->{component}->height + $diff);
                }
            }
        }

        # Find southern candidates for minimization
        foreach my $i (@{ $self->_south }) {
            my $cand = $self->get_component($i);
            next unless defined($cand);

            # Try and minimize the candidate
            my $amt = $self->_minimize_component_height($cand->{component});
            if($amt) {
                $self->_decrease_south($amt);

                # If we go too small, add the remainder back to the last sized
                # component.
                if($self->_total_height <= $container->height()) {
                    my $diff = $container->height - $self->_total_height();
                    $cand->{component}->height($cand->{component}->height + $diff);
                }
            }
        }
    }

    # Did we use all the available space?
    if($self->_total_height < $container->height()) {
        my $diff = $container->height - $self->_total_height;
        # Calculate the amount of space remaining and split it amongst the
        # vertical components.
        my $per = $diff / $self->_vertical_count;

        foreach my $c (@{ $self->_north }) {
            my $comp = $self->get_component($c);
            $comp->{component}->height($comp->{component}->height + $per);
            $self->_increase_north($per);
        }

        foreach my $c (@{ $self->_south }) {
            my $comp = $self->get_component($c);
            $comp->{component}->height($comp->{component}->height + $per);
            $self->_increase_south($per);
        }
    }
}

sub _total_height {
    my ($self) = @_;

    return $self->_north_size + $self->_south_size;
}

sub _vertical_count {
    my ($self) = @_;

    return $self->_north_count + $self->_south_count;
}

# Set the component's size to the smallest we can and return the difference.
sub _minimize_component_height {
    my ($self, $comp) = @_;

    # Sanity check, not really necessary
    if($comp->preferred_height && ($comp->height > $comp->preferred_height)) {
        print STDERR "Resized ".$comp->name." via preferred.\n";
        my $diff = $comp->height - $comp->preferred_height;
        $comp->height($comp->preferred_height);
        return $diff;
    }

    # With that out of the way, try to find a minimum size;
    my $min = $comp->minimum_height;
    if($min && $min > $comp->height()) {
        print STDERR "Resized ".$comp->name." via minimum.\n";
        my $diff = $comp->height - $min;
        $comp->height($min);
        return $diff;
    }

    print STDERR "Got nothing for ".$comp->name."\n";

    return 0;
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

Creates a new Layout::Manager::Compass.

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