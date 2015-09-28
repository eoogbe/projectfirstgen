class RaffleEntriesController < ApplicationController
  before_action :prevent_duplicate_entries, only: :create

  def create
    current_user.raffle_entries.create!
    AdminMailer.raffle_entry(current_user).deliver
    redirect_to root_path, notice: "You have been entered into the raffle. Good luck!"
  end

  private

  def prevent_duplicate_entries
    user_not_authorized unless current_user.current_raffle_entry.nil?
  end
end
