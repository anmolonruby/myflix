def set_current_user(user=nil)
  session[:user_id] = (user || Fabricate(:user)).id
end

def set_admin(user=nil)
  session[:user_id] = (user || Fabricate(:user, admin: true)).id
end

def current_user
  User.find(session[:user_id])
end

def sign_in(a_user=nil)
  user = a_user || Fabricate(:user)
  visit sign_in_path
  fill_in "email", with: user.email
  fill_in "password", with: user.password
  click_button "Sign In"
end

def sign_out
  visit sign_out_path
end

def click_on_video_on_home_page(video)
  find("a[href='/videos/#{video.id}']").click
end