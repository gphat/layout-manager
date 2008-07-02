use lib 'lib';

use Test::More tests => 18;

use Geometry::Primitive::Point;
use LM::Test::Component;

BEGIN {
    use_ok('Layout::Manager::Compass');
}

my $lm = Layout::Manager::Compass->new();

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

$lm->add_component($north, 'n');
$lm->add_component($south, 's');
$lm->add_component($east, 'e');
$lm->add_component($west, 'w');

my $cont = new LM::Test::Component(
    width => 30, height => 30
);

cmp_ok($lm->component_count, '==', 4, 'component_count');

$lm->do_layout($cont);

cmp_ok($north->origin->x, '==', 10, 'north origin x');
cmp_ok($north->origin->y, '==', 0, 'north origin y');
cmp_ok($north->width, '==', 10, 'north width');
cmp_ok($north->height, '==', 10, 'north height');

cmp_ok($south->origin->x, '==', 10, 'south origin x');
cmp_ok($south->origin->y, '==', 20, 'south origin y');
cmp_ok($south->width, '==', 10, 'south width');
cmp_ok($south->height, '==', 10, 'south height');

cmp_ok($east->origin->x, '==', 20, 'east origin x');
cmp_ok($east->origin->y, '==', 10, 'east origin y');
cmp_ok($east->width, '==', 10, 'east width');
cmp_ok($east->height, '==', 10, 'east height');

cmp_ok($west->origin->x, '==', 0, 'west origin x');
cmp_ok($west->origin->y, '==', 10, 'west origin y');
cmp_ok($west->width, '==', 10, 'west width');
cmp_ok($west->height, '==', 10, 'west height');