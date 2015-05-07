describe("Initialize Bfg Plus", function() {

  it("with appropriate parameters will not raise an error", function() {
    var bfg_good = new Bfg({
      api:'AIzaSyCQ0r-Z6wsYLFEbCGfJEzmrMuc4fc2BWdw',
      user:'102960425588359758591'
    });
  });

  it("with inappropriate parameters will raise an error", function() {
    expect(function(){ new Bfg({something:'#bfg-sample'}) }).toThrow();
  });

  it("with appropriate parameters but wrong api key will not return anything", function() {
    var bfg_bad = new Bfg({
      api:'123112312312312312',
      user:'102960425588359758591'
    });
    spyOn($, "ajax").andCallThrough();
    spyOn(bfg_bad, 'load_blog').andCallThrough(); 
    spyOn(bfg_bad, 'load_blog_callback').andCallThrough();   
    bfg_bad.initialize();
    expect(bfg_bad.load_blog).toHaveBeenCalled(); 
    expect(bfg_bad.load_blog_callback).not.toHaveBeenCalled(); 
  });

});

// TODO: Finish specs someday
