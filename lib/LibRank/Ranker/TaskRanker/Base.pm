package LibRank::Ranker::TaskRanker::Base;
use Moose;
use namespace::autoclean;

has 'model'		  => (is => 'ro', required => 1);
has 'text_scorer' => (is => 'ro', required => 1);
#has 'task_factory' => (is => 'ro', builder => '_build_task_factory');

sub set_weights {
  my $self = shift;
  my $w = shift;
  $self->text_scorer->set_weights($w->{solr});
  my $w2 = { map { $_ => $w->{$_} } (grep { $_ ne 'solr' } keys %$w) };
  $self->model->set_weights($w2);
}

__PACKAGE__->meta->make_immutable;
