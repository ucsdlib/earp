def set_current_user(user=nil)
  user = User.find_or_create_for_developer(nil)
  session[:user_id] = user.uid
end

# sign in as a developer
def sign_in_developer
  visit new_session_path
end

# sign out as a developer
def sign_out_developer
  visit new_session_path
end

def mock_valid_library_administrator
  allow(User).to receive(:administrator?).and_return('')
end
