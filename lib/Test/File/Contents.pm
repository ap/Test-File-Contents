package Test::File::Contents;

use warnings;
use strict;

=head1 NAME

Test::File::Contents - Test routines for examining the contents of files

=head1 VERSION

Version 0.03

=cut

use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);
$VERSION = '0.03';

use Exporter;                   # load the class
@ISA         = qw(Exporter);    # set it as the base class
@EXPORT      = qw(file_contents_is file_contents_isnt file_contents_like file_contents_unlike file_md5sum file_contents_identical);
@EXPORT_OK   = qw();            # no other optional functions
%EXPORT_TAGS = qw();            # no groups of functions

use Test::Builder;
use Digest::MD5;
use File::Spec;
my $Test = Test::Builder->new();

=head1 SYNOPSIS

    use Test::File::Contents;

    file_contents_is       ($file,  $string,  $test_description);
    file_contents_like     ($file,  qr/foo/,  $test_description);
    file_md5sum            ($file,  $md5sum,  $test_description);
    file_contents_identical($file1, $file2,   $test_description);


=head1 FUNCTIONS

=head2 file_contents_is

Checks for an exact match on the file's contents. Pass in a Unix-style file
name and it will be converted for the local file system.

Note: performs a dumb "eq" comparison, sucking the whole file into memory.

Also note: I am aware of the grammatical confusion in the function name
- got a better suggestion?

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

=head2 file_contents_isnt

Checks that the file's contents do not match a string. Pass in a Unix-style file
name and it will be converted for the local file system.

Note: performs a dumb "ne" comparison, sucking the whole file into memory.

Also note: I am aware of the grammatical confusion in the function name
- got a better suggestion?

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

=head2 file_contents_like

Checks for a regexp match against the file's contents. You must provide it
with a qr// style regexp. Pass in a Unix-style file name and it will be
converted for the local file system.


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

=head2 file_contents_unlike

Checks for a regexp failed match against the file's contents. You must provide
it with a qr// style regexp. Pass in a Unix-style file name and it will be
converted for the local file system.

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

=head2 file_md5sum

Checks whether a file matches a given md5sum. The md5sum should be provided as
a hex string, eg. "6df23dc03f9b54cc38a0fc1483df6e21". Pass in a Unix-style
file name and it will be converted for the local file system.

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

=head2 file_contents_identical

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

=head1 AUTHOR

Kirrily Robert, C<< <skud@cpan.org> >>

Contributors:

David Wheeler, C<< <dwheeler@cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-test-file-contents@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.  I will be notified, and then you'll automatically
be notified of progress on your bug as I make changes.

=head1 COPYRIGHT & LICENSE

Copyright 2004-2005 Kirrily Robert.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1; # End of Test::File::Contents
