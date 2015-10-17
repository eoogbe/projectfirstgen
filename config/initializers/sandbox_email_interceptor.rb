class SandboxEmailInterceptor
  def self.delivering_email message
    message.to = [ENV["EMAIL_INTERCEPTING_RECIPIENT"]]
  end
end

if ENV["EMAIL_INTERCEPTING_RECIPIENT"]
  ActionMailer::Base.register_interceptor(SandboxEmailInterceptor)
end
