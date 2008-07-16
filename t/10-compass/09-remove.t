use lib 't/lib', 'lib';

use Test::More tests => 19;

use Geometry::Primitive::Point;
use LM::Test::Component;

BEGIN {
    use_ok('Layout::Manager::Compass');
}

my $lm = Layout::Manager::Compass->new();

my $north = new LM::Test::Component(
    minimum_height => 10, minimum_width => 10, name => 'north'
);
my $south = new LM::Test::Component(
    minimum_height => 10, minimum_width => 10
);
my $east = new LM::Test::Component(
    minimum_height => 10, minimum_width => 10
);
my $west = new LM::Test::Component(
    minimum_height => 10, minimum_width => 10
);
my $center = new LM::Test::Component(
    minimum_height => 10, minimum_width => 10
);

$lm->add_component($north, 'n');
$lm->add_component($south, 's');
$lm->add_component($east, 'e');
$lm->add_component($west, 'w');
$lm->add_component($center, 'c');

my $cont = new LM::Test::Component(
    width => 120, height => 100
);

my $count = $lm->remove_component('north');
cmp_ok($count, '==', 1, 'removed north');

cmp_ok($lm->component_count, '==', 5, 'component_count');

$lm->do_layout($cont);

cmp_ok($south->origin->x, '==', 10, 'south origin x');
cmp_ok($south->origin->y, '==', 90, 'south origin y');
cmp_ok($south->width, '==', 100, 'south width');
cmp_ok($south->height, '==', 10, 'south height');

cmp_ok($east->origin->x, '==', 110, 'east origin x');
cmp_ok($east->origin->y, '==', 0, 'east origin y');
cmp_ok($east->width, '==', 10, 'east width');
cmp_ok($east->height, '==', 90, 'east height');

cmp_ok($west->origin->x, '==', 0, 'west origin x');
cmp_ok($west->origin->y, '==', 0, 'west origin y');
cmp_ok($west->width, '==', 10, 'west width');
cmp_ok($west->height, '==', 90, 'west height');

cmp_ok($center->origin->x, '==', 10, 'center origin x');
cmp_ok($center->origin->y, '==', 0, 'center origin y');
cmp_ok($center->width, '==', 100, 'center width');
cmp_ok($center->height, '==', 90, 'center height');