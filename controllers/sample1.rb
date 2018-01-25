class BannersController < ApplicationController
  def index
    process_params!(params)
    render_view :index
  end

  def new
    form Banner::Create
    render_view :new
  end

  def create
    run Banner::Create do
      return redirect_to banners_path, @operation.alerts
    end
    redirect_to :back, @operation.alerts
  end

  def edit
    form Banner::Update
    render_view :edit
  end

  def update
    run Banner::Update do
      return redirect_to banners_path, @operation.alerts
    end
    redirect_to :back, @operation.alerts
  end

  def destroy
    run Banner::Delete
    render json: @operation.alerts
  end

  private

  def render_view(action, options = {})
    render text: concept("banner/cell/#{action}", @model, render_options),
           layout: options.fetch(:layout, true)
  end

  def render_options
    {
      form: @form
    }
  end
end
