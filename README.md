Test/File/Contents 0.10
=======================

This library's module, Test::File::Contents, provides an interface for testing
file contents. Usage is quite simple:

    file_contents_eq $file, $contents, $description;
    file_contents_like $file, qr/contents/, $description;
    file_md5_sum $file, $md5hash, $description;

INSTALLATION

To install this module, type the following:

    perl Build.PL
    ./Build
    ./Build test
    ./Build install

Or, if you don't have Module::Build installed, type the following:

    perl Makefile.PL
    make
    make test
    make install

Dependencies
------------

Test::File::Contents requires the following modules:

* Test::Builder
* Digset::MD5
* File::Spec

Copyright and Licence
---------------------

Copyright (c) 2004-2007 Kirrily Robert. Some Rights Reserved.
Copyright (c) 2007-2011 David E. Wheeler. Some Rights Reserved.

This module is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.
