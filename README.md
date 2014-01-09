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


Another example which specifies output package and class names:

    $ ./embed_bytes_as3.rb LICENSE.md -o net.kaikoga.License README.md -o net.kaikoga.Readme

Copyright
---------

Please refer LICENSE.md
