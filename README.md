bfg+ [Working in progress. Use stabe v0.1 instead]
=====

BFG + means Blog For Google +

![Doom BFG weapon](http://games.compulenta.ru/upload/iblock/ae7/bfg.jpg)

Small Library that receives public Google+ posts via official [Google+ API](https://developers.google.com/+/api/). 

Library can receives maximum 100 posts (restriction of Google+).

###Dependencies

none :)

###Development dependencies

*   [Coffescript](http://coffeescript.org/) for sources
*   [Jasmine](http://pivotal.github.com/jasmine/) for specs

###Get started

Download files and add necessary dependencies to your page:

```
  <script src="sources/bfg.js"></script>
```

Create an API key for your Google+ account in [Google APIs](https://code.google.com/apis/console/b/0/).

Grab your user id from url of your Google+ Profile.

Initialize Bfg+:

```
  <script>
    var bfg = new Bfg({
      api:'API_KEY',
      user:'GOOGLE+_USER_ID'
    });
  </script>
```

Call Bfg+:

```
  bfg.bfg.get_records(50, function(posts){console.log(posts)});
```

### Licence

This code is [MIT][mit] licenced:

Copyright (c) 2012-2015 Andrey Eremin

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

[mit]: http://www.opensource.org/licenses/mit-license.php
[murmur]: http://en.wikipedia.org/wiki/MurmurHash
[research]: https://panopticlick.eff.org/browser-uniqueness.pdf
