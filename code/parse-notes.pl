#!/usr/bin/env perl
use strict;
use warnings;

use Path::Tiny qw(path);

my $pod_file = shift || die "No pod file given\n";

my $file = path($pod_file);

my @lines = $file->lines;

print <<'HTML';
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <meta http-equiv="Content-type" content="text/html; charset=utf-8" />
  <title>Notes</title>
</head>
<body>
HTML

my $note_flag = 0;
my $i = 0;

for my $line (@lines) {
    chomp $line;
    if ($line =~ /^=head1 (.+)$/) {
        $i++;
        my $title = $1;
        print "<p><b>$i.</b> $title</p>\n";
    }
    elsif ($line =~ /^=begin note$/) {
        $note_flag++;
        print "<div style='opacity: 0.75; background-color: lightgray; font-size: larger;'>\n";
    }
    elsif ($line =~ /^=end note$/) {
        $note_flag = 0;
        print "</div>\n"
    }
    elsif ($note_flag && $line && $line !~ /^\.\.\./) {
#        print "$line\n";
        print "<p><b>$line</b></p>\n";
    }
}

print "\n", <<'HTML';
</body>
</html>
HTML
