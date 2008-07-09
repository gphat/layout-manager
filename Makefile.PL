use inc::Module::Install;

name     'Layout-Manager';
all_from 'lib/Layout/Manager.pm';
author   'Cory G Watson <gphat@cpan.org>';

build_requires 'Test::More';

test_requires 'Pod::Coverage::Moose';

requires 'Moose';
requires 'MooseX::AttributeHelpers' => '0.12';
requires 'Geometry::Primitive';

tests_recursive;

auto_install;

WriteAll;

