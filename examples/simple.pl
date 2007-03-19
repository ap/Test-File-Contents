#!/usr/bin/perl

use strict;
use warnings;

use Test::More qw(no_plan);
use Test::File::Contents;

# The following code won't actually run; it's just an example of the
# sorts of things you might use this module for.

my $logfile = "t/log/myapp.log";
use MyApp;
my $x = MyApp->new( logfile => $logfile );
MyApp->create( name => "new thing", options => \%options );
file_contents_like($logfile, qr/created new thing/, "logged object creation");

# Another example that won't run.

use MyTemplate;
my $template = MyTemplate->new("t/template.txt");
$template->parse();
my $outfile = "t/template_output.txt";
$template->output_to_file($outfile);
file_contents_unlike($outfile, qr/error/i, "No errors");
file_contents_like($outfile, qr/2 + 2 = 4/, "Simple expressions");

