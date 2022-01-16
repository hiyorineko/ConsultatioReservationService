module ControllerMacros
  def login(user)
    @request.env["devise.mapping"] = Devise.mappings[:user]
    user.confirm
    sign_in user
  end
  def login_expert(expert)
    @request.env["devise.mapping"] = Devise.mappings[:expert]
    expert.confirm
    sign_in expert
  end
  def login_admin(admin)
    @request.env["devise.mapping"] = Devise.mappings[:admin]
    admin.confirm
    sign_in admin
  end
end
