package LibRank::Ranker::Model::pOWAv1::PDL;
use Moose;
use namespace::autoclean;

use PDL::Lite qw(pdl list transpose);
use PDL::NiceSlice;
use PDL::Reduce;
use PDL::Ufunc qw(sum);

extends 'LibRank::Ranker::Model::Base';

has 'weights' => (is => 'rw', writer => 'set_weights');
has 'normalize' => (is => 'ro', default => 0);
has 'normalize_weights' => (is => 'rw', default => 0);

has 'features_idx' => (is => 'ro', lazy => 1, builder => '_build_features_idx');
has 'weights_pdl' => (is => 'rw', lazy => 1, builder => '_build_weights_pdl', clearer => '_clear_weights_pdl');

after 'set_weights' => sub {
  my $self = shift;
  $self->_clear_weights_pdl;
};

sub _build_features_idx {
  my $self = shift;
  my @features = keys %{ $self->weights->{qi} };
  return \@features;
}


sub _build_weights_pdl {
  my $self = shift;

  my @features = @{ $self->features_idx };
  my $w = pdl([ map { $self->weights->{qi}{$_} } @features ]);
  if($self->normalize_weights and sum($w)!=0) {
    $w = $w/sum($w);
  }
  { vector => $w->transpose() };
}

sub rank {
  my $self = shift;
  my $text_score = shift;
  my $feature_matrix = shift;

  my $w = $self->weights_pdl->{vector};
  my $w_qi = $self->weights->{w_qi};

  my $scores = $feature_matrix * $text_score;
  if($self->normalize) {
    my $max = $scores->reduce('max',1);
	# Handle columns with max == 0. Set to non-zero to avoid NaN.
	$max->where($max==0) .= 1;
	$scores = $scores/$max;
  }
  $scores = $scores->matmult($w) * $w_qi + $text_score;
  return $scores;
  #warn $scores;
  my @idx = $scores((0))->qsorti()->(-1:0)->list();

  return \@idx;
}

__PACKAGE__->meta->make_immutable;
