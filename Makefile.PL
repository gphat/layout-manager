use inc::Module::Install;

name     'Layout-Manager';
all_from 'lib/Layout/Manager.pm';
author   'Cory G Watson <cory.watson@iinteractive.com>';

build_requires 'Test::More';

test_requires 'Pod::Coverage::Moose';

requires 'Moose';
requires 'MooseX::AttributeHelpers' => '0.12';
requires 'Geoemetry::Primitive';


auto_install;

WriteAll;

