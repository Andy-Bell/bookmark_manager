feature 'user signup' do
	scenario 'I can sign up as a new user' do
		expect { sign_up }.to change(User, :count).by 1
		expect(page).to have_content('Welcome, alice@example.com')
		expect(User.first.email).to eq('alice@example.com')
	end

	scenario 'requires matching confirmation password' do
		expect { sign_up(password_confirmation: 'wrong') }.not_to change(User, :count)
		expect(current_path).to eq('/users')
		expect(page).to have_content 'Password does not match the confirmation'
	end

	scenario "I can't sign up without an email address" do
		expect { sign_up(email: nil) }.not_to change(User, :count)
	end

	scenario "I can't sign up with an invalid email address" do
		expect { sign_up(email: 'invalid@email') }.not_to change(User, :count)
	end

	scenario 'I cannot sign up with an existing email address' do
		sign_up
		expect { sign_up }.not_to change(User, :count)
		expect(page).to have_content('Email is already taken')
	end
end

feature 'user sign in' do
	let!(:user) do
		User.create(email: 'user@example.com',
								password: 'secret1234',
								password_confirmation: 'secret1234')
	end

	scenario 'with correct credentials' do
		sign_in(email: user.email, password: user.password)
		expect(page).to have_content "Welcome, #{user.email}"
	end
end

