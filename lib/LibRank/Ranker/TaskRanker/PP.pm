package LibRank::Ranker::TaskRanker::PP;
use Moose;
use namespace::autoclean;

extends 'LibRank::Ranker::TaskRanker::Base';

#has 'task_factory' => (is => 'ro', builder => '_build_task_factory');

sub rank_task {
  my $self = shift;
  my $t    = shift;
  my $task = $t->{task};

  my $ids = $task->doc_ids;
  my $text_score = $self->text_scorer->get_text_scores($task->query,$ids);
  my $docs = $self->model->rank($text_score, $task->docs);
  return $docs;
}

__PACKAGE__->meta->make_immutable;
