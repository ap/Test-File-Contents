package Test::File::Contents;

use warnings;
use strict;

=head1 Name

Test::File::Contents - Test routines for examining the contents of files

=cut

use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);
$VERSION = '0.10';

use Exporter;                   # load the class
@ISA         = qw(Exporter);    # set it as the base class
@EXPORT      = qw(file_contents_is file_contents_isnt file_contents_like file_contents_unlike file_md5sum file_contents_identical);
@EXPORT_OK   = qw();            # no other optional functions
%EXPORT_TAGS = qw();            # no groups of functions

use Test::Builder;
use Digest::MD5;
use File::Spec;
my $Test = Test::Builder->new();

=head1 Synopsis

    use Test::File::Contents;

  file_contents_is        $file,  $string,  $description;
  file_contents_like      $file,  qr/foo/,  $description;
  file_md5sum             $file,  $md5sum,  $description;
  file_contents_identical $file1, $file2,   $description;

=head1 Description

Got an app that generates files? Then you need to test those files to make
sure that their contents are correct. This module makes that easy. Use its
test functions to make sure that the contents of files are exactly what you
expect them to be.

=head1 Interface

=head2 Test Functions

=head3 file_contents_is

  file_contents_is $file, $string, $description;

Checks for an exact match on the file's contents. Pass in a Unix-style file
name and it will be converted for the local file system.

=cut

sub file_contents_is {
    my ($file, $string, $desc) = @_;
    return _compare(
        $file,
        sub { shift eq $string },
        $desc || 'file contents match string',
        "File $file does not match '$string'",
    );
}

=head3 file_contents_isnt

  file_contents_isnt $file, $string, $description;

Checks that the file's contents do not match a string. Pass in a Unix-style
file name and it will be converted for the local file system.

=cut

sub file_contents_isnt {
    my ($file, $string, $desc) = @_;
    return _compare(
        $file,
        sub { shift ne $string },
        $desc || 'file contents do not match string',
        "File $file matches '$string'",
    );
}

=head3 file_contents_like

  file_contents_like $file, qr/foo/, $description;

Checks that the contents of a file match a regular expression. The regular
expression must be passed as a regular expression object created by C<qr//>.

=cut

sub file_contents_like {
    my ($file, $regexp, $desc) = @_;
    return _compare(
        $file,
        sub { shift =~ /$regexp/ },
        $desc || 'file contents match regexp',
        "File $file does not match '$regexp'",
    );
}

=head3 file_contents_unlike

  file_contents_unlike $file, qr/foo/, $description;

Checks that the contents of a file I<do not> match a regular expression. The
regular expression must be passed as a regular expression object created by
C<qr//>.

=cut

sub file_contents_unlike {
    my ($file, $regexp, $desc) = @_;
    return _compare(
        $file,
        sub { shift !~ /$regexp/ },
        $desc || 'file contents do not match regexp',
        "File $file matches '$regexp'",
    );
}

=head3 file_md5sum

  file_md5sum $file,  $md5sum,  $description;

Checks whether a file matches a given md5 checksum. The md5sum should be
provided as a hex string, eg. "6df23dc03f9b54cc38a0fc1483df6e21". Pass in a
Unix-style file name and it will be converted for the local file system.

=cut

sub file_md5sum {
    my $file = $_[0] =~ m{/}
        ? File::Spec->catfile(split m{/}, shift)
        : shift;
    my ($md5sum, $desc) = @_;
    $desc ||= "file matches md5sum";
    local *IN;
    if (open IN, $file) {
        my $ctx = undef;
        $ctx = Digest::MD5->new;
        $ctx->addfile(*IN);
        my $result = $ctx->hexdigest;
        if ($result eq $md5sum) {
            $Test->ok(1, $desc);
            return 1;
        } else {
            $Test->diag("File $file has md5sum " . $result . " not $md5sum");
            $Test->ok(0, $desc);
            return 0;
        }
        close IN;
    } else {
        $Test->diag("Could not open file $file: $!");
        $Test->ok(0, $desc);
        return 0;
    }
}

=head3 file_contents_identical

  file_contents_identical $file1, $file2, $description;

Tests that the contents of two files are identical. Pass in a Unix-style file
name and it will be converted for the local file system.

=cut

sub file_contents_identical {
    my $file1 = $_[0] =~ m{/}
        ? File::Spec->catfile(split m{/}, shift)
        : shift;
    my $file2 = $_[0] =~ m{/}
        ? File::Spec->catfile(split m{/}, shift)
        : shift;
    my $desc = shift || 'file contents identical';

    my $ok;
    local(*IN1, *IN2);
    if (open IN1, $file1) {
        local $/ = undef;
        my $content1 = <IN1>;
        if (open IN2, $file2) {
            my $content2 = <IN2>;
            if ($content1 eq $content2) {
                $Test->ok(1, $desc);
                return 1;
            } else {
                $Test->diag("Files $file1 and $file2 are not identical.");
                $Test->ok(0, $desc);
                return 0;
            }
        } else {
            $Test->diag("Could not open file $file1: $!");
            $Test->ok(0, $desc);
            return 0;
        }
    } else {
        $Test->diag("Could not open file $file2: $!");
        $Test->ok(0, $desc);
        return 0;
    }
}

sub _compare {
    my $file = $_[0] =~ m{/}
        ? File::Spec->catfile(split m{/}, shift)
        : shift;
    my ($code, $desc, $err) = @_;
    my $ok;
    local $Test::Builder::Level = 2;
    local *IN;
    if (open IN, $file) {
        local $/ = undef;
        if ($code->(<IN>)) {
            $Test->ok(1, $desc);
            return 1;
        } else {
            $Test->diag($err);
            $Test->ok(0, $desc);
            return 0;
        }
    } else {
        $Test->diag("Could not open file $file: $!");
        $Test->ok(0, $desc);
        return 0;
    }
}

1;

=head1 Authors

=over

=item * Kirrily Robert <skud@cpan.org>

=item * David E. Wheeler <david@kineticode.com>

=back

=head1 Support

This module is stored in an open L<GitHub
repository|http://github.com/theory/test-file-contents/tree/>. Feel free to
fork and contribute!

Please file bug reports via L<GitHub
Issues|http://github.com/theory/test-file-contents/issues/> or by sending mail to
L<bug-Test-File-Contents@rt.cpan.org|mailto:bug-Test-File-Contents@rt.cpan.org>.

=head1 Copyright and License

Copyright (c) 2004-2007 Kirrily Robert. Some Rights Reserved.
Copyright (c) 2007-2011 David E. Wheeler. Some Rights Reserved.

This program is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.
