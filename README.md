# NAME

Hash::Shave - Shave off a redundant hash

# VERSION

version 0.01

# DESCRIPTION

This package provides __shave__ subroutine to rebuild hash structures.

I sometimes need to walk through a data structure that it consists only of
a bunch of nested hashes, even if some of them should be treated as arrays or
single values.  This module shaves these numbered keys.

# SYNOPSIS

```perl
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
```

or

```perl
use Hash::Shave;
my $shave = Hash::Shave->new;
my $hash = $shave->off($complicated_hash);
```

# METHODS

- __new__

    Create Hash::Shave object

- __shave__

    Shave hash object

- __off__

    Shave hash object

# AUTHOR

Shin Kojima <shin@kojima.org>

# LICENSE

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.
