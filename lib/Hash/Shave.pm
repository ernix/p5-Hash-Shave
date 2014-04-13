use strict;
use warnings;
package Hash::Shave;
# ABSTRACT: Shave off a redundant hash

use parent 'Exporter';
use List::Util qw/max/;

our @EXPORT_OK = qw(shave);

sub new {
    my $class = shift;
    bless {@_}, $class;
}

sub shave {
    my ($self, $obj) = @_;
    $obj = $self unless defined $obj;
    return $obj unless ref $obj;

    if (ref $obj eq 'HASH') {
        $obj = sub {
            my $_obj = shift;
            my @keys = keys %{$_obj};
            if (grep {/\D/} @keys) {
                return +{
                    map { $_ => shave($_obj->{$_}) } @keys,
                };
            }
            my @ar;
            my $max = max(@keys) || 0;
            for (0 .. $max) {
                push @ar, sub {
                    return undef unless exists $_obj->{$_};
                    return shave($_obj->{$_});
                }->($_);
            }
            return \@ar;
        }->($obj);
    }

    if (ref $obj eq 'ARRAY') {
        $obj = shave($obj->[0]) if @{$obj} == 1;
    }

    return $obj;
}

sub off {
    my ($self, $hash) = @_;
    return $self->shave($hash);
}

1;
__END__

=head1 NAME

Hash::Shave - Shave off a redundant hash

=head1 DESCRIPTION

This package provides B<shave> subroutine to rebuild hash structures.

I sometimes need to walk through a data structure that it consists only of
a bunch of nested hashes, even if some of them should be treated as arrays or
single values.  This module shaves these numbered keys.

=head1 SYNOPSIS

    use Hash::Shave qw(shave);
    my $hash = shave(+{
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
    print join q{ }, @{$hash->{foo}}, $hash->{bar};

or

    use Hash::Shave;
    my $shave = Hash::Shave->new;
    my $hash = $shave->off($complicated_hash);

=head1 METHODS

=over 4

=item B<new>

Create Hash::Shave object

=item B<shave>

Shave hash object

=item B<off>

Shave hash object

=back

=head1 AUTHOR

Shin Kojima <shin@kojima.org>

=head1 LICENSE

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.
