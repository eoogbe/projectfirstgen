class RegistrationsController < Devise::RegistrationsController
  def create
    build_resource(sign_up_params)

    if params[:program] == "admin"
      return redirect_to new_user_registration_path, alert: "You cannot perform that action"
    end

    resource.role = params[:program]
    resource.role = :control if resource.undergrad? && rand >= 0.5

    if params[:school] && resource.save
      set_flash_message :notice, :signed_up if is_flashing_format?
      sign_up(resource_name, resource)
      location = ENV["#{params[:school]}_#{params[:program]}_SURVEY_PATH".upcase]
      respond_with resource, location: location
    else
      clean_up_passwords resource
      set_minimum_password_length
      resource.errors[:base] << "School can't be blank" if params[:school].nil?
      respond_with resource
    end
  end
end
