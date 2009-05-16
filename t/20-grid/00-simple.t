use strict;
use Test::More tests => 9;

use Graphics::Primitive::Component;
use Graphics::Primitive::Container;

BEGIN {
    use_ok('Layout::Manager::Grid');
}

my $foo = Graphics::Primitive::Component->new(
    name => 'one', minimum_height => 20, minimum_width => 100
);

my $foo2 = Graphics::Primitive::Component->new(
    name => 'two', minimum_height => 20, minimum_width => 100
);

my $cont = Graphics::Primitive::Container->new(
    width => 100, height => 80
);

$cont->add_component($foo, { row => 0, column => 0 });
$cont->add_component($foo2, { row => 0, column => 1 });

my $lm = Layout::Manager::Grid->new(rows => 1, columns => 2);
$lm->do_layout($cont);

cmp_ok($foo->height, '==', 80, 'top component height');
cmp_ok($foo->width, '==', 50, 'top component width');
cmp_ok($foo->origin->x, '==', 0, 'top component origin x');
cmp_ok($foo->origin->y, '==', 0, 'top component origin y');

cmp_ok($foo2->height, '==', 80, 'bottom component height');
cmp_ok($foo2->width, '==', 50, 'bottom component width');
cmp_ok($foo2->origin->x, '==', 50, 'bottom component origin x');
cmp_ok($foo2->origin->y, '==', 0, 'bottom component origin y');
