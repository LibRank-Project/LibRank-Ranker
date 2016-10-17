# LibRank::Ranker

This repository contains the LibRank ranking models and corresponding utilities.
The main purpose of the models is to combine query dependent features (text score) and query independent features. The models differ mainly in how they aggregate the scores.

There are two models implemented in this repository (`LibRank::Model::*`):

* pOWAv1 - a model that limits the effect of query independent features with respect to the text score
* EconBiz - the ranking model used in EconBiz

The models themselves only take care of the query independent features and the aggregation. The text scores need to be provided to the model. The text scores could be calculated from the the raw text statistical features. Instead, `TextScorer::Solr` uses an existing solr instance to extract the text score according to the Solr/Lucence scoring formula.

The `TaskRanker` classes integrate the `Model` and the `TextScorer` components and provide a common interface to rank [`LibRank::Task`](https://github.com/LibRank-Project/LibRank-Task) objects.

