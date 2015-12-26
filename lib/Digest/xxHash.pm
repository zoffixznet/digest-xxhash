use v6;
use NativeCall;
unit module Digest::xxHash;

# xxHash C wrapper functions (/usr/lib/libxxhash.so) {{{

# unsigned int XXH32 (const void* input, size_t length, unsigned seed);
sub XXH32(CArray[int8], int32, uint) returns uint is native('xxhash') {*}

# unsigned long long XXH64 (const void* input, size_t length, unsigned long long seed);
sub XXH64(CArray[int8], int64, ulonglong) returns ulonglong is native('xxhash') {*}

# end xxHash C wrapper functions (/usr/lib/libxxhash.so) }}}

# 32 or 64 bit {{{

multi sub xxHash(Str $string, Int :$seed = 0) is export returns Int
{
    my Int @data = $string.split('')».encode».contents.flat».Int;
    build_xxhash(@data, $seed);
}

multi sub xxHash(Str :$file!, Int :$seed = 0) is export returns Int
{
    xxHash(slurp($file), :$seed);
}

multi sub xxHash(Buf[uint8] :$buf-u8!, Int :$seed = 0) is export returns Int
{
    my Int @data = $buf-u8.list;
    build_xxhash(@data, $seed);
}

sub build_xxhash(Int @data, Int $seed = 0) returns Int
{
    $*KERNEL.bits == 64
        ?? build_xxhash64(@data, $seed)
        !! build_xxhash32(@data, $seed);
}

# end 32 or 64 bit }}}
# 32 bit only {{{

multi sub xxHash32(Str $string, Int :$seed = 0) is export returns Int
{
    my Int @data = $string.split('')».encode».contents.flat».Int;
    build_xxhash32(@data, $seed);
}

multi sub xxHash32(Str :$file!, Int :$seed = 0) is export returns Int
{
    xxHash32(slurp($file), :$seed);
}

multi sub xxHash32(Buf[uint8] :$buf-u8!, Int :$seed = 0) is export returns Int
{
    my Int @data = $buf-u8.list;
    build_xxhash32(@data, $seed);
}

sub build_xxhash32(Int @data, uint $seed = 0) returns uint
{
    my @input := CArray[int8].new;
    my Int $len = 0;
    @input[$len++] = $_ for @data;
    XXH32(@input, $len, $seed);
}

# end 32 bit only }}}
# 64 bit only {{{

multi sub xxHash64(Str $string, Int :$seed = 0) is export returns Int
{
    my Int @data = $string.split('')».encode».contents.flat».Int;
    build_xxhash64(@data, $seed);
}

multi sub xxHash64(Str :$file!, Int :$seed = 0) is export returns Int
{
    xxHash64(slurp($file), :$seed);
}

multi sub xxHash64(Buf[uint8] :$buf-u8!, Int :$seed = 0) is export returns Int
{
    my Int @data = $buf-u8.list;
    build_xxhash64(@data, $seed);
}

sub build_xxhash64(Int @data, ulonglong $seed = 0) returns ulonglong
{
    my @input := CArray[int8].new;
    my Int $len = 0;
    @input[$len++] = $_ for @data;
    XXH64(@input, $len, $seed);
}

# end 64 bit only }}}

# vim: ft=perl6 fdm=marker fdl=0
