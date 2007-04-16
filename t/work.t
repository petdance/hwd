#!perl

use strict;
use warnings;

use Test::More tests => 25;

BEGIN {
    use_ok( 'App::HWD::Work' );
}

SIMPLE: {
    my $str = 'Pete    2005-07-11    195 0000.250';
    my $work = App::HWD::Work->parse( $str );
    isa_ok( $work, 'App::HWD::Work' );

    is( $work->who, 'Pete', 'Who' );
    is( $work->when, '2005-07-11', 'When' );
    isa_ok( $work->when_obj, 'DateTime', 'When' );
    is( $work->task, 195, 'Task' );
    cmp_ok( $work->hours, '==', .25, 'Hours match' );
    is( $work->comment, '', 'no comment' );
    ok( !$work->completed, 'not completed' );
}

COMPLETED: {
    my $str = 'Pete    2005-07-11    195 2 x    ';
    my $work = App::HWD::Work->parse( $str );
    isa_ok( $work, 'App::HWD::Work' );

    is( $work->who, 'Pete', 'Who' );
    is( $work->when, '2005-07-11', 'When' );
    isa_ok( $work->when_obj, 'DateTime', 'When' );
    is( $work->task, 195, 'Task' );
    cmp_ok( $work->hours, '==', 2, 'Hours match' );
    is( $work->comment, '', 'no commment' );
    ok( $work->completed, 'completed' );
}

COMPLETED: {
    my $str = 'Bob 2005-08-11    1 .75 X #       Refactoring   ';
    my $work = App::HWD::Work->parse( $str );
    isa_ok( $work, 'App::HWD::Work' );

    is( $work->who, 'Bob', 'Who' );
    is( $work->when, '2005-08-11', 'When' );
    isa_ok( $work->when_obj, 'DateTime', 'When' );
    is( $work->task, 1, 'task' );
    cmp_ok( $work->hours, '==', .75, 'Hours match' );
    is( $work->comment, 'Refactoring', 'Non-empty comment' );
    ok( $work->completed, 'Completed' );
}
