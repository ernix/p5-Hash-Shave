use strict;
use warnings;
package Object::Squash;
# ABSTRACT: Remove numbered keys from a nested object

use parent 'Exporter';
use List::Util qw/max/;

use version; our $VERSION = version->declare("v0.0.1");

our @EXPORT_OK = qw(squash);

sub squash {
    my $obj = shift;
    return $obj unless ref $obj;

    $obj = _squash_hash($obj);
    $obj = _squash_array($obj);

    return $obj;
}

sub _squash_hash {
    my $obj = shift;
    return $obj if ref $obj ne 'HASH';

    my @keys = keys %{$obj};

    if (grep {/\D/} @keys) {
        return +{
            map { $_ => squash($obj->{$_}) } @keys,
        };
    }

    my $max = max(@keys) || 0;

    my @ar;
    for my $i (0 .. $max) {
        #
        # Some numbered keys might be partially discreated
        #
        push @ar, exists $obj->{$i} ? squash($obj->{$i}) : (undef);
    }

    return \@ar;
}

sub _squash_array {
    my $obj = shift;
    return $obj if ref $obj ne 'ARRAY';

    return (undef) if @{$obj} == 0;
    $obj = squash($obj->[0]) if @{$obj} == 1;

    return $obj;
}

1;
__END__

=head1 NAME

Object::Squash - Remove numbered keys from a nested object

=head1 DESCRIPTION

This package provides B<squash> subroutine to simplify hash/array structures.

I sometimes want to walk through a data structure that consists only of a bunch
of nested hashes, even if some of them should be treated as arrays or single
values.  This module removes numbered keys from a hash.

=head1 SYNOPSIS

=head2 C<squash>

    use Object::Squash qw(squash);
    my $hash = squash(+{
        foo => +{
            '0' => 'nested',
            '1' => 'numbered',
            '2' => 'hash',
            '3' => 'structures',
        },
        bar => +{
            '0' => 'obviously a single value',
        },
    });

$hash now turns to:

    +{
        foo => [
            'nested',
            'numbered',
            'hash',
            'structures',
        ],
        bar => 'obviously a single value',
    };

=head1 AUTHOR

Shin Kojima <shin@kojima.org>

=head1 LICENSE

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.
