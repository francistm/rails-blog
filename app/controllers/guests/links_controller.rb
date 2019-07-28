# frozen_string_literal: true

class Guests::LinksController < GuestController
  def index
    @links = Link.order(title: :asc).all
  end
end
