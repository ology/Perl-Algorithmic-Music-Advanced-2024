#!/usr/bin/env perl
use strict;
use warnings;

use lib map { "$ENV{HOME}/sandbox/$_/lib" } qw(MIDI-Util); # n.b. local author libs. comment this out unless you're me
use MIDI::RtMidi::FFI::Device ();
use MIDI::Util qw(setup_score score2events get_milliseconds);
use Time::HiRes qw(usleep);

my $phrase = 'C5,sn G4,en F4,qn C5,sn G4,en F4,qn C4,wn';

my $score = setup_score(
    lead_in => 0,
    bpm     => 100,
);

# add notes to the score
my @notes = split /\s+/, $phrase;
for my $note (@notes) {
    my ($pitch, $duration) = split /,/, $note;
    $score->n($duration, $pitch);
}

my $millis = get_milliseconds($score);
my $events = score2events($score);

# fire up RT-MIDI!
my $device = RtMidiOut->new;
$device->open_virtual_port('perl-rtmidi');
$device->open_port_by_name('Logic Pro Virtual In');

# send the events to the open port
for my $event (@$events) {
    my $name = $event->[0];
    if ($name =~ /^note_\w+$/) {
        my $useconds = $millis * $event->[1];
        usleep($useconds) if $name eq 'note_off';
        $device->send_event($name => @{ $event }[ 2 .. 4 ]);
    }
}
