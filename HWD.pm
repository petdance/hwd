package App::HWD;

use warnings;
use strict;

use App::HWD::Task;
use App::HWD::Work;

=head1 NAME

App::HWD - How We Doin', the task tracking tool

=head1 VERSION

Version 0.10

=cut

our $VERSION = '0.10';

=head1 SYNOPSIS

This module is nothing more than a place-holder for the version info and the TODO list.

=head1 TODO

=over 4

=item * Better documentation

=item * Samples so that prospective users can see what it will do.

=item * Tutorial showing different commands and output

=item * Add support for HWDFILE environment variable so those of us who
are only ever using one file don't have to keep retyping the name all
the time.

=item * Make sure a rollup task has no hours, and that any task with no
hours has tasks below it.

=item * Add support for changing estimates on a task

=item * Open tasks are doubling up if two people have it open.

=item * Show task history

=item * Show tasks that are too big.

=item * Show tasks that have gone over

=item * Weekly burndown

The C<--burndown> flag gives totals as they happen.  I want them to give
a Monday-morning total since I like to plot weekly, not daily.

=back

=head1 FUNCTIONS

These functions are used by F<hwd>, but are kept here so I can easily
test them.

=head2 get_tasks_and_work( @tasks )

Reads tasks and work, and applies the work to the tasks.

Returns references to C<@tasks>, C<@work> and C<%tasks_by_id>.

=cut

sub get_tasks_and_work {
    my @tasks;
    my @work;
    my %tasks_by_id;

    my @parents;
    my $curr_task;
    my $lineno = 0;
    for my $line ( @_ ) {
        ++$lineno;
        chomp $line;
        next if $line =~ /^\s*#/;
        next if $line !~ /./;

        if ( $line =~ /^(-+)/ ) {
            my $level = length $1;
            my $parent;
            if ( $level > 1 ) {
                $parent = $parents[ $level - 1 ]
                    or die "Line $lineno has no parent: $line\n";
            }
            my $task = App::HWD::Task->parse( $line, $parent );
            die "Can't parse line $lineno: $line\n" unless $task;
            if ( $task->id ) {
                if ( $tasks_by_id{ $task->id } ) {
                    die "Dupe task ID on line $lineno: Task ", $task->id, "\n";
                }
                $tasks_by_id{ $task->id } = $task;
            }
            push( @tasks, $task );
            $curr_task = $task;
            $parent->add_child( $task ) if $parent;

            @parents = @parents[0..$level-1];   # Clear any sub-parents
            $parents[ $level ] = $task;         # Set the new one
        }
        elsif ( $line =~ /^\s+/ ) {
            $curr_task->add_notes( $line );
        }
        else {
            my $work = App::HWD::Work->parse( $line );
            push( @work, $work );
        }
    } # while

    for my $work ( @work ) {
        my $task = $tasks_by_id{ $work->task }
            or die "No task ID ", $work->task, "\n";
        $task->add_work( $work );
    }

    $_->sort_work() for @tasks;

    return( \@tasks, \@work, \%tasks_by_id );
}

=head1 AUTHOR

Andy Lester, C<< <andy at petdance.com> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-app-hwd at rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=App-HWD>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head1 ACKNOWLEDGEMENTS

Thanks to
Neil Watkiss
and Luke Closs for features and patches.

=head1 COPYRIGHT & LICENSE

Copyright 2005 Andy Lester, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1; # End of App::HWD
