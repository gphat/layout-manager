use Test::More tests => 1;

use Graphics::Primitive::Component;

BEGIN {
    use_ok('Layout::Manager::Compass');
}

my $lm = Layout::Manager::Compass->new();

# TODO Normalize rectangle origin
my $foo = new Geometry::Primitive::Component()