#!/usr/bin/env perl
use strict;
use warnings;

use lib map { "$ENV{HOME}/sandbox/$_/lib" } qw(MIDI-Util Music-Duration-Partition); # my local libraries

use Data::Dumper::Compact qw(ddc);
use MIDI::Util qw(setup_score);
use Music::Duration::Partition ();
use Music::Scales qw(get_scale_MIDI);

my $score = setup_score();

my $mdp = Music::Duration::Partition->new(
    size => 8, # number of quarter-note beats (2 measures)
    pool => [qw(hn dqn qn en)],
);

my @motifs = $mdp->motifs(4);

my @pitches = get_scale_MIDI('C', 4, 'major');
print ddc \@pitches;

for my $motif (@motifs) {
    my @voices = map { $pitches[ int rand @pitches ] } @$motif;

    print ddc $motif;
    print ddc \@voices;

    $mdp->add_to_score($score, $motif, \@voices);
}

$score->write_score('audio/example-1.mid');

