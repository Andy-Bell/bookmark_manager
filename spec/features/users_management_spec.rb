feature 'User sign up' do
  scenario 'I can sign up as a new user' do
    expect { sign_up }.to change(User, :count).by(1)
    expect(page).to have_content("Welcome, alice@example.com")
    expect(User.first.email).to eq ('alice@example.com')
  end

  scenario 'Requires a matching confirmation password' do
    expect { sign_up(password_confirmation: 'wrong') }.not_to change(User, :count)
  end

  scenario 'With a password that doesn\'t match' do
    expect { sign_up(password_confirmation: 'wrong') }.not_to change(User, :count)
    expect(current_path).to eq("/users")
    expect(page).to have_content 'Password does not match the confirmation'
  end

  scenario 'I can\'t sign up without an email address' do
    expect { sign_up(email: nil) }.not_to change(User, :count)
  end
  
  scenario "I can't sign up with an invalid email address" do
    expect { sign_up(email: "invalid@error") }.not_to change(User, :count)
  end
  
  scenario "I can't sign up with an existing email address" do
    sign_up
    expect { sign_up }.not_to change(User, :count)
    expect(page).to have_content("Email is already taken")
  end
end
