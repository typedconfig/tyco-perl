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

## Quick Start

Every binding ships the canonical sample configuration under `tyco/example.tyco`
([view on GitHub](https://github.com/typedconfig/tyco-perl/blob/main/tyco/example.tyco)).
Load it to mirror the Python README example:

```perl
use lib 'lib';
use Tyco;

my $config = Tyco::load_file('tyco/example.tyco');

my $environment = $config->{environment};
my $debug       = $config->{debug};
my $timeout     = $config->{timeout};
print "env=$environment debug=$debug timeout=$timeout\n";

my $primary_db = $config->{Database}[0];
printf "primary database -> %s:%d\n", $primary_db->{host}, $primary_db->{port};
```

### Example Tyco File

```
tyco/example.tyco
```

```tyco
# Global configuration with type annotations
str environment: production
bool debug: false
int timeout: 30

# Database configuration struct
Database:
 *str name:           # Primary key field (*)
  str host:
  int port:
  str connection_string:
  # Instances
  - primary, localhost,    5432, "postgresql://localhost:5432/myapp"
  - replica, replica-host, 5432, "postgresql://replica-host:5432/myapp"

# Server configuration struct  
Server:
 *str name:           # Primary key for referencing
  int port:
  str host:
  ?str description:   # Nullable field (?) - can be null
  # Server instances
  - web1,    8080, web1.example.com,    description: "Primary web server"
  - api1,    3000, api1.example.com,    description: null
  - worker1, 9000, worker1.example.com, description: "Worker number 1"

# Feature flags array
str[] features: [auth, analytics, caching]
```
