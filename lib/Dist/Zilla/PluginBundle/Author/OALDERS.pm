use strict;
use warnings;
use feature qw( say );
package Dist::Zilla::PluginBundle::Author::OALDERS;

use Moose;
use List::AllUtils qw( first );
use Types::Path::Tiny qw( Path );
use Types::Standard qw( ArrayRef Maybe Str );

with(
    'Dist::Zilla::Role::PluginBundle::Easy',
    'Dist::Zilla::Role::PluginBundle::PluginRemover',
);

has stopwords => (
    traits    => ['Array'],
    is        => 'ro',
    isa       => ArrayRef [Str],
    predicate => '_has_stopwords',
    required  => 0,
);

has stopwords_file => (
    is      => 'ro',
    isa     => Maybe [Path],
    coerce => 1,
    default => sub {
        first { -e } ( '.stopwords', 'stopwords' );
    },
);

sub configure {
    my $self = shift;

    my $readme      = 'README.md';
    my @dirty_files = ( 'dist.ini', 'Changes', $readme );
    my @from_build  = qw(INSTALL LICENSE META.json);
    my @copy        = ( 'cpanfile', 'Makefile.PL', $readme );

    # Must come before Git::Commit
    $self->add_plugins('NextRelease');

    my @plugins = (
        'AutoPrereqs',
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
        'Git::Tag',
        'Git::Push',
        'InstallGuide',
        'License',
        'MakeMaker',
        'Manifest',
        'ManifestSkip',
        'MAXMIND::TidyAll',
        'MetaJSON',
        [ 'MetaNoIndex' => { directory => [ 'examples', 't', 'xt' ] } ],
        'MetaResources',
        'MetaYAML',
        'MinimumPerl',
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
        'ShareDir',
        'Test::CPAN::Changes',
        'Test::Perl::Critic',
        [ 'Test::PodSpelling' => { stopwords => $self->_all_stopwords } ],
        'TestRelease',
        'Test::Synopsis',
        'TravisCI::StatusBadge',
        'UploadToCPAN',
    );

    $self->add_plugins($_) for @plugins;
}

sub _all_stopwords {
    my $self = shift;

    my @stopwords = $self->_default_stopwords;
    push @stopwords, @{ $self->stopwords } if $self->_has_stopwords;

    if ( $self->stopwords_file ) {
        push @stopwords, $self->stopwords_file->lines( { chomp => 1 });
    }

    return \@stopwords;
}

sub _default_stopwords {
    qw(
        Alders
        Alders'
    );
}

__PACKAGE__->meta->make_immutable;
1;

#ABSTRACT: A plugin bundle for distributions built by OALDERS
__END__

=head2 configure

No docs for the time being, but you can see the bundled plugin by checking
c<configure()> in the module source.

=head1 SEE ALSO

I used L<https://metacpan.org/pod/Dist::Zilla::PluginBundle::RJBS> and
L<https://metacpan.org/pod/Dist::Zilla::PluginBundle::Author::DBOOK> as
templates to get my own bundle started.

=cut
