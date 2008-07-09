use lib 't/lib', 'lib';

use Test::More tests => 11;

use Geometry::Primitive::Point;
use LM::Test::Component;

BEGIN {
    use_ok('Layout::Manager::Compass');
}

my $lm = Layout::Manager::Compass->new();

my $foo = new LM::Test::Component(
    name => 'one', minimum_height => 20, minimum_width => 20
);

my $foo2 = new LM::Test::Component(
    name => 'two', minimum_height => 20, minimum_width => 20
);

my $cont = new LM::Test::Component(
    width => 100, height => 40
);

$lm->add_component($foo, 's');
cmp_ok($lm->component_count, '==', 1, 'component_count');

$lm->add_component($foo2, 'e');
cmp_ok($lm->component_count, '==', 2, 'component_count');

$lm->do_layout($cont);

cmp_ok($foo->height, '==', 20, 'bottom component height');
cmp_ok($foo->width, '==', 80, 'bottom component width');
cmp_ok($foo->origin->x, '==', 0, 'bottom component origin x');
cmp_ok($foo->origin->y, '==', 20, 'bottom component origin y');

cmp_ok($foo2->height, '==', 20, 'right component height');
cmp_ok($foo2->width, '==', 20, 'right component width');
cmp_ok($foo2->origin->x, '==', 80, 'right component origin x');
cmp_ok($foo2->origin->y, '==', 0, 'right component origin y');
