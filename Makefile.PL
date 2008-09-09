use inc::Module::Install 0.75;

name     'Layout-Manager';
all_from 'lib/Layout/Manager.pm';
author   'Cory G Watson <gphat@cpan.org>';

build_requires 'Test::More';

requires 'Moose' => '0.54';
requires 'MooseX::AttributeHelpers' => '0.12';
requires 'Geometry::Primitive' => '0.10';
requires 'Graphics::Primitive' => '0.25';

tests_recursive;

auto_install;

WriteAll;

