Test::File::Contents
====================

Perl test routines for examining the contents of files

[![CPAN version](https://badge.fury.io/pl/Test-File-Contents.svg)](http://badge.fury.io/pl/Test-File-Contents)
[![Build Status](https://travis-ci.org/theory/test-file-contents.svg)](https://travis-ci.org/theory/sqitch)

Synopsis
--------
    use Test::File::Contents;

    file_contents_eq         $file,  $string,  $description;
    file_contents_eq_or_diff $file,  $string,  $description;
    file_contents_like       $file,  qr/foo/,  $description;
    file_md5sum_is           $file,  $md5sum,  $description;
    files_eq                 $file1, $file2,   $description;
    files_eq_or_diff         $file1, $file2,   $description;

Description
-----------

Got an app that generates files? Then you need to test those files to make
sure that their contents are correct. This module makes that easy. Use its
test functions to make sure that the contents of files are exactly what you
expect them to be.

Interface
---------

### Options ###

These test functions take an optional hash reference of options which may
include one or more of these options:

=over

*   `encoding`

    The encoding in which the file is encoded. This will be used in an I/O
    layer to read in the file, so that it can be properly decoded to Perl's
    internal representation. Examples include `UTF-8`, `iso-8859-3`, and
    `cp1252`. See L<Encode::Supported> for a list of supported encodings. May
    also be specified as a layer, such as ":utf8" or ":raw". See
    [perlio](http://perldoc.perl.org/PerlIO.html) for a complete list of
    layers.

    Note that it's important to specify the encoding if you have non-ASCII
    characters in your file. And the value to be compared against (the string
    argument to `file_contents_eq()` and the regular expression argument to
    `file_contents_like()`, for example, must be decoded to Perl's internal
    form. The simplest way to do so use to put

        use utf8;

    In your test file and write it all in `UTF-8`. For example:

        use utf8;
        use Test::More tests => 1;
        use Test::File::Contents;
    
        file_contents_eq('utf8.txt',   'ååå', { encoding => 'UTF-8' });
        file_contents_eq('latin1.txt', 'ååå', { encoding => 'UTF-8' });

*   `style`

    The style of diff to output in the diagnostics in the case of a failure
    in `file_contents_eq_or_diff`. The possible values are:

    *   Unified
    *   Context
    *   OldStyle
    *   Table

* `context`

    Determines the amount of context displayed in diagnostic diff output. If
    you need to seem more of the area surrounding different lines, pass this
    option to determine how many more links you'd like to see.

### Test Functions ###

### `file_contents_eq` ###

    file_contents_eq $file, $string, $description;
    file_contents_eq $file, $string, { encoding => 'UTF-8' };
    file_contents_eq $file, $string, { encoding => ':bytes' }, $description;

Checks that the file's contents are equal to a string. Pass in a Unix-style
file name and it will be converted for the local file system. Supported
[options](#Options):

* `encoding`

The old name for this function, `file_contents_is`, remains as an alias.

### `file_contents_eq_or_diff` ###

    file_contents_eq_or_diff $file, $string, $description;
    file_contents_eq_or_diff $file, $string, { encoding => 'UTF-8' };
    file_contents_eq_or_diff $file, $string, { style    => 'context' }, $description;

Like `file_contents_eq()`, only in the event of failure, the diagnostics will
contain a diff instead of the full contents of the file. This can make it
easier to test the contents of very large text files, and where only a subset
of the lines are different. Supported [options](#Options):

* `encoding`
* `style`
* `context`

### `file_contents_ne` ###

    file_contents_ne $file, $string, $description;
    file_contents_ne $file, $string, { encoding => 'UTF-8' };
    file_contents_ne $file, $string, { encoding => ':bytes' }, $description;

Checks that the file's contents do not equal a string. Pass in a Unix-style
file name and it will be converted for the local file system. Supported
[options](#Options):

* `encoding`

The old name for this function, `file_contents_isnt`, remains as an alias.

### `file_contents_like` ###

    file_contents_like $file, qr/foo/, $description;
    file_contents_like $file, qr/foo/, { encoding => 'UTF-8' };
    file_contents_like $file, qr/foo/, { encoding => ':bytes' }, $description;

Checks that the contents of a file match a regular expression. The regular
expression must be passed as a regular expression object created by `qr//`.
Supported [options](#Options):

* `encoding`

### `file_contents_unlike` ###

    file_contents_unlike $file, qr/foo/, $description;
    file_contents_unlike $file, qr/foo/, { encoding => 'UTF-8' };
    file_contents_unlike $file, qr/foo/, { encoding => ':bytes' }, $description;

Checks that the contents of a file I<do not> match a regular expression. The
regular expression must be passed as a regular expression object created by
`qr//`. Supported [options](#Options):

* `encoding`

### `file_md5sum_is` ###

    file_md5sum_is $file, $md5sum, $description;
    file_md5sum_is $file, $md5sum, { encoding => 'UTF-8' };
    file_md5sum_is $file, $md5sum, { encoding => ':bytes' }, $description;

Checks whether a file matches a given MD5 checksum. The checksum should be
provided as a hex string, for example, `6df23dc03f9b54cc38a0fc1483df6e21`.
Pass in a Unix-style file name and it will be converted for the local file
system. Supported [options](#Options):

* `encoding`

Probably not useful unless left unset or set to `:raw`.

The old name for this function, `file_md5sum`, remains as an alias.

### `files_eq` ###

    files_eq $file1, $file2, $description;
    files_eq $file1, $file2, { encoding => 'UTF-8' };
    files_eq $file1, $file2, { encoding => ':bytes' }, $description;

Tests that the contents of two files are the same. Pass in a Unix-style file
name and it will be converted for the local file system. Supported
[options](#Options):

* `encoding`

The old name for this function, `file_contents_identical`, remains as an
alias.

### `files_eq_or_diff` ###

    files_eq_or_diff $file1, $file2, $description;
    files_eq_or_diff $file1, $file2, { encoding => 'UTF-8' };
    files_eq_or_diff $file1, $file2, { style    => 'context' }, $description;

Like `files_eq()`, this function tests that the contents of two files are the
same. Unlike `files_eq()`, on failure this function outputs a diff of the two
files in the diagnostics. Supported [options](#Options):

* `encoding`
* `style`
* `context`

Authors
-------

* [Kirrily Robert](/skud)
* [David E. Wheeler](/theory)

Copyright and License
---------------------

Copyright (c) 2004-2007 Kirrily Robert. Some Rights Reserved.
Copyright (c) 2007-2016 David E. Wheeler. Some Rights Reserved.

This program is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.
