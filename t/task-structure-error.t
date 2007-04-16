#!perl -Tw

use strict;
use warnings;

use Test::More tests => 2;
use Test::Exception;

BEGIN {
    use_ok( 'App::HWD' );
}

throws_ok {
    my ($tasks,$work,$tasks_by_id) = App::HWD::get_tasks_and_work( <DATA> );
} qr/has no parent/i, "Throws a warning on incorrect hierarchy";

__DATA__
-Phase A
---Prep
---Start branch (#100, 2h)
--LISTUTILS package
---need cannedListCoMedia (#101, 3h)
    If we don't write this, everything fails.
---Remove ltype dependencies (#102, 3h)
---Update tests (#103, 3h)
