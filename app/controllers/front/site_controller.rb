module Front
  class SiteController < FrontController
    def feed
      @posts = Post.order(id: :desc).limit(5).all

      respond_to do |format|
        format.xml
      end
    end

    def index
      @post_count = Post.all.count
    end
  end
end
