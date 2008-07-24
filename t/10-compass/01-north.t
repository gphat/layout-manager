use lib 't/lib', 'lib';

use Test::More tests => 11;

use Geometry::Primitive::Point;
use LM::Test::Component;
use LM::Test::Container;

BEGIN {
    use_ok('Layout::Manager::Compass');
}

my $foo = LM::Test::Component->new(
    name => 'one', minimum_height => 20, minimum_width => 100
);

my $foo2 = LM::Test::Component->new(
    name => 'two', minimum_height => 20, minimum_width => 100
);

my $cont = LM::Test::Container->new(
    width => 100, height => 40
);

$cont->add_component($foo, 'NORTH');
cmp_ok($cont->component_count, '==', 1, 'component_count');

$cont->add_component($foo2, 'north');
cmp_ok($cont->component_count, '==', 2, 'component_count');

my $lm = Layout::Manager::Compass->new;
$lm->do_layout($cont);

cmp_ok($foo->height, '==', 20, 'top component height');
cmp_ok($foo->width, '==', 100, 'top component width');
cmp_ok($foo->origin->x, '==', 0, 'top component origin x');
cmp_ok($foo->origin->y, '==', 0, 'top component origin y');

cmp_ok($foo2->height, '==', 20, 'bottom component height');
cmp_ok($foo2->width, '==', 100, 'bottom component width');
cmp_ok($foo2->origin->x, '==', 0, 'bottom component origin x');
cmp_ok($foo2->origin->y, '==', 20, 'bottom component origin y');
