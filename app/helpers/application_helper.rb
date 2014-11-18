module ApplicationHelper
  def show_flash(options = {})
    output = ActiveSupport::SafeBuffer.new

    [:success, :error, :notice, :alert].each do |message|
      output << content_tag(:p, class: ["flash-#{message.to_s}", options[:class]], tabindex: '0') do
        flash[message]
      end if flash[message].present?

      flash[message] = nil
    end

    output
  end
end
