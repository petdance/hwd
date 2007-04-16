package App::HWD::Task;

use warnings;
use strict;

=head1 NAME

App::HWD::Task - Tasks for HWD

=head1 SYNOPSIS

Used only by the F<hwd> application.

Note that these functions are pretty fragile, and do almost no data
checking.

=head1 FUNCTIONS

=head2 App::HWD::Task->parse()

Returns an App::HWD::Task object from an input line

=cut

sub parse {
    my $class = shift;
    my $line = shift;

    my $line_regex = qr/
        ^
        (-+)        # leading dashes
        \s*         # whitespace
        (.+)        # everything else
        $
    /x;

    if ( $line =~ $line_regex ) {
        my $level = length $1;
        my $name = $2;
        my $id;
        my $estimate;
        my $date_added;

        if ( $name =~ s/\s*\(([^)]+)\)\s*$// ) {
            my $parens = $1;
            my @subfields = split /,/, $parens;
            for ( @subfields ) {
                s/^\s+//;
                s/\s+$//;
                /^#(\d+)$/ and $id = $1, next;
                /^(\d+)h$/ and $estimate = $1, next;
                /^added (\S+)$/i and $date_added = $1, next;
                warn "Don't understand $_";
            }
        }

        my $task = $class->new( {
            level       => $level,
            name        => $name,
            id          => $id,
            estimate    => $estimate,
            date_added  => $date_added,
        } );
    }
    else {
        return;
    }
}

=head2 App::HWD::Task->new( { args } )

Creates a new task from the args passed in.  They should include at
least I<level>, I<name> and I<id>, even if I<id> is C<undef>.

    my $task = App::HWD::Task->new( {
        level => $level,
        name => $name,
        id => $id,
        estimate => $estimate,
    } );

=cut

sub new {
    my $class = shift;
    my $args = shift;

    my $self = bless {
        %$args,
        work => [],
    }, $class;

    return $self;
}

=head2 $task->level()

Returns the level of the task

=head2 $task->name()

Returns the name of the task

=head2 $task->id()

Returns the ID of the task, or the empty string if there isn't one.

=head2 $task->estimate()

Returns the estimate, or 0 if it's not set.

=head2 $task->date_added()

Returns the date the task was added, or empty string if it's not set.

=head2 $task->work()

Returns the array of App::HWD::Work applied to the task.

=cut

sub level       { return shift->{level} }
sub name        { return shift->{name} }
sub id          { return shift->{id} || "" }
sub estimate    { return shift->{estimate} || 0 }
sub date_added  { return shift->{date_added} || '' }
sub work { return @{shift->{work}} }

=head2 $task->set( $key => $value )

Sets the I<$key> field to I<$value>.

=cut

sub set {
    my $self = shift;
    my $key = shift;
    my $value = shift;

    die "Dupe key $key" if exists $self->{$key};
    $self->{$key} = $value;
}

=head2 add_work( $work )

Adds a Work record to the task, for later accumulating

=cut

sub add_work {
    my $self = shift;
    my $work = shift;

    push( @{$self->{work}}, $work );
}

=head2 hours_worked()

Returns the number of hours worked, but counting up all the work records added in L</add_work>.

=cut

sub hours_worked {
    my $self = shift;

    my $hours = 0;
    for my $work ( @{$self->{work}} ) {
        $hours += $work->hours;
    }
    return $hours;
}

=head2 completed()

Returns whether the task has been completed.

=cut

sub completed {
    my $self = shift;

    my $completed = 0;
    for my $work ( @{$self->{work}} ) {
        $completed = $work->completed;
    }

    return $completed;
}

=head2 summary

Returns a simple one line description of the Work.

=cut

sub summary {
    my $self = shift;
    my $sum;
    $sum = $self->id . " - " if $self->id;
    $sum .= sprintf( "%s (%s/%s)", $self->name, $self->estimate, $self->hours_worked );
    return $sum;
}

=head1 AUTHOR

Andy Lester, C<< <andy at petdance.com> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-app-hwd-task@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=App-HWD>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

Copyright 2005 Andy Lester, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1; # End of App::HWD::Task
