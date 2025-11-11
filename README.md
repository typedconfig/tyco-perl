## Tyco Perl Binding

XS wrapper around `libtyco_c` that exposes `Tyco::load_file` and `Tyco::load_string`. The module
parses Tyco documents and returns native Perl data structures (decoded from the canonical JSON).

### Prerequisites

1. Build the shared C library:
   ```bash
   cd ../tyco-c
   cmake -S . -B build
   cmake --build build
   ```
2. Ensure `LD_LIBRARY_PATH` contains `../tyco-c/build` when running the Perl module/tests.

### Build & Test

```bash
cd tyco-perl
perl Makefile.PL
make
LD_LIBRARY_PATH=../tyco-c/build:$LD_LIBRARY_PATH make test
```

### Usage

```perl
use lib 'lib';
use Tyco;

my $data = Tyco::load_file('../tyco-test-suite/inputs/simple1.tyco');
print $data->{project}; # "demo"
```
