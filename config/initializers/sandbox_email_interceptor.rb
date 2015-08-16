class SandboxEmailInterceptor
  def self.delivering_email message
    message.to = ["eoogbe@stanford.edu"]
  end
end

if %w(development staging).include?(Rails.env)
  ActionMailer::Base.register_interceptor(SandboxEmailInterceptor)
end
