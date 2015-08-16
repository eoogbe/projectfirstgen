require 'rails_helper'

RSpec.describe AdminMailer do
  describe "raffle_entry" do
    Given(:user) { build(:user, email: "keaton.ernser@example.org", username: "GRAD2") }
    When(:mail) { AdminMailer.raffle_entry(user) }
    Then { mail.subject == "Raffle entry request" }
    Then { mail.to == ["nrgracia@stanford.edu"] }
    Then { mail.from == ["projectfirstgen@gmail.com"] }
    context "with body" do
      When(:body) { mail.body.encoded }
      Then { body =~ /GRAD2/ }
      Then { body =~ /keaton\.ernser@example\.org/ }
    end
  end

  describe "unanswered_notification" do
    Given { Timecop.freeze(Time.local(2015, 8, 16, 14, 9)) }
    Given(:user) { build(:user, username: "GRAD7") }
    Given(:article) { build(:article, title: "Incredible Wooden Chair") }
    Given do
      create(:comment, article: article, author: user,
        text: "Temporibus aut adipisci commodi voluptas omnis.")
    end
    When(:mail) { AdminMailer.unanswered_notification(Comment.all) }
    Then { mail.subject == "1 question is unanswered" }
    Then { mail.to == ["nrgracia@stanford.edu"] }
    Then { mail.from == ["projectfirstgen@gmail.com"] }
    context "with body" do
      When(:body) { mail.body.encoded }
      Then { body =~ /GRAD7/ }
      Then { body =~ /Incredible Wooden Chair/ }
      Then { body =~ /August 16, 2015 14:09/ }
      Then { body =~ /Temporibus aut adipisci commodi voluptas omnis./ }
    end
  end
end
