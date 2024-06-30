#!/usr/bin/env perl
use strict;
use warnings;

use if $ENV{USER} eq "gene", lib => map { "$ENV{HOME}/sandbox/$_/lib" } qw(MIDI-Util Music-Duration-Partition); # my local libraries

use Data::Dumper::Compact qw(ddc);
use MIDI::Util qw(setup_score);
use Music::Duration::Partition ();
use Music::Scales qw(get_scale_MIDI);
use Music::VoiceGen ();

my $score = setup_score();

my $mdp = Music::Duration::Partition->new(
    size => 8, # number of quarter-note beats (2 measures)
    pool => [qw(hn dqn qn en)],
);

my @motifs = $mdp->motifs(4);

my @pitches = (get_scale_MIDI('C', 4, 'major'),
               get_scale_MIDI('C', 5, 'major'));

my $voice = Music::VoiceGen->new(
    pitches   => \@pitches,
    intervals => [qw(-3 -2 -1 1 2 3)], # allowed interval jumps
);

for my $motif (@motifs) {
    my @voices = map { $voice->rand } @$motif;

    $mdp->add_to_score($score, $motif, \@voices);
}

$score->write_score('audio/example-2.mid');

