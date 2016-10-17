package LibRank::Ranker::TextScorer::Base;
use Moose;
use namespace::autoclean;

with 'MooseX::Traits';
has '+_trait_namespace' => ( default => 'LibRank::Ranker::TextScorer::Role' );


has 'weights' => (is => 'rw', writer => 'set_weights', lazy => 1, builder => '_build_weights_default');
has 'weights_default' => ( is => 'ro', lazy => 1, builder => '_build_weights_default');

sub reset_weights {
  my $self = shift;
  $self->set_weights($self->weights_default);
}

sub _build_weights_default {
  my $w = {
	qf  => { text => 1, fulltext => 1, subject_suggest => 3, title => 5 },
	pf  => { text => 1, fulltext => 1, subject_exact => 3, title => 7, title_exact => 10 },
	pf2 => { subject_suggest => 10, title => 3, fulltext => 1 },
	pf3 => { subject_suggest => 10, title => 3, fulltext => 1 },
	ps  => 2
  };
  return $w;
}

__PACKAGE__->meta->make_immutable;
