#!/usr/bin/env perl
use strict;
use warnings;

use lib map { "$ENV{HOME}/sandbox/$_/lib" } qw(MIDI-Util Music-Duration-Partition);

use Data::Dumper::Compact qw(ddc);
use MIDI::Util qw(setup_score);
use Music::Duration::Partition ();
use Music::Scales qw(get_scale_MIDI);

my $score = setup_score();

my $mdp = Music::Duration::Partition->new(
    size => 4, # 1 measure in 4/4
    pool => [qw(hn dqn qn en)],
);

my @pitches = get_scale_MIDI('C', 4, 'major');
print ddc \@pitches;

my @motifs = $mdp->motifs(4);

for my $motif (@motifs) {
    my @notes = map { $pitches[ int rand @pitches ] } @$motif;

    print ddc $motif;
    print ddc \@notes;

    $mdp->add_to_score($score, $motif, \@notes);
}

$score->write_score('audio/example-1.mid');

