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

my $timezone = $config->{timezone};
print "timezone=$timezone\n";

my $primary_app = $config->{Application}[0];
printf "primary service -> %s (%s)\n", $primary_app->{service}, $primary_app->{command};

my $backup_host = $config->{Host}[1];
printf "host %s cores=%d\n", $backup_host->{hostname}, $backup_host->{cores};
```

### Example Tyco File

```
tyco/example.tyco
```

```tyco
str timezone: UTC  # this is a global config setting

Application:       # schema defined first, followed by instance creation
  str service:
  str profile:
  str command: start_app {service}.{profile} -p {port.number}
  Host host:
  Port port: Port(http_web)  # reference to Port instance defined below
  - service: webserver, profile: primary, host: Host(prod-01-us)
  - service: webserver, profile: backup,  host: Host(prod-02-us)
  - service: database,  profile: mysql,   host: Host(prod-02-us), port: Port(http_mysql)

Host:
 *str hostname:  # star character (*) used as reference primary key
  int cores:
  bool hyperthreaded: true
  str os: Debian
  - prod-01-us, cores: 64, hyperthreaded: false
  - prod-02-us, cores: 32, os: Fedora

Port:
 *str name:
  int number:
  - http_web,   80  # can skip field keys when obvious
  - http_mysql, 3306
```
