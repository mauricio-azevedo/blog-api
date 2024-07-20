class CustomFailureApp < Devise::FailureApp
  def respond
    if request.format.json?
      json_error_response
    else
      super
    end
  end

  def json_error_response
    self.status = 401
    self.content_type = 'application/json'
    self.response_body = render_to_string(template: 'shared/response', formats: [:json])
  end

  private

  def render_to_string(template:, formats:)
    controller = ActionController::Base.new
    controller.instance_variable_set(:@ok, false)
    controller.instance_variable_set(:@message, i18n_message)
    controller.render_to_string(template: template, formats: formats)
  end
end