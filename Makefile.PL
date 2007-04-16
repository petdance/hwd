use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'App::HWD',
    AUTHOR              => 'Andy Lester <andy@petdance.com>',
    VERSION_FROM        => 'HWD.pm',
    ABSTRACT_FROM       => 'HWD.pm',
    PL_FILES            => {},
    EXE_FILES           => [ 'bin/hwd' ],
    PM => {
        'HWD.pm' => '$(INST_LIBDIR)/HWD.pm',
        'Task.pm' => '$(INST_LIBDIR)/HWD/Task.pm',
        'Work.pm' => '$(INST_LIBDIR)/HWD/Work.pm',
    },
    PREREQ_PM => {
        'Test::More' => 0,
        'Getopt::Long' => 0,
        'Pod::Usage' => 0,
    },
    MAN3PODS            => { }, # no need for docs on these
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'App-HWD-*' },
);

sub MY::postamble {
    return <<'MAKE_FRAG';
.PHONY: tags

tags:
	ctags -f tags --recurse --totals \
		--exclude=blib/ --exclude=t/lib \
		--exclude=.svn --exclude='*~' \
		--languages=Perl --langmap=Perl:+.t \
MAKE_FRAG
}
