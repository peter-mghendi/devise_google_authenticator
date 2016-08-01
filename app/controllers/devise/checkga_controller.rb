class Devise::CheckgaController < Devise::SessionsController
  prepend_before_filter :devise_resource, :only => [:show]
  prepend_before_filter :require_no_authentication, :only => [ :show, :update ]

  include Devise::Controllers::Helpers

  def show
    @tmpid = params[:id]
    if @tmpid.nil?
      redirect_to :root
    else
      render :show
    end
  end

  def update
    resource = resource_class.find_by_gauth_tmp(params[resource_name]['tmpid'])

    if not resource.nil?
      if resource.validate_token(params[resource_name]['gauth_token'].to_i)
        set_flash_message(:notice, :signed_in) if is_navigational_format?
        sign_in(resource_name,resource)
        warden.manager._run_callbacks(:after_set_user, resource, warden, {:event => :authentication})
        respond_with resource, :location => after_sign_in_path_for(resource)

        set_remember_token(resource) if params[resource_name]['remember_gauth_token'] == '1'
      else
        set_flash_message(:error, :error)
        redirect_to send(devise_resource_sign_in_path)
      end

    else
      set_flash_message(:error, :error)
      redirect_to :root
    end
  end

  private

  def devise_resource
    self.resource = resource_class.new
  end

  def devise_resource_sign_in_path
    "new_#{resource_name}_session_path"
  end

  def set_remember_token(resource)
    if resource.set_remember_gauth_token_set_at
      cookies.signed[:gauth] = {
        value: resource.email << ',' << Time.now.to_i.to_s,
        secure: !(Rails.env.test? || Rails.env.development?),
        expires: 1.day.from_now
      }
    end
  end
end
