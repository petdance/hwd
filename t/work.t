#!perl

use strict;
use warnings;

use Test::More tests => 22;

BEGIN {
    use_ok( 'App::HWD::Work' );
}

SIMPLE: {
    my $str = 'Pete    7/11    195 0000.250';
    my $work = App::HWD::Work->parse( $str );
    isa_ok( $work, 'App::HWD::Work' );

    is( $work->who, 'Pete', 'Who' );
    is( $work->when, '7/11', 'When' );
    is( $work->task, 195, 'Task' );
    cmp_ok( $work->hours, '==', .25, 'Hours match' );
    is( $work->comment, '', 'no comment' );
    ok( !$work->completed, 'not completed' );
}

COMPLETED: {
    my $str = 'Pete    7/11    195 2 x    ';
    my $work = App::HWD::Work->parse( $str );
    isa_ok( $work, 'App::HWD::Work' );

    is( $work->who, 'Pete', 'Who' );
    is( $work->when, '7/11', 'When' );
    is( $work->task, 195, 'Task' );
    cmp_ok( $work->hours, '==', 2, 'Hours match' );
    is( $work->comment, '', 'no commment' );
    ok( $work->completed, 'completed' );
}

COMPLETED: {
    my $str = 'Bob 8/11    1 .75 X #       Refactoring   ';
    my $work = App::HWD::Work->parse( $str );
    isa_ok( $work, 'App::HWD::Work' );

    is( $work->who, 'Bob', 'Who' );
    is( $work->when, '8/11', 'When' );
    is( $work->task, 1, 'task' );
    cmp_ok( $work->hours, '==', .75, 'Hours match' );
    is( $work->comment, 'Refactoring', 'Non-empty comment' );
    ok( $work->completed, 'Completed' );
}
