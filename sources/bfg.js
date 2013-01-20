// Generated by CoffeeScript 1.4.0
(function() {
  var Bfg, bfg;

  Bfg = (function() {

    function Bfg() {
      this.api_key = $("meta[name='bfg:api']").attr("content");
      this.userid = $("meta[name='bfg:user']").attr("content");
      this.locale = $("meta[name='bfg:locale']").attr("content");
      this.annotation_length = 35;
      this.prepare_container();
      this.load_blog();
    }

    Bfg.prototype.prepare_container = function() {
      return $("#bfg div.bfg-container").html("<div class='bfg-message'></div><div class='bfg-body'></div>");
    };

    Bfg.prototype.blog_posts = function() {
      return this.posts;
    };

    Bfg.prototype.process_posts = function() {
      var post, posts;
      posts = this.blog_posts();
      this.d(posts);
      this.d(posts.length);
      if (posts.length > 0) {
        return this.render_posts((function() {
          var _i, _len, _results;
          _results = [];
          for (_i = 0, _len = posts.length; _i < _len; _i++) {
            post = posts[_i];
            _results.push(this.pack_post(post));
          }
          return _results;
        }).call(this));
      } else {

      }
    };

    Bfg.prototype.load_blog = function() {
      var _this = this;
      return $.getJSON('https://www.googleapis.com/plus/v1/people/' + this.userid + '/activities/public?key=' + this.api_key, function(data) {
        _this.posts = data['items'];
        return _this.process_posts();
      });
    };

    Bfg.prototype.load_post = function(id) {
      var post, post_html, _i, _len, _ref;
      if (parseInt(id) === 0) {
        return message($.t('app.messages.posts.not_found'));
      }
      _ref = this.blog_posts;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        post = _ref[_i];
        if (post['id'] === id) {
          post = post;
        }
      }
      post_html = this.unpack_post(post);
      return this.render_post(post_html);
    };

    Bfg.prototype.message = function(text, type) {
      if (type == null) {
        type = 'info';
      }
      return $("#bfg div.bfg-container div.bfg-body").html("<span class='bfg-message-" + type + "'>" + text + "</span>");
    };

    Bfg.prototype.post_preview = function(post) {
      return "";
    };

    Bfg.prototype.post_annotation = function(post) {
      var arr, chunk, ret, _i, _len;
      if (!post['title'] || post['title'].length === 0 || post['title'].length < this.annotation_length) {
        return "";
      }
      arr = post['title'].split(/\s/);
      ret = "";
      for (_i = 0, _len = arr.length; _i < _len; _i++) {
        chunk = arr[_i];
        if (ret.length < this.annotation_length) {
          ret += (ret.length === 0 ? '' : ' ') + chunk;
        }
      }
      return ret + '...';
    };

    Bfg.prototype.post_content = function(post) {
      return "";
    };

    Bfg.prototype.post_body = function(post) {
      var html;
      html = "<div id='bfg-post-" + post['id'] + "-modal' class='modal hide fade' tabindex='-1' role='dialog' aria-labelledby='myModalLabel' aria-hidden='true'>";
      html += "<div class='modal-header'>";
      html += "<button type='button' class='close' data-dismiss='modal' aria-hidden='true'>x</button>";
      html += "<h3 id='myModalLabel'>" + this.post_annotation(post) + "</h3>";
      html += "</div>";
      html += "<div class='modal-body'>" + this.post_content(post) + "</div>";
      html += "<div class='modal-footer'>";
      html += "<button class='btn' data-dismiss='modal' aria-hidden='true'>Close</button>";
      return html += "</div></div>";
    };

    Bfg.prototype.pack_post = function(post) {
      var html;
      html = "<div id='bfg-post-" + post['id'] + "' class='bfg-post' data-id='" + post['id'] + "' data-image='" + this.post_preview(post) + "'>";
      html += "<span class='bfg-post-header'>" + this.post_annotation(post) + "</span>";
      html += "<div class='bfg-post-body'>" + this.post_body(post) + "</div>";
      html += "</div>";
      return html;
    };

    Bfg.prototype.unpack_post = function(post) {};

    Bfg.prototype.render_posts = function(html) {
      $("#bfg div.bfg-container div.bfg-body").html(html);
      return $(".bfg-post").click(function() {
        return $('#bfg-post-' + $(this).data('id') + '-modal').modal({
          show: true
        });
      });
    };

    Bfg.prototype.render_post = function(html) {};

    Bfg.prototype.d = function(obj) {
      return console.log(obj);
    };

    return Bfg;

  })();

  bfg = new Bfg;

}).call(this);
