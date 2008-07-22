use lib 't/lib', 'lib';

use Test::More tests => 22;

use Geometry::Primitive::Point;
use LM::Test::Component;

BEGIN {
    use_ok('Layout::Manager::Compass');
}

my $north = new LM::Test::Component(
    minimum_height => 10, minimum_width => 10
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

my $cont = new LM::Test::Component(
    width => 120, height => 100
);

$cont->add_component($north, 'n');
$cont->add_component($south, 's');
$cont->add_component($east, 'e');
$cont->add_component($west, 'w');
$cont->add_component($center, 'c');

cmp_ok($cont->component_count, '==', 5, 'component_count');

my $lm = Layout::Manager::Compass->new();
$lm->do_layout($cont);

cmp_ok($north->origin->x, '==', 10, 'north origin x');
cmp_ok($north->origin->y, '==', 0, 'north origin y');
cmp_ok($north->width, '==', 100, 'north width');
cmp_ok($north->height, '==', 10, 'north height');

cmp_ok($south->origin->x, '==', 10, 'south origin x');
cmp_ok($south->origin->y, '==', 90, 'south origin y');
cmp_ok($south->width, '==', 100, 'south width');
cmp_ok($south->height, '==', 10, 'south height');

cmp_ok($east->origin->x, '==', 110, 'east origin x');
cmp_ok($east->origin->y, '==', 10, 'east origin y');
cmp_ok($east->width, '==', 10, 'east width');
cmp_ok($east->height, '==', 80, 'east height');

cmp_ok($west->origin->x, '==', 0, 'west origin x');
cmp_ok($west->origin->y, '==', 10, 'west origin y');
cmp_ok($west->width, '==', 10, 'west width');
cmp_ok($west->height, '==', 80, 'west height');

cmp_ok($center->origin->x, '==', 10, 'center origin x');
cmp_ok($center->origin->y, '==', 10, 'center origin y');
cmp_ok($center->width, '==', 100, 'center width');
cmp_ok($center->height, '==', 80, 'center height');