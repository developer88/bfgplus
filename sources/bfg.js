// Generated by CoffeeScript 1.4.0
(function() {
  var ABC, Bfg;

  ABC = (function() {

    function ABC() {}

    return ABC;

  })();

  Bfg = (function() {

    function Bfg(options) {
      var option;
      this.options = options;
      this.api_key = this.options['api_key'];
      this.userid = this.options['userid'];
      this.domid = this.options['domid'];
      option = {
        resGetPath: 'js/locales/__lng__.json',
        lng: 'en-US'
      };
      $.i18n.init(option, function(t) {
        var appName;
        return appName = t("key");
      });
      load_blog;

    }

    Bfg.prototype.blog_posts = function() {
      return this.posts;
    };

    Bfg.prototype.load_blog = function() {
      return $.getJSON('https://www.googleapis.com/plus/v1/people/' + this.userid + '/activities/public?key=' + this.api_key, function(data) {
        this.posts = data['items'];
        return process_posts;
      });
    };

    Bfg.prototype.process_posts = function() {
      var post, posts;
      posts = blog_posts;
      if (posts.size > 0) {
        return render_posts((function() {
          var _i, _len, _results;
          _results = [];
          for (_i = 0, _len = posts.length; _i < _len; _i++) {
            post = posts[_i];
            _results.push(pack_post(post));
          }
          return _results;
        })());
      } else {
        return message($.t('app.messages.posts.empty'));
      }
    };

    Bfg.prototype.load_post = function(id) {
      var post, post_html, _i, _len;
      if (parseInt(id) === 0) {
        return message($.t('app.messages.posts.not_found'));
      }
      for (_i = 0, _len = blog_posts.length; _i < _len; _i++) {
        post = blog_posts[_i];
        if (post['id'] === id) {
          post = post;
        }
      }
      post_html = unpack_post(post);
      return render_post(post_html);
    };

    Bfg.prototype.message = function(text, type) {
      if (type == null) {
        type = 'info';
      }
    };

    Bfg.prototype.pack_post = function(post) {};

    Bfg.prototype.unpack_post = function(post) {};

    Bfg.prototype.render_posts = function(html) {
      return $(domid).html(html);
    };

    Bfg.prototype.render_post = function(html) {};

    return Bfg;

  })();

}).call(this);