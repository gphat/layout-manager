package Layout::Manager;
use Moose;

our $AUTHORITY = 'cpan:GPHAT';
our $VERSION = '0.02';

use MooseX::AttributeHelpers;

has 'components' => (
    metaclass => 'Collection::Array',
    is => 'rw',
    isa => 'ArrayRef',
    default => sub { [] },
    provides => {
        'clear'=> 'clear_components',
        'count'=> 'component_count',
        'get' => 'get_component'
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

sub do_prepare {
    my ($self) = @_;

    foreach my $c (@{ $self->components }) {
        $c->{component}->prepare();
    }
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

=head1 USING A LAYOUT MANAGER

Various implementations of Layout::Manager will require you do add components
with slightly different second arguments, but the general case will be:

  $lm->add_component($comp, $constraints);

The contents of B<$constraints> must be discerned by reading the documentation
for the layout manager you are using.

The B<$comp> argument must be a class that implements the
L<Layout::Manager::Component> role.  For more information on Roles please read
the L<Moose::Role> documentation on the CPAN.

When you are ready to lay out your container, you'll need to call the
L<do_layout> method with a single argument: the component in which you are
laying things out.  This object is also expected to implement aforementioned
L<Layout::Manager::Component> role.  When I<do_layout> returns all of the
components should be resized and repositioned according to the rules of the
Layout::Manager implementation.

=head1 WRITING A LAYOUT MANAGER

Layout::Manager provides all the methods necessary for your implementation,
save the I<do_layout> method.  This method will be called when it is time to
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

=back

=head1 METHODS

=over 4

=item I<add_component>

Add a component to the layout manager.  Returns a true value if the component
was added successfully. A second argument may be required, please consult the
POD for your specific layout manager implementation.

Before the component is added, it is passed to the validate_component method.
If validate_component does not return a true value, then the component is not
added.

=item I<clear_components>

Remove all components from the layout manager.

=item I<count_components>

Returns the number of components in this layout manager.

=item I<do_layout>

Lays out this managers components in the specified container.

=item I<do_prepare>

Calls prepare on all this layout manager's child components.

=item I<get_component>

Get the component at the specified index.

=item I<remove_component>

Removes a component.  B<component must have names to be removed.>

=item I<validate_component>

Optionally overriden by an implementation, allows it to deem 

=back

=head1 AUTHOR

Cory Watson, C<< <gphat@cpan.org> >>

Infinity Interactive, L<http://www.iinteractive.com>

=head1 SEE ALSO

perl(1)

=head1 COPYRIGHT & LICENSE

Copyright 2008 by Infinity Interactive, Inc.

L<http://www.iinteractive.com>

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.