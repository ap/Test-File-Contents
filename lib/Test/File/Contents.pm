package Test::File::Contents;

use warnings;
use strict;

=head1 NAME

Test::File::Contents - Test routines for examining the contents of files

=head1 Version

Version 0.02

=cut

use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);
$VERSION = '0.02';

use Exporter;                   # load the class
@ISA         = qw(Exporter);    # set it as the base class
@EXPORT      = qw(file_contents_is file_contents_like file_md5sum file_contents_identical);
@EXPORT_OK   = qw();            # no other optional functions
%EXPORT_TAGS = qw();            # no groups of functions

use Test::Builder;
use Digest::MD5;
my $Test = Test::Builder->new();

=head1 Synopsis

    use Test::File::Contents;

    file_contents_is       ($file,  $string,  $test_description);
    file_contents_like     ($file,  qr/foo/,  $test_description);
    file_md5sum            ($file,  $md5sum,  $test_description);
    file_contents_identical($file1, $file2,   $test_description);


=head1 Functions

=head2 file_contents_is

Checks for an exact match on the file's contents.  

Note: performs a dumb "eq" comparison, sucking the whole file into memory.

Also note: I am aware of the grammatical confusion in the function name
- got a better suggestion?

=for testing


=cut

sub file_contents_is {
    my ($file, $string, $desc) = @_;
    $desc ||= "file contents match string";

    my $ok;
    if (open IN, $file) {
        local $/ = undef;
        my $content = <IN>;
        if ($content eq $string) {
            $Test->ok(1, $desc);
            return 1;
        } else {
            $Test->diag("File $file does not match string provided");
            $Test->ok(0, $desc);
            return 0;
        }
    } else {
        $Test->diag("Could not open file $file: $!");
        $Test->ok(0, $desc);
        return 0;
    }
}

=head2 file_contents_like

Checks for a regexp match against the file's contents.  You must provide
it with a qr// style regexp.

=cut

sub file_contents_like {
    my ($file, $regexp, $desc) = @_;
    $desc ||= "file contents match regexp";

    my $ok;
    if (open IN, $file) {
        local $/ = undef;
        my $content = <IN>;
        if ($content =~ /$regexp/) {
            $Test->ok(1, $desc);
            return 1;
        } else {
            $Test->diag("File $file does not match regexp provided");
            $Test->ok(0, $desc);
            return 0;
        }
    } else {
        $Test->diag("Could not open file $file: $!");
        $Test->ok(0, $desc);
        return 0;
    }
}

=head2 file_md5sum

Checks whether a file matches a given md5sum.  The md5sum should be
provided as a hex string, eg. "6df23dc03f9b54cc38a0fc1483df6e21".

=cut

sub file_md5sum {
    my ($file, $md5sum, $desc) = @_;
    $desc ||= "file matches md5sum";
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

Tests that the contents of two files are identical.

=cut

sub file_contents_identical {
    my ($file1, $file2, $desc) = @_;
    $desc ||= "file contents identical";

    my $ok;
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

=head1 Author

Kirrily Robert, C<< <skud@cpan.org> >>

=head1 Bugs

Please report any bugs or feature requests to
C<bug-test-file-contents@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.  I will be notified, and then you'll automatically
be notified of progress on your bug as I make changes.

=head1 Copyright & License

Copyright 2004 Kirrily Robert, All Rights Reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1; # End of Test::File::Contents
