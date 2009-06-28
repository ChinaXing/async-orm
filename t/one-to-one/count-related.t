use strict;
use warnings;

use Test::More tests => 1;

use lib 't/lib';

use TestDB;

use Author;
use AuthorAdmin;
use Admin;

my $dbh = TestDB->dbh;

my @authors;

Author->new(name => 'foo', author_admin => {beard => 0})->create(
    $dbh => sub {
        my ($dbh, $author) = @_;

        push @authors, $author;

    }
);

Author->new(id => $authors[0]->column('id'))->load(
    $dbh => sub {
        my ($dbh, $author) = @_;

        $author->count_related(
            $dbh => 'author_admin' => sub {
                my ($dbh, $count) = @_;

                is($count, 1);
            }
        );
    }
);

$authors[0]->delete($dbh => sub { });
