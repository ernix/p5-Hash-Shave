# NAME

Object::Squash - Remove numbered keys from a nested object

# DESCRIPTION

This package provides B<squash> subroutine to simplify hash/array structures.

I sometimes want to walk through a data structure that consists only of a bunch
of nested hashes, even if some of them should be treated as arrays or single
values.  This module removes numbered keys from a hash.

# SYNOPSIS

## squash

```perl
use Object::Squash qw(shave);
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

$hash now turns to:

```perl
+{
    foo => [
        'nested',
        'numbered',
        'hash',
        'structures',
    ],
    bar => 'obviously a single value',
};
```

# AUTHOR

Shin Kojima <shin@kojima.org>

# LICENSE

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.
