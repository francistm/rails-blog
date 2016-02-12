class Front::PostsController < FrontController
  def show
    @post = Post.find_by! slug: params[:slug]
  end

  def index
    @posts = Post.order(published_at: :desc).all
  end
end
