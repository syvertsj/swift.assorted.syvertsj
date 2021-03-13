
 ----------------------------------------------------------------------------
LZ78 Compression Algorithm In Swift
 ----------------------------------------------------------------------------

https://en.wikipedia.org/wiki/LZ77_and_LZ78

This is a simple command line implementation of the LZ78 "offset" compression 
algorithm using a Makefile and the 'swiftc' compiler to build.

The implementation is very simple, using a hash to store the term count of the
first instance of each term. 

Compression replaces repeat terms with the initial position. This differs from
the original lz78 algorithm which uses offsets from prior occurances, which 
would be more difficult to implement, higher runtime complexity, and presents 
no gain in compression.

Expansion retrieves the keys for the offset values and restores the original
file content.

 ----------------------------------------------------------------------------

build:
    make all 

clean workspace: 
    make clean

compress:
    ./lz78 -z datafile

uncompress:
    ./lz78 -x datafile.lz78

 ----------------------------------------------------------------------------
