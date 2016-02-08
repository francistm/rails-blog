module Front
  class SiteController < FrontController
    def index
      render text: 'hello world'
    end
  end
end
