#!perl

use strict;
use warnings;

use Test::More tests => 50;

BEGIN {
    use_ok( 'App::HWD::Task' );
}


SIMPLE: {
    my $str = '-Create TW::DB::QuoteHead';

    my $task = App::HWD::Task->parse( $str );
    isa_ok( $task, 'App::HWD::Task' );
    is( $task->name, 'Create TW::DB::QuoteHead' );
    is( $task->level, 1 );
    is( $task->estimate, 0 );
    is( $task->id, '' );
    is( $task->date_added, '' );
    is( $task->summary, 'Create TW::DB::QuoteHead (0/0)', 'Summary');
}

WITH_ID: {
    my $str = '--API Pod Docs (#198)';

    my $task = App::HWD::Task->parse( $str );
    isa_ok( $task, 'App::HWD::Task' );
    is( $task->name, 'API Pod Docs' );
    is( $task->level, 2 );
    is( $task->estimate, 0 );
    is( $task->id, 198 );
    is( $task->date_added, '' );
    is( $task->summary, '198 - API Pod Docs (0/0)', 'Summary');
}

WITH_ESTIMATE: {
    my $str = '---API Pod Docs (4h)';

    my $task = App::HWD::Task->parse( $str );
    isa_ok( $task, 'App::HWD::Task' );
    is( $task->name, 'API Pod Docs' );
    is( $task->level, 3 );
    is( $task->estimate, 4 );
    is( $task->id, '' );
    is( $task->date_added, '' );
    is( $task->summary, 'API Pod Docs (4/0)', 'Summary');
}

WITH_ID_AND_ESTIMATE: {
    my $str = '----Retrofitting widgets (#142, 3h)';

    my $task = App::HWD::Task->parse( $str );
    isa_ok( $task, 'App::HWD::Task' );
    is( $task->name, 'Retrofitting widgets' );
    is( $task->level, 4 );
    is( $task->estimate, 3 );
    is( $task->id, 142 );
    is( $task->date_added, '' );
    is( $task->summary, '142 - Retrofitting widgets (3/0)', 'Summary');
}

WITH_ESTIMATE_AND_ID: {
    my $str = '-Flargling dangows (9h ,#2112)';

    my $task = App::HWD::Task->parse( $str );
    isa_ok( $task, 'App::HWD::Task' );
    is( $task->name, 'Flargling dangows' );
    is( $task->level, 1 );
    is( $task->estimate, 9 );
    is( $task->id, 2112 );
    is( $task->date_added, '' );
    is( $task->summary, '2112 - Flargling dangows (9/0)', 'Summary');
}

WITH_PARENS: {
    my $str = '-Voodoo Chile (Slight Return) (#43)';
    my $task = App::HWD::Task->parse( $str );
    isa_ok( $task, 'App::HWD::Task' );
    is( $task->name, 'Voodoo Chile (Slight Return)' );
    is( $task->level, 1 );
    is( $task->estimate, 0 );
    is( $task->id, 43 );
    is( $task->date_added, '' );
    is( $task->summary, '43 - Voodoo Chile (Slight Return) (0/0)', 'Summary');
}

WITH_ID_AND_ESTIMATE_AND_DATE: {
    my $str = '----Retrofitting widgets (#142, 3h, added 12/7)';
    my $task = App::HWD::Task->parse( $str );
    isa_ok( $task, 'App::HWD::Task' );
    is( $task->name, 'Retrofitting widgets' );
    is( $task->level, 4 );
    is( $task->estimate, 3 );
    is( $task->id, 142 );
    is( $task->date_added, '12/7', 'Task date' );
    is( $task->summary, '142 - Retrofitting widgets (3/0)', 'Summary' );
}
