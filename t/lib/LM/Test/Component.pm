package # Hide from CPAN
    LM::Test::Component;
use Moose;

with 'Layout::Manager::Component';

sub prepare { }

sub draw { }

1;