package Layout::Manager;
use Moose::Role;

our $VERSION = '0.01';

use MooseX::AttributeHelpers;

requires 'layout';

has 'components' => (
    metaclass => 'Collection::Array',
    is => 'rw',
    isa => 'ArrayRef',
    default => sub { [] },
    provides => {
        'clear'=> 'clear_components',
        'count'=> 'component_count',
    }
);

sub add_component {
    my ($self, $component, $args) = @_;

    # TODO Document me
    return 0 unless $self->validate_component($component, $args);

    push(@{ $self->components }, {
        component => $component,
        args      => $args
    });

    # TODO Document Me
    return 1;
}

sub remove_component {
    my ($self, $component) = @_;

    my $name;

    # Handle either a component object or a scalar name
    if(ref($component)) {
        if($component->can('name')) {
            $name = $component->name();
        } else {
            die('Must supply a Component or a scalar name.');
        }
    } else {
        $name = $component;
    }

    my $count = 0;
    foreach my $comp (@{ $self->components }) {
        if(defined($comp) && $comp->name eq $name) {
            delete($self->components->[$count]);
        }
        $count++;
    }
}

sub validate_component {
    my ($self, $c, $a) = @_;

    return 1;
}


1;
__END__
=head1 NAME

Layout::Manager - 2D Layout Management

=head1 SYNOPSIS

Layout::Manager provides a simple interface for creating layout managers, or
classes that size and position components withing a container.

A few managers are provided for reference, but this module is primarily meant
to serve as a base for outside implementations.

    use Layout::Manager;

    my $foo = Layout::Manager->new();
    ...

=head1 WRITING A LAYOUT MANAGER

Layout::Manager provides all the methods necessary for your implementation,
save the I<layout> method.  This method will be called when it is time to
layout the components.

The I<add_component> method takes two arguments: the component and a second,
abritrary piece of data.  If your layout manager is simple, like 
L<Compass|Layout::Manager::Compass>, you may only require a simple variable
like "NORTH".  If you create something more complex the second argument may be
a hashref or an object.

The value of the I<components> method is an arrayref of hashrefs.  The
hashrefs have two keys:

=over 

=item B<component>
The component to be laid out.

=item B<args>

The argument provided to I<add_component>.

=head1 METHODS

=over 4

=item add_component

Add a component to the layout manager.  A second argument may be required,
please consult the POD for your specific layout manager implementation.

=item clear_components

Remove all components from the layout manager.

=item count_components

Returns the number of components in this layout manager.

=item remove_component

Removes a component.  B<component must have names to be removed.>

=item validate_component.

Optionally overriden by an implementation, allows it to deem 

=back

=head1 AUTHOR

Cory Watson, C<< <cory.watson at iinteractive.com> >>

=head1 SEE ALSO

perl(1), L<Wikipedia|http://en.wikipedia.org/wiki/HSL_color_space>

=head1 COPYRIGHT & LICENSE

Copyright 2008 by Infinity Interactive, Inc.

L<http://www.iinteractive.com>

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.