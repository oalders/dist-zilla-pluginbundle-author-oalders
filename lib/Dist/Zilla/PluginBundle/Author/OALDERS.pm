use strict;
use warnings;
use feature qw( say );
package Dist::Zilla::PluginBundle::Author::OALDERS;

use Moose;
with(
    'Dist::Zilla::Role::PluginBundle::Easy',

    #    'Dist::Zilla::Role::PluginBundle::Config::Slicer',
    #'Dist::Zilla::Role::PluginBundle::PluginRemover',
);

sub configure {
    my $self    = shift;
    my @plugins = (
        'AutoPrereqs',
        'CPANFile',
        'ConfirmRelease',
        'ContributorsFile',
        [ 'CopyFilesFromBuild' => { copy => [ 'cpanfile', 'README' ] } ],
        'ExecDir',
        [ 'GithubMeta' => { issues => 1 } ],
        'ExtraTests',
        'Git::Contributors',
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

    # Stolen from Dist::Zilla::PluginBundle::Author::DBOOK
    my $versioned_match = '^(?:lib|script|bin)/';
    my @dirty_files     = qw(dist.ini Changes README.pod);
    my @from_build      = qw(INSTALL LICENSE META.json);

    $self->add_plugins(
        'CheckChangesHasContent',
        [ 'Git::Check' => { allow_dirty => [ @dirty_files, @from_build ] } ],
        'RewriteVersion',
        [
            NextRelease => {
                format =>
                    '%-9v %{yyyy-MM-dd HH:mm:ss VVV}d%{ (TRIAL RELEASE)}T'
            }
        ],
        [
            'Git::Commit' => {
                allow_dirty => [ @dirty_files, @from_build ],
                allow_dirty_match => $versioned_match, add_files_in => '/'
            }
        ],
        'Git::Tag',

        #        [ BumpVersionAfterRelease => { munge_makefile_pl => 0 } ],
        [
            'Git::Commit' => 'Commit_Version_Bump' => {
                allow_dirty_match => $versioned_match,
                commit_msg        => 'Bump version'
            }
        ],
        'Git::Push'
    );
}

__PACKAGE__->meta->make_immutable;
1;

#ABSTRACT: A plugin bundle for distributions built by OALDERS
__END__

