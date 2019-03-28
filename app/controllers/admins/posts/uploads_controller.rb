module Admins
  module Posts
    class UploadsController < ::AdminController
      def index
        @post = Post.find params[:post_id]
        @uploads = @post.uploads

        respond_to do |format|
          format.json { render json: @uploads.map(&method(:compose_attachment)) }
        end
      end

      def show
        @upload = ActiveStorage::Blob.find_signed params[:id]

        respond_to do |format|
          format.json { render json: compose_attachment(@upload) }
        end
      end

      def destroy
        @upload = ActiveStorage::Blob.find_signed params[:id]

        @upload.purge_later && head(:no_content)
      end

      private

      def compose_attachment(attachment)
        {}.tap do |h|
          h[:byte_size] = attachment.byte_size
          h[:filename] = attachment.filename
          h[:is_image] = attachment.image?
          h[:signed_id] = attachment.signed_id
          h[:blob_path] = rails_blob_path(attachment)
        end
      end
    end
  end
end
