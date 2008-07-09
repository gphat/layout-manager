use lib 't/lib', 'lib';

use Test::More tests => 11;

use Geometry::Primitive::Point;
use LM::Test::Component;

BEGIN {
    use_ok('Layout::Manager::Compass');
}

my $lm = Layout::Manager::Compass->new();

my $foo = new LM::Test::Component(
    name => 'one', minimum_height => 20, minimum_width => 50
);

my $foo2 = new LM::Test::Component(
    name => 'two', minimum_height => 20, minimum_width => 50
);

my $cont = new LM::Test::Component(
    width => 100, height => 20
);

$lm->add_component($foo, 'EaSt');
cmp_ok($lm->component_count, '==', 1, 'component_count');

$lm->add_component($foo2, 'e');
cmp_ok($lm->component_count, '==', 2, 'component_count');

$lm->do_layout($cont);

cmp_ok($foo->height, '==', 20, 'right bottom component height');
cmp_ok($foo->width, '==', 50, 'right component width');
cmp_ok($foo->origin->x, '==', 50, 'right component origin x');
cmp_ok($foo->origin->y, '==', 0, 'right component origin y');

cmp_ok($foo2->height, '==', 20, 'left component height');
cmp_ok($foo2->width, '==', 50, 'left component width');
cmp_ok($foo2->origin->x, '==', 0, 'left component origin x');
cmp_ok($foo2->origin->y, '==', 0, 'left component origin y');
