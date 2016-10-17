package LibRank::Ranker::TextScorer::Role::Cached;
use Moose::Role;
use namespace::autoclean;

use Try::Tiny;
use CHI;
use CHI::Util qw(json_encode);

requires 'get_text_scores';
requires 'weights';
requires 'set_weights';

has '_cache'     => (is => 'rw');
has 'cache'    => (is => 'rw', builder => '_build_cache');

sub _build_cache {
  my $self = shift;
  return CHI->new(driver => 'RawMemory', datastore => {});
}

after 'set_weights' => sub {
  my $self = shift;
  my $key = $self->weights;
  #use Data::Dumper;
  #warn Dumper($key);
  my $cache = $self->cache->compute($key, undef, sub { {} });
  $self->_cache($cache);
};



around 'get_text_scores' => sub {
  my $orig  = shift;
  my $self  = shift;
  my $query = shift;
  my $ids   = shift;

#  my $key = { query => $query, ids => $ids };
  # use standard key_serializer of CHI
  my $key = json_encode({ query => $query, ids => $ids });
  # my $key = { query => $query, ids => $ids, weights => $self->weights->{solr} };
  #my $key = $query;
  my $res = $self->_cache->{$key};
  if(!defined $res) {
	$res = $self->$orig($query, $ids);
	$self->_cache->{$key} = $res;
  }
  return $res;
};

1;
