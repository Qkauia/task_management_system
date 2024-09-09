# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }
  let(:existing_user) { create(:user, email: 'test@example.com') }

  describe 'associations' do
    it { should have_many(:tasks).dependent(:destroy) }
    it { should have_many(:notifications).dependent(:destroy) }
    it { should have_many(:task_users).dependent(:destroy) }
    it { should have_many(:shared_tasks).through(:task_users) }
  end

  describe 'validations' do
    it 'valid with valid attributes' do
      expect(user).to be_valid
    end

    it 'validates presence of email' do
      user.email = nil
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include(I18n.t('users.form.cannot_be_blank'))
    end

    it 'validates uniqueness of email' do
      new_user = build(:user, email: existing_user.email)
      expect(new_user).not_to be_valid
      expect(new_user.errors[:email]).to include(I18n.t('users.form.already_been_taken'))
    end
  end

  describe 'password encryption' do
    it 'generates a password hash using the password salt' do
      expect(user.password_hash).to eq(Digest::SHA2.hexdigest("password#{user.password_salt}"))
    end

    it 'authenticates the user with the correct password' do
      user = create(:user, password: '123456', password_confirmation: '123456')
      expect(user.authenticate('123456')).to be_truthy
    end

    it 'User is authenticated using incorrect password' do
      expect(user.authenticate('wrongpassword')).to be_falsey
    end
  end

  describe 'enums' do
    it 'defines the correct roles' do
      expect(User.roles).to eq({ 'user' => 'user', 'admin' => 'admin' })
    end
  end

  describe '#set_default_role' do
    let(:user) { build(:user, role: nil) }
    it 'sets the default role to user' do
      user.save
      expect(user.role).to eq('user')
    end
  end

  describe 'scope' do
    let!(:user1) { create(:user, email: 'user1@example.com') }
    let!(:user2) { create(:user, email: 'user2@example.com') }

    context '#excluding_current_user' do
      it 'returns all users excluding the current user' do
        result = described_class.excluding_current_user(user1)
        expect(result).to match_array([user2])
      end
    end

    context '#filtered_by_query' do
      it 'When searching using public keywords' do
        result = described_class.filtered_by_query('user')
        expect(result).to match_array([user1, user2])
      end

      it 'When specifying a single user' do
        result = described_class.filtered_by_query('user1')
        expect(result).to match_array([user1])
        expect(result).not_to include(user2)
      end

      it 'When no keyword is entered' do
        result = described_class.filtered_by_query('')
        expect(result).to match_array([user1, user2])
      end
    end
  end
end
