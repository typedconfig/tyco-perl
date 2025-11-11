use strict;
use warnings;
use JSON::PP qw(decode_json);
use File::Basename qw(basename);
use File::Spec;

BEGIN {
    my $lib_path = File::Spec->rel2abs(File::Spec->catdir('..', 'tyco-c', 'build'));
    $ENV{LD_LIBRARY_PATH} = defined $ENV{LD_LIBRARY_PATH}
        ? "$lib_path:$ENV{LD_LIBRARY_PATH}"
        : $lib_path;
}

use lib 'lib';
use Tyco;

my $suite_root = File::Spec->rel2abs(File::Spec->catdir('..', 'tyco-test-suite'));
my $inputs_dir = File::Spec->catdir($suite_root, 'inputs');
my $expected_dir = File::Spec->catdir($suite_root, 'expected');

opendir(my $dh, $inputs_dir) or die "Cannot open $inputs_dir: $!";
my @files = sort grep { /\.tyco$/ && -f File::Spec->catfile($inputs_dir, $_) } readdir($dh);
closedir($dh);

my $total = 0;
my @cases;
foreach my $file (@files) {
    my $input_path = File::Spec->catfile($inputs_dir, $file);
    my $expected_path = File::Spec->catfile($expected_dir, basename($file, '.tyco') . '.json');
    next unless -e $expected_path;
    push @cases, [$file, $input_path, $expected_path];
    $total++;
}

print "1..$total\n";

my $test_num = 1;
my $failed = 0;
for my $case (@cases) {
    my ($label, $input_path, $expected_path) = @$case;
    eval {
        my $actual = Tyco::load_file($input_path);
        my $expected_json = read_file($expected_path);
        my $expected = decode_json($expected_json);
        if (_hash_equal($actual, $expected)) {
            print "ok $test_num - $label\n";
        } else {
            print "not ok $test_num - $label\n";
            $failed = 1;
        }
        1;
    } or do {
        my $err = $@ || 'unknown error';
        print "not ok $test_num - $label # $err\n";
        $failed = 1;
    };
    $test_num++;
}

exit $failed ? 1 : 0;

sub read_file {
    my ($path) = @_;
    open my $fh, '<', $path or die "Cannot open $path: $!";
    local $/;
    my $content = <$fh>;
    close $fh;
    return $content;
}

sub _hash_equal {
    my ($a, $b) = @_;
    return JSON::PP->new->canonical->encode($a) eq JSON::PP->new->canonical->encode($b);
}
