module Api
  class ApiBaseController < ActionController::API
    include Trailblazer::Rails::Controller
    include ResponseBuilder
    include ExceptionHelper
    include CanCan::ControllerAdditions

    rescue_from StandardError, with: :handle_exception

    before_action :authenticate_user!
    rescue_from CanCan::AccessDenied, with: :handle_exception

    private

    def params_normalizer
      @params_normalizer ||= Api::ParamsNormalizer.new(params: params)
    end

    def _run_options(options)
      options.merge('current_user' => current_user)
    end

    def run_and_render(*options)
      render_response(run(*options), params)
    end
  end
end
