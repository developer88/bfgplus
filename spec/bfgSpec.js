describe("Initialize Bfg Plus", function() {

  it("with appropriate parameters will not raise an error", function() {
    var bfg = new Bfg({
      dom:'#bfg-sample',
      api:'AIzaSyCQ0r-Z6wsYLFEbCGfJEzmrMuc4fc2BWdw',
      user:'102960425588359758591',
      locale:'en-US',
      count:100
    });
  });

  it("with inappropriate parameters will raise an error", function() {
    expect(function(){ new Bfg({dom:'#bfg-sample'}) }).toThrow();
  });

  xit("with appropriate parameters but wrong api key will show 'No post' message", function() {
    var bfg = new Bfg({
      dom:'#bfg-sample',
      api:'123112312312312312',
      user:'102960425588359758591',
      locale:'en-US',
      count:100
    });
    spyOn(bfg, 'place_and_show_progress_bar').andCallFake(function() { return true; });
    spyOn(bfg, 'hide_div_and_prepare_container').andCallFake(function() { return true; });
    spyOn(bfg, 'process_post').andCallFake(function() { return true; });
    expect(bfg.initialize()).toBe(true);
  });

});


describe("Initialize BFG Plus with parameter", function() {

  var options = {};

  beforeEach(function() {
    options = {
      dom:'#bfg-sample',
      api:'AIzaSyCQ0r-Z6wsYLFEbCGfJEzmrMuc4fc2BWdw',
      user:'102960425588359758591'
    };
  });      

  xit("count = 50 will render 50 posts from Google+", function() {
    options['count'] = 50
    var bfg = new Bfg(options);    
    spyOn(bfg, 'place_and_show_progress_bar').andCallFake(function() { return true; });
    spyOn(bfg, 'hide_div_and_prepare_container').andCallFake(function() { return true; });
    spyOn(bfg, 'process_post').andCallFake(function() { return true; });
    expect(bfg.initialize()).toBe(true);
    expect(bfg.blog_posts().length).toBe(50);
  });

  xit("locale = 'ru-RU' will render 100 posts with Russian locale", function() {
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