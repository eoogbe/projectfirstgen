class RaffleEntriesController < ApplicationController
  def create
    unless current_user.current_raffle_entry.nil?
      return redirect_to root_path, alert: "You cannot perform that action"
    end

    current_user.raffle_entries.create!
    AdminMailer.raffle_entry(current_user).deliver_later
    redirect_to root_path, notice: "You have been entered into the raffle. Good luck!"
  end
end
