use ExtUtils::MakeMaker;

WriteMakefile(
    NAME         => 'Tyco',
    VERSION      => '0.1.0',
    LIBS         => ['-L../tyco-c/build -ltyco_c'],
    INC          => '-I../tyco-c/include',
    PREREQ_PM    => { 'JSON::PP' => 0 },
    XS           => { 'Tyco.xs' => 'Tyco.c' },
    clean        => { FILES => 'Tyco.c Tyco.bs' },
);
