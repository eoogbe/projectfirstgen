require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "undergrad_reminder" do
    Given(:user) { build(:user, email: "nelle_mckenzie@example.net", name: "Bennie Stracke") }
    Given { create(:article, title: "Rerum") }
    When(:mail) { UserMailer.undergrad_reminder(user) }
    Then { mail.subject == "Project First-Gen Newsletter" }
    Then { mail.to == ["nelle_mckenzie@example.net"] }
    Then { mail.from == ["projectfirstgen@gmail.com"] }
    context "with body" do
      When(:body) { mail.body.encoded }
      Then { body =~ /Bennie Stracke/ }
      Then { body =~ /3 more questions/ }
      Then { body =~ /Rerum/ }
    end
  end

  describe "grad_reminder" do
    Given(:user) { build(:grad, email: "julianne@example.com", name: "Denis Hamill") }
    When(:mail) { UserMailer.grad_reminder(user) }
    Then { mail.subject == "Project First-Gen Newsletter" }
    Then { mail.to == ["julianne@example.com"] }
    Then { mail.from == ["projectfirstgen@gmail.com"] }
    context "with body" do
      When(:body) { mail.body.encoded }
      Then { body =~ /Denis Hamill/ }
      Then { body =~ /3 more blogs/ }
    end
  end

  describe "control_reminder" do
    Given(:user) { build(:control, email: "josie@example.org", name: "Leann Greenholt") }
    When(:mail) { UserMailer.control_reminder(user) }
    Then { mail.subject == "Project First-Gen Newsletter" }
    Then { mail.to == ["josie@example.org"] }
    Then { mail.from == ["projectfirstgen@gmail.com"] }
    context "with body" do
      When(:body) { mail.body.encoded }
      Then { body =~ /Leann Greenholt/ }
      Then { body =~ /3 more questions/ }
    end
  end
end
