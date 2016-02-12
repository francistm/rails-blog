module Front
  class SiteController < FrontController
    def index
      @post_count = Post.all.count
    end
  end
end
