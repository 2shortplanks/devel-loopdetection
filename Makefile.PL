use inc::Module::Install;

# Define metadata
name           'Devel-LoopDetection';
all_from       'lib/Devel/LoopDetection.pm';

requires       'Data::UUID'  => '0';
test_requires  'Test::More'  => '0';

license 'perl';

WriteAll;
