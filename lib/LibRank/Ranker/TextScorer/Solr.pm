package LibRank::Ranker::TextScorer::Solr;
use Moose;
use namespace::autoclean;

use Hash::Merge qw(merge);

extends 'LibRank::Ranker::TextScorer::Base';

has 'solr'     => (is => 'ro', lazy => 1, builder => '_build_solr');
has 'custom_params' => (is => 'ro', default => sub { {} });
has 'id_field' => (is => 'ro', default => 'id');

sub _build_solr {
  require WebService::Solr;
  return WebService::Solr->new();
}

sub get_text_scores {
  my $self  = shift;
  my $query = shift;
  my $ids   = shift;

  my $w = $self->weights;
  my $w_solr = {};
  foreach my $k (keys %$w) {
	my $x = $w->{$k};
	if(ref($x)) {
	  # e.g. qf => 'title^10 subject^3 ...'
	  $w_solr->{$k} = join(' ',map { $_.'^'.$w->{$k}{$_} } keys %{$w->{$k}});
	} else {
	  # e.g. $k == 'ps'
	  $w_solr->{$k} = $x;
	}
  }
  my $opts = {
	rows => scalar(@$ids),
	fl => 'score,'.$self->id_field,
	%$w_solr,
    fq=>[ sprintf('%s:(%s)',$self->id_field,join(' OR ', @$ids)) ],
  };
  $opts = merge($opts, $self->custom_params);
  my $res = $self->solr->search($query, $opts);

  my %scores = map { $_->value_for($self->id_field) => $_->value_for('score')+0 } $res->docs;

  return \%scores;
}

1;
