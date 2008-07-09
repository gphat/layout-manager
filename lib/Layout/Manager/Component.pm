package Layout::Manager::Component;
use Moose::Role;

requires 'prepare';
requires 'draw';

has 'height' => ( is => 'rw', isa => 'Num', default => sub { 0 } );
has 'name' => ( is => 'rw', isa => 'Str' );
has 'origin' => (
    is => 'rw',
    isa => 'Geometry::Primitive::Point',
    default =>  sub { Geometry::Primitive::Point->new( x => 0, y => 0 ) },
);
has 'width' => ( is => 'rw', isa => 'Num', default => sub { 0 } );

has 'preferred_height' => ( is => 'rw', isa => 'Num', default => sub { 0 });
has 'preferred_width' => ( is => 'rw', isa => 'Num', default => sub { 0 });
has 'minimum_height' => ( is => 'rw', isa => 'Num', default => sub { 0 } );
has 'minimum_width' => ( is => 'rw', isa => 'Num', default => sub { 0 } );
has 'maximum_height' => ( is => 'rw', isa => 'Num', default => sub { 0 } );
has 'maximum_width' => ( is => 'rw', isa => 'Num', default => sub { 0 } );

sub compute_height {
    my ($self, $type) = @_;

    if($type eq 'preferred') {
        return $self->preferred_height;
    } elsif($type eq 'minimum') {
        return $self->minumum_height;
    }
    # else
    return $self->maximum_height;
}

1;
__END__
=head1 NAME

Layout::Manager::Component - Component Role

=head1 SYNOPSIS

Layout::Manager resizes and repositions components.  This role provides the
blueprint for your objects to be moveable by Layout::Manager.  Simply add this
role to your class and implement the required methods.

    package My::Widget;
    use Moose;
    
    with 'Layout::Manager::Component';

    has 'width' ...
    has 'height' ...
    has 'origin' ...

This role does not provide an implementation of these methods.  This might be
surprising because it _could_.  I originally intended to implement the
attributes here and use the role in L<Geomtry::Primitive> or
L<Graphics::Primitive> but it would've created a circular dependency, so I
opted to leave this bit of yak shaving up to you.  This may change in the
future as the APIs of these modules solidifies.

=head1 METHODS

=over 4

=item I<name>

Name of this component.  Used to find specific components after they've been
added to this layout manager.

=item I<height>

Set/get the height of the component.

=item I<maximum_height>

Set/get the maximum height for this component. Defaults to 0.

=item I<maximum_width>

Set/get the maximum width for this component. Defaults to 0.

=item I<minimum_height>

Set/get the minimum height for this component. Defaults to 0.

=item I<minimum_width>

Set/get the minimum width for this component.  Defaults to 0.

=item I<origin>

Set/get the origin point of this component.  This is expected to be a
L<Geometry::Primitive::Point> object.

=item I<preferred_height>

Set/get the preferred height for this component. Defaults to 0.

=item I<preferred_height>

Set/get the minimum height for this component. Defaults to 0.

=item I<width>

Set/get the width of the component.

=back

=head1 AUTHOR

Cory Watson, C<< <gphat@cpan.org> >>

Infinity Interactive, L<http://www.iinteractive.com>

=head1 SEE ALSO

=head1 COPYRIGHT & LICENSE

Copyright 2008 by Infinity Interactive, Inc.

L<http://www.iinteractive.com>

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.