# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'validates presence of email' do
      user = FactoryBot.build(:user, email: nil)
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include(I18n.t('users.form.cannot_be_blank'))
    end

    it 'validates uniqueness of email' do
      existing_user = FactoryBot.create(:user, email: 'test@example.com')
      new_user = FactoryBot.build(:user, email: existing_user.email)
      expect(new_user).not_to be_valid
      expect(new_user.errors[:email]).to include(I18n.t('users.form.already_been_taken'))
    end
  end

  describe 'callbacks' do
    it 'encrypts the password before saving' do
      user = FactoryBot.build(:user, password: 'newpassword')
      user.save
      expect(user.password_hash).not_to be_nil
      expect(user.password_hash).not_to eq('newpassword')
    end

    it 'sets the default role to user if not specified' do
      user = FactoryBot.create(:user, role: nil)
      expect(user.role).to eq('user')
    end
  end

  describe 'associations' do
    it 'has many tasks' do
      assoc = described_class.reflect_on_association(:tasks)
      expect(assoc.macro).to eq :has_many
    end
  end

  describe '#authenticate' do
    it 'returns true if the password is correct' do
      user = FactoryBot.create(:user, password: 'password')
      expect(user.authenticate('password')).to be true
    end

    it 'returns false if the password is incorrect' do
      user = FactoryBot.create(:user, password: 'password')
      expect(user.authenticate('wrongpassword')).to be false
    end
  end

  describe 'soft delete' do
    it 'marks the user as deleted without actually removing the record' do
      user = FactoryBot.create(:user)
      user.destroy
      expect(described_class.only_deleted.find_by(id: user.id)).not_to be_nil
    end

    it 'does not include deleted users in default queries' do
      user = FactoryBot.create(:user)
      user.destroy
      expect(described_class.find_by(id: user.id)).to be_nil
    end
  end
end
