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
    spyOn(bfg_bad, 'get_records').andCallThrough();
    spyOn(bfg_bad, 'data_loaded_callback').andCallThrough();
    bfg_bad.get_records(1, function(){});
    expect(bfg_bad.get_records).toHaveBeenCalled();
    expect(bfg_bad.data_loaded_callback).not.toHaveBeenCalled();
  });

  it("with appropriate parameters will get public posts", function () {
    var bfg_good = new Bfg({
      api:'AIzaSyDb4QXZmhNwqgRuWjhUjwymXiXSnHS_Qso',
      user:'102960425588359758591'
    });
    spyOn(bfg_good, 'get_records').andCallThrough();
    spyOn(bfg_good, 'data_loaded_callback').andCallThrough();
    var custom_function = function(data) {};
    //spyOn(bfg_good, 'callback').andCallThrough();
    runs(function() {
      bfg_good.get_records(50, custom_function);
    });
    waitsFor(function(){
      console.log(bfg_good);
      return bfg_good.posts_loaded;
    }, 'Posts should be loaded', 750);
    runs(function() {
      expect(bfg_good.get_records).toHaveBeenCalled();
      expect(bfg_good.data_loaded_callback).toHaveBeenCalled();
    });
    //expect(bfg_good.callback).toHaveBeenCalled();
  })

});

// TODO: Finish specs someday
