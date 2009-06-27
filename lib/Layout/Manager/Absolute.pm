package Layout::Manager::Absolute;
use Moose;

extends 'Layout::Manager';

__PACKAGE__->meta->make_immutable;

no Moose;

1;
__END__
=head1 NAME

Layout::Manager::Absolute - No frills layout manager

=head1 DESCRIPTION

Does nothing.  Expects that all components will be positioned already.

=head1 SYNOPSIS

  my $lm = Layout::Manager::Absolute->new;
  
  $lm->add_component($comp1);
  $lm->add_component($comp2);

  $lm->do_layout($container);

=head1 METHODS

=head2 do_layout

Size and position the components in this layout.

=head1 AUTHOR

Cory Watson, C<< <gphat@cpan.org> >>

=head1 COPYRIGHT & LICENSE

Copyright 2008-2009 by Cory G Watson

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.