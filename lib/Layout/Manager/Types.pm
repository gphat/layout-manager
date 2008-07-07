package Layout::Manager::Types;
use Moose;

use Moose::Util::TypeConstraints;

enum 'Layout::Manager::Type::Orientation' => qw(horizontal vertical);

no Moose;
1;
__END__
=head1 NAME

Layout::Manager::Types- Types for use with Layout::Manager

=head1 SYNOPSIS

Layout::Manager implementations occasionally require a bit more information
than origin and width/height.  Somtimes components need to know more
information for their own internal layout as well.  This package provides
those types.

    use Layout::Manager::Types;

=head1 TYPES

=over 

=item B<Layout::Manager::Type::Orientation>

The way a component is oriented values allowed are 'horizontal' or 'vertical'.

=back

=head1 AUTHOR

Cory Watson, C<< <cory.watson at iinteractive.com> >>

=head1 SEE ALSO

perl(1)

=head1 COPYRIGHT & LICENSE

Copyright 2008 by Infinity Interactive, Inc.

L<http://www.iinteractive.com>

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.