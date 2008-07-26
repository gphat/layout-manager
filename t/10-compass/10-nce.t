use lib 't/lib', 'lib';

use Test::More tests => 14;

use Geometry::Primitive::Point;
use LM::Test::Component;
use LM::Test::Container;

BEGIN {
    use_ok('Layout::Manager::Compass');
}

my $foo = LM::Test::Component->new(
    name => 'one', minimum_height => 20, minimum_width => 20
);
my $foo2 = LM::Test::Component->new(
    name => 'two', minimum_height => 20, minimum_width => 20
);
my $foo3 = LM::Test::Component->new(
    name => 'three', minimum_height => 20, minimum_width => 20
);

my $cont = LM::Test::Container->new(
    width => 100, height => 40
);

$cont->add_component($foo, 'n');
$cont->add_component($foo2, 'e');
$cont->add_component($foo3, 'c');

cmp_ok($cont->component_count, '==', 3, 'component count');

my $lm = Layout::Manager::Compass->new;
$lm->do_layout($cont);

cmp_ok($foo->width, '==', 100, 'top component width');
cmp_ok($foo->height, '==', 20, 'top component height');
cmp_ok($foo->origin->x, '==', 0, 'top component origin x');
cmp_ok($foo->origin->y, '==', 0, 'top component origin y');

cmp_ok($foo2->width, '==', 20, 'right component width');
cmp_ok($foo2->height, '==', 20, 'right component height');
cmp_ok($foo2->origin->x, '==', 80, 'right component origin x');
cmp_ok($foo2->origin->y, '==', 20, 'right component origin y');

cmp_ok($foo3->origin->x, '==', 0, 'center origin x');
cmp_ok($foo3->origin->y, '==', 20, 'center origin y');
cmp_ok($foo3->width, '==', 80, 'center width');
cmp_ok($foo3->height, '==', 20, 'center height');
