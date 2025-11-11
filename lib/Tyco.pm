package Tyco;

use strict;
use warnings;
use JSON::PP qw(decode_json);
use XSLoader;

our $VERSION = '0.1.0';
XSLoader::load('Tyco', $VERSION);

sub load_file {
    my ($path) = @_;
    die "path is required" unless defined $path;
    my $json = _load_file_json($path);
    return decode_json($json);
}

sub load_string {
    my ($content, $name) = @_;
    die "content is required" unless defined $content;
    my $json = _load_string_json($content, $name // '<string>');
    return decode_json($json);
}

1;

__END__

=head1 NAME

Tyco - Perl binding for the Tyco configuration language

=head1 SYNOPSIS

  use Tyco;
  my $data = Tyco::load_file('../tyco-test-suite/inputs/simple1.tyco');

=head1 DESCRIPTION

Thin XS wrapper around the canonical Tyco parser (via libtyco_c).

=cut
