Embed Bytes AS3
===============

What is this?
-------------

This Ruby program lets you convert arbitrary binary file into an
ActionScript3.0 static method.

The primary target is alternate for Flex [Embed] tags.


Usage
-----

    $ ./embed_bytes_as3.rb README.md

creates ```README.as```, which binary data could be retrieved by:

    var bytes:ByteArray = README.bytes


Copyright
---------

Please refer LICENSE.md
