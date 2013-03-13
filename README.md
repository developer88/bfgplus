bfg+
=====

BFG + means Blog For Google +

![Doom BFG weapon](http://games.compulenta.ru/upload/iblock/ae7/bfg.jpg)

Small Library that receives and render public Google+ posts via official [Google+ API](https://developers.google.com/+/api/). 

Library can receives maximum 100 posts (restriction of Google+).

###Dependencies

*   [JQuery](http://jquery.com/)
*   [Twitter Bootstrap](http://twitter.github.com/bootstrap/index.html)
*   [i18next](http://i18next.com)

*   [Coffescript](http://coffeescript.org/) for sources
*   [Jasmine](http://pivotal.github.com/jasmine/) for specs

###Get started

Download files and add necessary dependencies to your page:

`
  <link href="css/bootstrap.min.css" rel="stylesheet" media="screen">
  <link href="css/bfg.css" rel="stylesheet" media="screen">
  <script src="http://code.jquery.com/jquery-latest.js"></script>
  <script src="js/bootstrap.min.js"></script>
  <script src="js/i18next.min.js"></script>
  <script src="sources/bfg.js"></script>
`

Place a container for Google+ posts like this:

`
  <div id="bfg-sample"></div>
`

Create an API key for your Google+ account in [Google APIs](https://code.google.com/apis/console/b/0/).

Grap your user id from url for, for example, your Google+ Profile.

Initialize Bfg+:

`
  <script>
    var bfg = new Bfg({
      dom:'#DOM_ID',
      api:'API_KEY',
      user:'GOOGLE+_USER_ID',
      locale:'en-US',
      count:100
    });
  </script>
`

Call Bfg+:

`
  bfg.initialize();
`

### Licence

This code is [MIT][mit] licenced:

Copyright (c) 2012-2013 Eremin Andrey

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


[mit]: http://www.opensource.org/licenses/mit-license.php
[murmur]: http://en.wikipedia.org/wiki/MurmurHash
[research]: https://panopticlick.eff.org/browser-uniqueness.pdf