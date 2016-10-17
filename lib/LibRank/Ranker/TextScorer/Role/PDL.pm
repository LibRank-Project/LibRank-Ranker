package LibRank::Ranker::TextScorer::Role::PDL;
use Moose::Role;
use namespace::autoclean;

requires 'get_text_scores';

use PDL::Core qw(pdl);

sub get_text_score_vector {
  my $self  = shift;
  my $query = shift;
  my $ids   = shift;

  my $text_scores = $self->get_text_scores($query, $ids);
  my $v = pdl([map { $text_scores->{$_} } @$ids])->transpose;
  return $v;
}

1;
