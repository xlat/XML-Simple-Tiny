use 5.006;
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'XML::Simple::Tiny',
    AUTHOR              => q{Nicolas Georges <xlat@cpan.org>},
    VERSION_FROM        => 'lib/XML/Simple/Tiny.pm',
    ABSTRACT_FROM       => 'lib/XML/Simple/Tiny.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'XML::Tiny' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'XML-Simple-Tiny-*' },
);
