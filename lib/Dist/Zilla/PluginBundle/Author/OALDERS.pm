use strict;
use warnings;
use feature qw( say );
package Dist::Zilla::PluginBundle::Author::OALDERS;

use Moose;
with('Dist::Zilla::Role::PluginBundle::Easy');

sub configure {
    my $self = shift;

    my $readme = 'README.md';
    my @dirty_files = ('dist.ini', 'Changes', $readme);
    my @from_build  = qw(INSTALL LICENSE META.json);
    my @copy = ( 'cpanfile', $readme );

    # Must come before Git::Commit
    $self->add_plugins('NextRelease');

    my @plugins = (
        'AutoPrereqs',
        'BumpVersionAfterRelease',
        'CheckChangesHasContent',
        'CPANFile',
        'ConfirmRelease',
        'ContributorsFile',
        [ 'CopyFilesFromBuild' => { copy => \@copy } ],
        'ExecDir',
        [ 'GithubMeta' => { issues => 1 } ],
        'ExtraTests',
        [ 'Git::GatherDir' => { exclude_filename => \@copy } ],
        [ 'Git::Check' => { allow_dirty => [ @dirty_files, @from_build ] } ],
        'Git::Commit',
        'Git::Contributors',
        #[ 'Git::NextVersion' => { first_version => '0.000001' } ],
        'Git::Tag',
        'Git::Push',
        'InstallGuide',
        'License',
        'MakeMaker',
        'Manifest',
        'ManifestSkip',
        'MetaJSON',
        [ 'MetaNoIndex' => { directory => [ 'examples', 't', 'xt' ] } ],
        'MetaResources',
        'MetaYAML',
        'MinimumPerl',
        'ModuleBuild',
        'PkgVersion',
        'Pod2Readme',
        'PodCoverageTests',
        'PodWeaver',
        'Prereqs',
        'PruneCruft',
        [
            'ReadmeAnyFromPod' => 'ReadmeMdInRoot' => {
                filename => $readme,
                location => 'root',
                type     => 'markdown',
            }
        ],
        'RewriteVersion',
        'ShareDir',
        'Test::CPAN::Changes',
        'Test::Perl::Critic',
        'Test::PodSpelling',
        'TestRelease',
        'Test::Synopsis',
        'TravisCI::StatusBadge',
        'UploadToCPAN',
    );

    $self->add_plugins($_) for @plugins;
}

__PACKAGE__->meta->make_immutable;
1;

#ABSTRACT: A plugin bundle for distributions built by OALDERS
__END__

