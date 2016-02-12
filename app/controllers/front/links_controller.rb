class Front::LinksController < FrontController
  def index
    @links = Link.order(title: :asc).all
  end
end
