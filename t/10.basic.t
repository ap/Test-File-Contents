#!/usr/bin/env perl -w

use Test::More tests => 60;
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

# With encoding.
UTF8: {
    use utf8;
    test_out("ok 1 - t/data/utf8.txt contents equal to string");
    file_contents_eq('t/data/utf8.txt', 'ååå', { encoding => 'UTF-8' });
    test_test("file_contents_eq works with UTF-8 encoding");
}

# Should fail if our string isn't decoded.
test_out("not ok 1 - t/data/utf8.txt contents equal to string");
test_fail(+2);
test_diag("    File t/data/utf8.txt contents not equal to 'ååå'");
file_contents_eq('t/data/utf8.txt', 'ååå', { encoding => 'UTF-8' });
test_test("file_contents_eq fails with encoded arg string");

UTF8: {
    # Should fail if the encoding is wrong.
    use utf8;
    test_out("not ok 1 - t/data/utf8.txt contents equal to string");
    test_fail(+2);
    test_diag("    File t/data/utf8.txt contents not equal to 'ååå'");
    file_contents_eq('t/data/utf8.txt', 'ååå', { encoding => 'Big5' });
    test_test("file_contents_eq works with Big5 encoding");
}

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

# With encoding.
UTF8: {
    use utf8;
    test_out("ok 1 - t/data/utf8.txt contents not equal to string");
    file_contents_ne('t/data/utf8.txt', 'ååå', { encoding => ':raw' });
    test_test("file_contents_ne works with :raw encoding");

    # Should fail if our string is decoded.
    test_out("not ok 1 - t/data/utf8.txt contents not equal to string");
    test_fail(+2);
    test_diag("    File t/data/utf8.txt contents equal to 'ååå'");
    file_contents_ne('t/data/utf8.txt', 'ååå', { encoding => 'UTF-8' });
    test_test("file_contents_ne fails with encoded arg string");

    # Should pass if the encoding is wrong.
    test_out("ok 1 - t/data/utf8.txt contents not equal to string");
    file_contents_ne('t/data/utf8.txt', 'ååå', { encoding => 'Big5' });
    test_test("file_contents_ne works with Big5 encoding");
}

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

# With encoding.
UTF8: {
    use utf8;
    test_out("ok 1 - t/data/utf8.txt contents match regex");
    file_contents_like('t/data/utf8.txt', qr/å/, { encoding => 'UTF-8' });
    test_test("file_contents_like works with UTF-8 encoding");
}

# Should fail if our string isn't decoded.
$regexp = qr/å/;
test_out("not ok 1 - t/data/utf8.txt contents match regex");
test_fail(+2);
test_diag("    File t/data/utf8.txt contents do not match /$regexp/");
file_contents_like('t/data/utf8.txt', $regexp, { encoding => 'UTF-8' });
test_test("file_contents_like fails with encoded arg string");

UTF8: {
    # Should fail if the encoding is wrong.
    use utf8;
    $regexp = qr/å/;
    test_out("not ok 1 - t/data/utf8.txt contents match regex");
    test_fail(+2);
    test_diag("    File t/data/utf8.txt contents do not match /$regexp/");
    file_contents_like('t/data/utf8.txt', $regexp, { encoding => 'Big5' });
    test_test("file_contents_like works with Big5 encoding");
}

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

# With encoding.
UTF8: {
    use utf8;
    my $regexp = qr/å/;
    test_out("ok 1 - t/data/utf8.txt contents do not match regex");
    file_contents_unlike('t/data/utf8.txt', $regexp, { encoding => ':raw' });
    test_test("file_contents_unlike works with :raw encoding");

    # Should fail if our string is decoded.
    test_out("not ok 1 - t/data/utf8.txt contents do not match regex");
    test_fail(+2);
    test_diag("    File t/data/utf8.txt contents match /$regexp/");
    file_contents_unlike('t/data/utf8.txt', $regexp, { encoding => 'UTF-8' });
    test_test("file_contents_unlike fails with encoded arg string");

    # Should pass if the encoding is wrong.
    test_out("ok 1 - t/data/utf8.txt contents do not match regex");
    file_contents_unlike('t/data/utf8.txt', $regexp, { encoding => 'Big5' });
    test_test("file_contents_unlike works with Big5 encoding");
}

# ===============================================================
# Tests for file_md5sum_is_is
# ===============================================================

# md5sum for t/data/aaa.txt is 5c9597f3c8245907ea71a89d9d39d08e

ok(defined(&file_md5sum_is),"function 'file_md5sum_is' exported");

test_out("ok 1 - aaa md5sum test");
file_md5sum_is("t/data/aaa.txt", "5c9597f3c8245907ea71a89d9d39d08e", "aaa md5sum test");
test_test("file_md5sum_is works when correct");

test_out("ok 1 - t/data/aaa.txt has md5sum");
file_md5sum_is("t/data/aaa.txt", "5c9597f3c8245907ea71a89d9d39d08e");
test_test("file_md5sum_is works when correct with default text");

test_out("not ok 1 - t/data/aaa.txt has md5sum");
test_fail(+2);
test_diag("    File t/data/aaa.txt does not have md5 checksum 0123456789abcdef0123456789abcdef");
file_md5sum_is("t/data/aaa.txt", "0123456789abcdef0123456789abcdef");
test_test("file_md5sum_is works when incorrect");

# Try encoded file.
test_out("ok 1 - utf8 md5sum test");
file_md5sum_is("t/data/utf8.txt", "24bbe7a3423595c452c689e2b62f4b04", "utf8 md5sum test");
test_test("file_md5sum_is works on utf8 file");

test_out("ok 1 - utf8 md5sum test");
file_md5sum_is("t/data/utf8.txt", "24bbe7a3423595c452c689e2b62f4b04", "utf8 md5sum test", {
    encoding => ':raw',
});
test_test("file_md5sum_is works on raw utf8 file");

# Try encoded file with encoding.
test_out("not ok 1 - utf8 md5sum test");
test_fail(+2);
test_diag("    File t/data/utf8.txt does not have md5 checksum 24bbe7a3423595c452c689e2b62f4b04");
file_md5sum_is("t/data/utf8.txt", "24bbe7a3423595c452c689e2b62f4b04", "utf8 md5sum test", {
    encoding => 'UTF-8',
});
test_test("file_md5sum_is fails on decoded utf8 file");

is \&file_md5sum, \&file_md5sum, 'Function file_md5sum should alias to file_md5sum_is';

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

# With encoding.
test_out("ok 1 - whatever");
file_contents_identical('t/data/utf8.txt', 't/data/utf8-2.txt', { encoding => 'UTF-8' }, 'whatever');
test_test("file_contents_identical works with UTF-8 decoding");

test_out("ok 1 - t/data/utf8.txt and t/data/utf8-2.txt contents identical");
file_contents_identical('t/data/utf8.txt', 't/data/utf8-2.txt');
test_test("file_contents_identical works without UTF-8 decoding");

test_out("ok 1 - whatever");
file_contents_identical('t/data/utf8.txt', 't/data/utf8-2.txt', 'whatever', { encoding => 'Big5' });
test_test("file_contents_identical works with Big5 decoding");

test_out("ok 1 - t/data/utf8.txt and t/data/utf8-2.txt contents identical");
file_contents_identical('t/data/utf8.txt', 't/data/utf8-2.txt', { encoding => ':raw' });
test_test("file_contents_identical works with :raw decoding");

# ===============================================================
# Tests for file_contents_eq_or_diff
# ===============================================================

ok(defined(&file_contents_eq_or_diff),"function 'file_contents_eq_or_diff' exported");
test_out("ok 1 - aaa test");
file_contents_eq_or_diff("t/data/aaa.txt", "aaa\n", "aaa test");
test_test("file_contents_eq_or_diff works when correct");

test_out("ok 1 - t/data/aaa.txt contents equal to string");
file_contents_eq_or_diff("t/data/aaa.txt", "aaa\n");
test_test("works when correct with default description");

test_out("not ok 1 - t/data/aaa.txt contents equal to string");
test_fail(+8);
test_diag(
    '--- t/data/aaa.txt',
    '+++ Want',
    '@@ -1 +1 @@',
    '-aaa',
    '+bbb',
);
file_contents_eq_or_diff("t/data/aaa.txt", "bbb");
test_test("file_contents_eq_or_diff works when incorrect");

# Try different diff style.
test_out("not ok 1 - t/data/aaa.txt contents equal to string");
test_fail(+10);
test_diag(
    '*** t/data/aaa.txt',
    '--- Want',
    '***************',
    '*** 1 ****',
    '! aaa',
    '--- 1 ----',
    '! bbb',
);
file_contents_eq_or_diff("t/data/aaa.txt", "bbb", { style => 'Context' });
test_test("file_contents_eq_or_diff diagnostics use context");

# Try an encoded file.
UTF8: {
    use utf8;
    test_out("ok 1 - t/data/utf8.txt contents equal to string");
    file_contents_eq_or_diff('t/data/utf8.txt', 'ååå', { encoding => 'UTF-8' });
    test_test("file_contents_eq_or_diff works with UTF-8 encoding");

    # Should fail if the encoding is wrong.
    test_out("not ok 1 - t/data/utf8.txt contents equal to string");
    test_fail(+7);
    test_diag(
        '--- t/data/utf8.txt',
        '+++ Want',
        '@@ -1 +1 @@',
        '-疇疇疇+ååå',
    );
    file_contents_eq_or_diff('t/data/utf8.txt', 'ååå', { encoding => 'Big5' });
    test_test("file_contents_eq works with Big5 encoding");
}
