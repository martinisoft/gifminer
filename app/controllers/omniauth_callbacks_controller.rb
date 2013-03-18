class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # TODO: DRY
  def tumblr
    auth = request.env["omniauth.auth"]
    Rails.logger.debug auth.to_yaml
    @user = User.find_by_auth(auth, current_user)

    if @user.persisted?
      auth["info"]["blogs"].map do |blog|
        Site.create(
          user_id: @user.id,
          name: blog["name"],
          url: blog["url"],
          avatar: auth["info"]["avatar"],
          public: false,
          post: false,
          token: auth["credentials"]["token"],
          secret: auth["credentials"]["secret"]
        )
      end

      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "Tumblr") if is_navigational_format?
    else
      session["devise.tumblr_data"] = auth
      redirect_to new_user_registration_url
    end
  end

  def google_oauth2
    auth = request.env["omniauth.auth"]
    Rails.logger.debug auth.to_yaml
    @user = User.find_by_auth(auth, current_user)

    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "Google") if is_navigational_format?
    else
      session["devise.google_oauth2_data"] = auth
      redirect_to new_user_registration_url
    end
  end

  def facebook
    auth = request.env["omniauth.auth"]
    Rails.logger.debug auth.to_yaml
    @user = User.find_by_auth(auth, current_user)

    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = auth
      redirect_to new_user_registration_url
    end
  end


end