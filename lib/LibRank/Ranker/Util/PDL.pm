package LibRank::Ranker::Util::PDL;
use strict;
use warnings;
use Exporter qw(import);

our @EXPORT_OK = qw(create_feature_matrix);

use PDL::Core qw(pdl);

sub create_feature_matrix {
  my $docs = shift;
  my $feature_idx = shift;

  my @mat;
  foreach my $doc (@$docs) {
	push @mat, [ map { $doc->{$_} } @$feature_idx ];
  }
  return pdl(\@mat);
};

1;
