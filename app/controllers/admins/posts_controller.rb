class Admins::PostsController < AdminController
  def new
    @post = Post.new
  end

  def edit
    @post = Post.find params[:id]
  end

  def index
    @posts = Post.order(created_at: :desc).all
  end

  def create
    @post = Post.new
    @post.admin = current_admin
    @post.attributes = post_params

    if @post.valid? && @post.save
      flash[:success] = t 'admin/posts.create_success', title: @post.title
      redirect_to [:admins, :posts] and return
    end

    flash.now[:danger] = @post.errors.full_messages
    render action: :new
  end

  def update
    @post = Post.find params[:id]
    @post.attributes = post_params

    if @post.valid? && @post.save
      flash[:success] = t 'admin/posts.update_success', title: @post.title
      redirect_to [:admins, :posts] and return
    end

    flash.now[:danger] = @post.errors.full_messages
    render action: :edit
  end

  def destroy
    @post = Post.find params[:id]

    if @post.destroy
      flash[:success] = t 'admin/posts.destroy_success', title: @post.title
    end

    redirect_to [:admins, :posts]
  end

  private

  def post_params
    params.require(:post).permit(
      :slug,
      :title,
      :content,
      :published_at,
      upload_ids: []
    )
  end
end
