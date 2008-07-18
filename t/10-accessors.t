use lib 't/lib', 'lib';

use Test::More tests => 6;

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
    minimum_height => 20, minimum_width => 10, name => 'south'
);
my $east = new LM::Test::Component(
    minimum_height => 30, minimum_width => 10
);
my $west = new LM::Test::Component(
    minimum_height => 40, minimum_width => 10
);
my $center = new LM::Test::Component(
    minimum_height => 50, minimum_width => 10
);

$lm->add_component($north, 'n');
$lm->add_component($south, 's');
$lm->add_component($east, 'e');
$lm->add_component($west, 'w');
$lm->add_component($center, 'c');

cmp_ok($lm->component_count, '==', 5, 'component_count');
my $c = $lm->find_component('south');
ok(defined($c), 'find_component');
cmp_ok($c->minimum_height, '==', 20, 'correct height');

my $c2 = $lm->get_component(2);
ok(defined($c2), 'get_component');
cmp_ok($c2->{component}->minimum_height, '==', 30, 'correct height');
