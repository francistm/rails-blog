class Admins::JekyllImportsController < AdminController
  def new
    @jekyll_import = JekyllImport.new
  end

  def create
    @jekyll_import = JekyllImport.new jekyll_import_params

    if @jekyll_import.valid?
      post = Post.new admin: current_admin
      post.attributes = @jekyll_import.parse

      if post.valid? && post.save
        flash[:success] = t 'admin/jekyll_imports.create_success', title: post.title
        redirect_to [:admins, :posts] and return
      end
    end

    flash.now[:danger] = @jekyll_import.errors.full_messages
    render action: :new
  end

  private

  def jekyll_import_params
    params.require(:jekyll_import).permit(:post)
  end
end
