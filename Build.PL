use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Test::File::Contents',
    license             => '',
    dist_author         => 'Kirrily Robert <skud@cpan.org>',
    dist_version_from   => 'lib/Test/File/Contents.pm',
    requires => {
        'Test::More' => 0,
    },
    add_to_cleanup      => [ 'Test-File-Contents-*' ],
);

$builder->create_build_script();
