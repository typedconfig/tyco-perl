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

# Parse a Tyco configuration file
my $context = Tyco::load_file('config.tyco');

# Access global configuration values
my $globals = $context->{globals};
my $environment = $globals->{environment};
my $debug = $globals->{debug};
my $timeout = $globals->{timeout};

# Get all instances as hashes
my $objects = $context->{objects};
my $databases = $objects->{Database}; # Arrayref of Database instances
my $servers = $objects->{Server};     # Arrayref of Server instances

# Access individual instance fields
my $primary_db = $databases->[0];
my $db_host = $primary_db->{host};
my $db_port = $primary_db->{port};
```
