# frozen_string_literal: true

class Admins::LinksController < AdminController
  def new
    @link = Link.new
  end

  def edit
    @link = Link.find params[:id]
  end

  def index
    @links = Link.order(id: :desc).all
  end

  def create
    @link = Link.new link_params

    if @link.valid? && @link.save
      flash[:success] = t 'admin/links.create_success', title: @link.title
      redirect_to(%i[admins links]) && return
    end

    flash.now[:danger] = @link.errors.full_messages
    render action: :new
  end

  def update
    @link = Link.find params[:id]
    @link.attributes = link_params

    if @link.valid? && @link.save
      flash[:success] = t 'admin/links.update_success', title: @link.title
      redirect_to(%i[admins links]) && return
    end

    flash.now[:danger] = @link.errors.full_messages
    render action: :edit
  end

  def destroy
    @link = Link.find params[:id]

    if @link.destroy
      flash[:success] = t 'admin/links.destroy_success', title: @link.title
    end

    redirect_to %i[admins links]
  end

  private

  def link_params
    params.require(:link).permit(
      :url,
      :title,
      :description
    )
  end
end
