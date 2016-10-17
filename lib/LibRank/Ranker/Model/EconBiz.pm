package LibRank::Ranker::Model::EconBiz;
use Moose;
use namespace::autoclean;

extends 'LibRank::Ranker::Model::Base';

=pod

* $text_scores : { <record_id> => <text_score>, ... }
* $docs : [ { record_id => ..., features => { <feature_name> => ..., ... } }, ... ]

=cut

sub rank {
  my $self = shift;
  my $text_scores = shift;
  my $docs = shift;

  my @docs;
  foreach my $doc (@$docs) {
	my $text_score = $text_scores->{$doc->{record_id}};
  	my $score = $text_score;
  	my $f = $doc->{features};
	$score *= $f->{lr_recency};
    $score *= (0.7 + 0.3 * $f->{lr_OA});
	$score *= (0.7 + 0.3 * $f->{lr_thesis_base});
	$score *= (1 + 0.00001 * $f->{lr_has_subject});
	push @docs, {
	  record_id => $doc->{record_id}, 
	  score => $score, 
	  text_score => $text_score
	};
  }
  @docs = sort { $b->{score} <=> $a->{score} } @docs;
  return \@docs;
}

__PACKAGE__->meta->make_immutable;
