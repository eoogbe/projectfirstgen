require 'rails_helper'

RSpec.describe RaffleEntriesController do
  Given { sign_in current_user }
  describe "POST #create" do
    context "with response" do
      Given(:current_user) { create(:user) }
      When(:response) { post :create }
      Then { current_user.current_raffle_entry.present? }
      Then { flash.notice.present? }
      Then { expect(response).to redirect_to root_path }
    end
    context "with mail delivery" do
      Given(:current_user) { create(:user, email: "raphael@example.com", username: "UGRAD6") }
      Given do
        expect do
          post :create
        end.to change { ActionMailer::Base.deliveries.size }.by 1
      end
      When(:raffle_entry_email) { ActionMailer::Base.deliveries.last }
      Then { raffle_entry_email.subject == "Raffle entry request" }
      And { raffle_entry_email.to[0] == "nrgracia@stanford.edu" }
      Then { raffle_entry_email.body.encoded =~ /UGRAD6/ }
      Then { raffle_entry_email.body.encoded =~ /raphael@example\.com/ }
    end
  end
end
