# frozen_string_literal: true

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
      redirect_to(%i[admins posts]) && return
    end

    flash.now[:danger] = @post.errors.full_messages
    render action: :new
  end

  def update
    @post = Post.find params[:id]
    @post.attributes = post_params

    if @post.valid? && @post.save
      flash[:success] = t 'admin/posts.update_success', title: @post.title
      redirect_to(%i[admins posts]) && return
    end

    flash.now[:danger] = @post.errors.full_messages
    render action: :edit
  end

  def destroy
    @post = Post.find params[:id]

    if @post.destroy
      flash[:success] = t 'admin/posts.destroy_success', title: @post.title
    end

    redirect_to %i[admins posts]
  end

  def index_uploads
    @post = Post.find params[:post_id]
    @attachments = @post.uploads.map(&method(:compose_upload))

    respond_to do |format|
      format.json { render json: @attachments }
    end
  end

  def destroy_uploads
    @active_storage_instance = GlobalID::Locator.locate_signed params[:signed_gid]

    if @active_storage_instance.nil?
      head :not_found
    else
      @active_storage_instance.purge_later && head(:no_content)
    end
  end

  def retrieve_upload_blob
    @blob = ActiveStorage::Blob.find_signed params[:signed_id]

    respond_to do |format|
      format.json { render json: compose_upload(@blob) }
    end
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

  def compose_upload(upload)
    {}.tap do |h|
      h[:is_image] = upload.image?
      h[:byte_size] = upload.byte_size
      h[:filename] = upload.filename
      h[:signed_id] = upload.signed_id
      h[:signed_gid] = upload.to_sgid.to_s
      h[:blob_path] = rails_blob_path(upload)
      h[:class_name] = upload.class.name
    end
  end
end
