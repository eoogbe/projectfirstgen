require 'rails_helper'

RSpec.describe RaffleEntriesController do
  Given { sign_in current_user }
  describe "POST #create" do
    context "with response" do
      Given(:current_user) { create(:user) }
      Given!(:response) do
        res = nil
        expect do
          res = post :create
        end.to change { current_user.raffle_entries.count }.by 1
        res
      end
      Then { flash.notice.present? }
      And { expect(response).to redirect_to root_path }
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
