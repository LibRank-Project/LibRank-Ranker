package LibRank::Ranker::TaskRanker::PDL;
use Moose;
use namespace::autoclean;

use LibRank::Ranker::Util::PDL;

extends 'LibRank::Ranker::TaskRanker::Base';

sub rank_task {
  my $self = shift;
  my $t = shift;
  my $task = $t->{task};

  my $ids = $task->doc_ids;
  my $text_score = $self->text_scorer->get_text_score_vector($task->query,$ids);
  my $scores = $self->model->rank($text_score, $t->{feature_matrix});
  my @idx = $scores->slice('(0)')->qsorti()->slice('-1:0')->list();

  my $docs = $task->docs();
  #warn $scores->slice(0);
  #warn $scores((0),(0));
  my @text_score = $text_score->list();
  my @scores = $scores->list();
  my @docs = map { {
	  record_id => $docs->[$_]->{record_id},
	  text_score => $text_score[$_],
	  score => $scores[$_]
  } } (0..$#$docs);
  @docs = @docs[@idx];
  # Optional: alternative sorting with stable sorting for tied scores.
  #@docs = sort { $b->{score} <=> $a->{score} } @docs;

  return \@docs;

}

__PACKAGE__->meta->make_immutable;
