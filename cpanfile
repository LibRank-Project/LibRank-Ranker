requires 'CHI';
requires 'List::Util';
requires 'Hash::Merge';
requires 'Moose';
requires 'Moose::Role';
requires 'MooseX::Traits';
requires 'PDL';
requires 'Try::Tiny';
requires 'namespace::autoclean';
requires 'WebService::Solr';

on configure => sub {
    requires 'Module::Build';
    requires 'Module::Build::Prereqs::FromCPANfile';
};
