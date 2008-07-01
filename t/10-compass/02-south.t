use Test::More tests => 4;

use Geometry::Primitive::Point;
use LM::Test::Component;

BEGIN {
    use_ok('Layout::Manager::Compass');
}

my $lm = Layout::Manager::Compass->new();

# TODO Normalize rectangle origin
my $foo = new LM::Test::Component(
    width => 100, height => 20, name => 'one'
);

my $foo2 = new LM::Test::Component(
    width => 100, height => 25, name => 'two', preferred_height => 10
);

my $cont = new LM::Test::Component(
    width => 100, height => 40
);

$lm->add_component($foo, 'South');
cmp_ok($lm->component_count, '==', 1, 'component_count');

$lm->add_component($foo2, 'S');
cmp_ok($lm->component_count, '==', 2, 'component_count');

$lm->do_layout($cont);

cmp_ok($lm->_south_size(), '==', 40, '_south_size');