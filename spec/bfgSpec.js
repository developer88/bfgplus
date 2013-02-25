xdescribe("Initialize Bfg Plus", function() {

  it("with appropriate parameters will not raise an error", function() {

  });

  it("with inappropriate parameters will raise an error", function() {

  });

  it("with appropriate parameters but wrong api key will show 'No post' message", function() {

  });

});


xdescribe("Initialize BFG Plus with parameter", function() {

  var options = {};

  beforeEach(function() {
    options = {
      dom:'#bfg-sample',
      api:'AIzaSyCQ0r-Z6wsYLFEbCGfJEzmrMuc4fc2BWdw',
      user:'102960425588359758591'
    };
  });      

  it("count = 50 will render 50 posts from Google+", function() {
    options['count'] = 50

  });

  it("locale = 'ru-RU' will render 100 posts with Russian locale", function() {
    options['locale'] = 'ru-RU'

  });

});

xdescribe("Post class", function() {

  it("to be initialized properly when pass appropriate object", function() {

  });

  it("to handle wrong post type properly", function() {

  });

  it("to render object properly", function() {

  });

});