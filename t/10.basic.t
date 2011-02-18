#!/usr/bin/perl

use Test::More tests => 33;
use Test::Builder::Tester;

# turn on coloured diagnostic mode if you have a colour terminal.
# This is really useful as it lets you see even things you wouldn't
# normally see like extra spaces on the end of things.
use Test::Builder::Tester::Color;

# see if we can load the module okay
BEGIN { use_ok "Test::File::Contents" or die; }

# ===============================================================
# Tests for file_contents_eq
# ===============================================================

ok(defined(&file_contents_eq),       "function 'file_contents_eq' exported");

test_out("ok 1 - aaa test");
file_contents_eq("t/data/aaa.txt", "aaa\n", "aaa test");
test_test("file_contents_eq works when correct");

test_out("ok 1 - t/data/aaa.txt contents equal to string");
file_contents_eq("t/data/aaa.txt", "aaa\n");
test_test("works when correct with default text");

test_out("not ok 1 - t/data/aaa.txt contents equal to string");
test_fail(+2);
test_diag("    File t/data/aaa.txt contents not equal to 'bbb'");
file_contents_eq("t/data/aaa.txt", "bbb");
test_test("file_contents_eq works when incorrect");

# ===============================================================
# Tests for file_contents_ne
# ===============================================================

ok(defined(&file_contents_ne),     "function 'file_contents_ne' exported");

test_out("ok 1 - bbb test");
file_contents_ne("t/data/aaa.txt", "bbb\n", "bbb test");
test_test("file_contents_ne works when incorrect"); # XXX Ugh.

test_out("ok 1 - t/data/aaa.txt contents not equal to string");
file_contents_ne("t/data/aaa.txt", "bbb\n");
test_test("works when incorrect with default text");

test_out("not ok 1 - t/data/aaa.txt contents not equal to string");
test_fail(+2);
test_diag("    File t/data/aaa.txt contents equal to 'aaa\n# '");
file_contents_ne("t/data/aaa.txt", "aaa\n");
test_test("file_contents_ne works when correct");

# ===============================================================
# Tests for file_contents_is
# ===============================================================

ok(defined(&file_contents_is),       "function 'file_contents_is' exported");

test_out("ok 1 - aaa test");
file_contents_is("t/data/aaa.txt", "aaa\n", "aaa test");
test_test("file_contents_is works when correct");

test_out("ok 1 - t/data/aaa.txt contents equal to string");
file_contents_is("t/data/aaa.txt", "aaa\n");
test_test("works when correct with default text");

test_out("not ok 1 - t/data/aaa.txt contents equal to string");
test_fail(+2);
test_diag("    File t/data/aaa.txt contents not equal to 'bbb'");
file_contents_is("t/data/aaa.txt", "bbb");
test_test("file_contents_is works when incorrect");

# ===============================================================
# Tests for file_contents_isnt
# ===============================================================

ok(defined(&file_contents_isnt),     "function 'file_contents_isnt' exported");

test_out("ok 1 - bbb test");
file_contents_isnt("t/data/aaa.txt", "bbb\n", "bbb test");
test_test("file_contents_isnt works when incorrect"); # XXX Ugh.

test_out("ok 1 - t/data/aaa.txt contents not equal to string");
file_contents_isnt("t/data/aaa.txt", "bbb\n");
test_test("works when incorrect with default text");

test_out("not ok 1 - t/data/aaa.txt contents not equal to string");
test_fail(+2);
test_diag("    File t/data/aaa.txt contents equal to 'aaa\n# '");
file_contents_isnt("t/data/aaa.txt", "aaa\n");
test_test("file_contents_isnt works when correct");

# ===============================================================
# Tests for file_contents_like
# ===============================================================

ok(defined(&file_contents_like),    "function 'file_contents_like' exported");
test_out("ok 1 - aaa regexp test");
file_contents_like("t/data/aaa.txt", qr/[abc]/, "aaa regexp test");
test_test("works when correct");

test_out("ok 1 - t/data/aaa.txt contents match regex");
file_contents_like("t/data/aaa.txt", qr/[abc]/);
test_test("works when correct with default text");

test_out("not ok 1 - t/data/aaa.txt contents match regex");
my $regexp = qr/[xyz]/;
test_fail(+2);
test_diag("    File t/data/aaa.txt contents do not match /$regexp/");
file_contents_like("t/data/aaa.txt", $regexp);
test_test("works when incorrect");

# ===============================================================
# Tests for file_contents_unlike
# ===============================================================

ok(defined(&file_contents_unlike),  "function 'file_contents_unlike' exported");
test_out("ok 1 - xyz regexp test");
file_contents_unlike("t/data/aaa.txt", qr/[xyz]/, "xyz regexp test");
test_test("works when incorrect");

test_out("ok 1 - t/data/aaa.txt contents do not match regex");
file_contents_unlike("t/data/aaa.txt", qr/[xyz]/);
test_test("works when incorrect with default text");

test_out("not ok 1 - t/data/aaa.txt contents do not match regex");
$regexp = qr/[abc]/;
test_fail(+2);
test_diag("    File t/data/aaa.txt contents match /$regexp/");
file_contents_unlike("t/data/aaa.txt", $regexp);
test_test("works when correct");

# ===============================================================
# Tests for file_md5sum
# ===============================================================

# md5sum for t/data/aaa.txt is 5c9597f3c8245907ea71a89d9d39d08e

ok(defined(&file_md5sum),"function 'file_md5sum' exported");

test_out("ok 1 - aaa md5sum test");
file_md5sum("t/data/aaa.txt", "5c9597f3c8245907ea71a89d9d39d08e", "aaa md5sum test");
test_test("file_md5sum works when correct");

test_out("ok 1 - t/data/aaa.txt has md5sum");
file_md5sum("t/data/aaa.txt", "5c9597f3c8245907ea71a89d9d39d08e");
test_test("file_md5sum works when correct with default text");

test_out("not ok 1 - t/data/aaa.txt has md5sum");
test_fail(+2);
test_diag("    File t/data/aaa.txt has md5sum 5c9597f3c8245907ea71a89d9d39d08e, not 0123456789abcdef0123456789abcdef");
file_md5sum("t/data/aaa.txt", "0123456789abcdef0123456789abcdef");
test_test("file_md5sum works when incorrect");

# ===============================================================
# Tests for file_contents_identical
# ===============================================================

ok(defined(&file_contents_identical),"function 'file_contents_identical' exported");

test_out("ok 1 - aaa identical test");
file_contents_identical("t/data/aaa.txt", "t/data/aaa2.txt", "aaa identical test");
test_test("file_contents_identical works when correct");

test_out("ok 1 - t/data/aaa.txt and t/data/aaa2.txt contents identical");
file_contents_identical("t/data/aaa.txt", "t/data/aaa2.txt");
test_test("file_contents_identical works when correct with default text");

test_out("not ok 1 - t/data/aaa.txt and t/data/bbb.txt contents identical");
test_fail(+2);
test_diag("    Files t/data/aaa.txt and t/data/bbb.txt are not identical.");
file_contents_identical("t/data/aaa.txt", "t/data/bbb.txt");
test_test("file_contents_identical works when incorrect");
