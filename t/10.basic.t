#!/usr/bin/perl

use Test::More tests => 17;
use Test::Builder::Tester;

# turn on coloured diagnostic mode if you have a colour terminal.
# This is really useful as it lets you see even things you wouldn't
# normally see like extra spaces on the end of things.
use Test::Builder::Tester::Color;

# see if we can load the module okay
BEGIN { use_ok "Test::File::Contents" }

# ===============================================================
# Tests for file_contents_is
# ===============================================================

ok(defined(&file_contents_is),       "function 'file_contents_is' exported");

test_out("ok 1 - aaa test");
file_contents_is("t/aaa.txt", "aaa\n", "aaa test");
test_test("file_contents_is works when correct");

test_out("ok 1 - file contents match string");
file_contents_is("t/aaa.txt", "aaa\n");
test_test("works when correct with default text");

test_out("not ok 1 - file contents match string");
test_diag("File t/aaa.txt does not match string provided");
test_fail(+1);
file_contents_is("t/aaa.txt", "bbb");
test_test("file_contents_is works when incorrect");


# ===============================================================
# Tests for file_contents_like
# ===============================================================

ok(defined(&file_contents_like),    "function 'file_contents_like' exported");
test_out("ok 1 - aaa regexp test");
file_contents_like("t/aaa.txt", qr/[abc]/, "aaa regexp test");
test_test("works when correct");

test_out("ok 1 - file contents match regexp");
file_contents_like("t/aaa.txt", qr/[abc]/);
test_test("works when correct with default text");

test_out("not ok 1 - file contents match regexp");
test_diag("File t/aaa.txt does not match regexp provided");
test_fail(+1);
file_contents_like("t/aaa.txt", qr/[xyz]/);
test_test("works when incorrect");

# ===============================================================
# Tests for file_md5sum
# ===============================================================

# md5sum for t/aaa.txt is 5c9597f3c8245907ea71a89d9d39d08e

ok(defined(&file_md5sum),"function 'file_md5sum' exported");

test_out("ok 1 - aaa md5sum test");
file_md5sum("t/aaa.txt", "5c9597f3c8245907ea71a89d9d39d08e", "aaa md5sum test");
test_test("file_md5sum works when correct");

test_out("ok 1 - file matches md5sum");
file_md5sum("t/aaa.txt", "5c9597f3c8245907ea71a89d9d39d08e");
test_test("file_md5sum works when correct with default text");

test_out("not ok 1 - file matches md5sum");
test_diag("File t/aaa.txt has md5sum 5c9597f3c8245907ea71a89d9d39d08e not 0123456789abcdef0123456789abcdef");
test_fail(+1);
file_md5sum("t/aaa.txt", "0123456789abcdef0123456789abcdef");
test_test("file_md5sum works when incorrect");

# ===============================================================
# Tests for file_contents_identical
# ===============================================================

ok(defined(&file_contents_identical),"function 'file_contents_identical' exported");

test_out("ok 1 - aaa identical test");
file_contents_identical("t/aaa.txt", "t/aaa2.txt", "aaa identical test");
test_test("file_contents_identical works when correct");

test_out("ok 1 - file contents identical");
file_contents_identical("t/aaa.txt", "t/aaa2.txt");
test_test("file_contents_identical works when correct with default text");

test_out("not ok 1 - file contents identical");
test_diag("Files t/aaa.txt and t/bbb.txt are not identical.");
test_fail(+1);
file_contents_identical("t/aaa.txt", "t/bbb.txt");
test_test("file_contents_identical works when incorrect");

