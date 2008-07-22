package Layout::Manager;
use Moose;

our $AUTHORITY = 'cpan:GPHAT';
our $VERSION = '0.08';

use MooseX::AttributeHelpers;

sub do_layout {
}

__PACKAGE__->meta->make_immutable;

no Moose;

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

=head1 TIPS

Layout manager implementations should honor the I<visible> attribute of a
component, as those components need to be ignored.

=head1 METHODS

=over 4

=item I<do_layout>

Lays out this managers components in the specified container.

=item I<do_prepare>

Calls prepare on all this layout manager's child components.

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