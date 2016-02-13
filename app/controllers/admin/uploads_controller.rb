class Admin::UploadsController < AdminController
  def new
    @upload = Upload.new
  end

  def show
    @upload = Upload.includes(:admin, :attachable).find params[:id]
  end

  def create
    @upload = Upload.new
    @upload.admin = current_admin
    @upload.attributes = upload_params

    if @upload.valid? && @upload.save
      flash[:success] = t 'admin/uploads.create_success', filename: @upload.file_file_name
      redirect_to [:admin, :uploads] and return
    end

    render action: :new
  end

  def index
    @uploads = Upload.includes(:admin, :attachable).order(created_at: :desc).all
  end

  def destroy
    @upload = Upload.find params[:id]
    @filename = @upload.file_file_name

    if @upload.destroy
      flash[:success] = t 'admin/uploads.destroy_success', filename: @filename
    end

    redirect_to [:admin, :uploads] and return
  end

  private

  def upload_params
    params.require(:upload).permit(:file)
  end
end
