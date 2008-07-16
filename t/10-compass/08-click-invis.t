use lib 't/lib', 'lib';

use Test::More tests => 18;

use Geometry::Primitive::Point;
use LM::Test::Component;

BEGIN {
    use_ok('Layout::Manager::Compass');
}

my $lm = Layout::Manager::Compass->new();

my $legend = new LM::Test::Component(
    minimum_height => 10, minimum_width => 10
);
my $yaxis = new LM::Test::Component(
    minimum_height => 10, minimum_width => 20, visible => 0
);
my $xaxis = new LM::Test::Component(
    minimum_height => 20, minimum_width => 10
);
my $plot = new LM::Test::Component(
    minimum_height => 10, minimum_width => 10
);

$lm->add_component($legend, 's');
$lm->add_component($xaxis, 's');
$lm->add_component($yaxis, 'w');
$lm->add_component($plot, 'c');

my $cont = new LM::Test::Component(
    width => 500, height => 300
);

cmp_ok($lm->component_count, '==', 4, 'component_count');

$lm->do_layout($cont);

cmp_ok($legend->origin->x, '==', 0, 'legend origin x');
cmp_ok($legend->origin->y, '==', 290, 'legend origin y');
cmp_ok($legend->width, '==', 500, 'legend width');
cmp_ok($legend->height, '==', 10, 'north height');

cmp_ok($yaxis->origin->x, '==', 0, 'yaxis origin x');
cmp_ok($yaxis->origin->y, '==', 0, 'yaxys origin y');
cmp_ok($yaxis->width, '==', 0, 'yaxis width');
cmp_ok($yaxis->height, '==', 0, 'yaxis height');

cmp_ok($xaxis->origin->x, '==', 0, 'xaxis origin x');
cmp_ok($xaxis->origin->y, '==', 270, 'xaxis origin y');
cmp_ok($xaxis->width, '==', 500, 'xaxis width');
cmp_ok($xaxis->height, '==', 20, 'xaxis height');

cmp_ok($plot->origin->x, '==', 0, 'plot origin x');
cmp_ok($plot->origin->y, '==', 0, 'plot origin y');
cmp_ok($plot->width, '==', 500, 'plot width');
cmp_ok($plot->height, '==', 270, 'plot height');
