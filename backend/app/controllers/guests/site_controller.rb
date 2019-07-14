# frozen_string_literal: true

class Guests::SiteController < GuestController
  def feed
    feed_output_count = SiteSetting.feed_output_count

    @posts = Post
             .includes(:admin)
             .order(published_at: :desc)
             .limit(feed_output_count).all

    respond_to do |format|
      format.xml
    end
  end

  def index
    @post_count = Post.all.count
  end
end
