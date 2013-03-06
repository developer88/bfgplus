describe("Initialize Bfg Plus", function() {

  it("with appropriate parameters will not raise an error", function() {
    var bfg_good = new Bfg({
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

  it("with appropriate parameters but wrong api key will not render anything", function() {   
    var bfg_bad = new Bfg({
      dom:'#bfg-sample',
      api:'123112312312312312',
      user:'102960425588359758591',
      locale:'en-US',
      count:100
    });
    spyOn(bfg_bad, 'place_and_show_progress_bar').andCallFake(function() { return true; });
    spyOn(bfg_bad, 'hide_div_and_prepare_container').andCallFake(function() { return true; });
    spyOn($, "ajax").andCallThrough();
    spyOn(bfg_bad, 'load_blog').andCallThrough(); 
    spyOn(bfg_bad, 'load_blog_callback').andCallThrough();   
    bfg_bad.initialize();
    expect(bfg_bad.load_blog).toHaveBeenCalled(); 
    expect(bfg_bad.load_blog_callback).not.toHaveBeenCalled(); 
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
    var bfg_50 = new Bfg(options);    
    spyOn(bfg_50, 'place_and_show_progress_bar').andCallFake(function() { return true; });
    spyOn(bfg_50, 'hide_div_and_prepare_container').andCallFake(function() { return true; });
    //bfg_50.load_blog_callback = jasmine.createSpy();
    spyOn(bfg_50, 'load_blog').andCallThrough();
    spyOn(bfg_50, 'load_blog_callback');    
    bfg_50.initialize();
    expect(bfg_50.load_blog).toHaveBeenCalled();
    expect(bfg_50.load_blog_callback).toHaveBeenCalled();    
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