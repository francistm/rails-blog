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

  def show_uploads
    @upload = ActiveStorage::Blob.find_signed params[:signed_id]

    respond_to do |format|
      format.json { render json: compose_attachment(@upload) }
    end
  end

  def index_uploads
    @post = Post.find params[:post_id]
    @uploads = @post.uploads

    respond_to do |format|
      format.json { render json: @uploads.map(&method(:compose_attachment)) }
    end
  end

  def destroy_uploads
    if params[:id]
      ActiveStorage::Attachment.find(params[:id]).try(:purge_later)
    elsif params[:signed_id]
      ActiveStorage::Blob.find_signed(params[:signed_id]).try(:purge_later)
    end

    head :no_content
  end

  private

  def post_params
    params.require(:post).permit(
      :slug,
      :title,
      :content,
      :published_at,
      uploads: []
    )
  end

  def compose_attachment(attachment)
    {}.tap do |h|
      h[:id] = attachment.id
      h[:byte_size] = attachment.byte_size
      h[:filename] = attachment.filename
      h[:is_image] = attachment.image?
      h[:signed_id] = attachment.signed_id
      h[:blob_path] = rails_blob_path(attachment)
    end
  end
end
