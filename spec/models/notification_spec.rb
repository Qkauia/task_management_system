# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Notification, type: :model do
  let(:user) { create(:user) }
  let(:task) { create(:task) }
  let(:notification) { create(:notification, user: user, task: task) }

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:task).optional }
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(notification).to be_valid
    end

    it 'is not valid without a user' do
      notification.user = nil
      expect(notification).not_to be_valid
      expect(notification.errors[:user]).to include('must exist')
    end
  end

  describe 'scopes' do
    describe '.unread' do
      let!(:unread_notification) { create(:notification, read_at: nil) }
      let!(:read_notification) { create(:notification, read_at: Time.current) }

      it 'returns only unread notifications' do
        expect(Notification.unread).to include(unread_notification)
        expect(Notification.unread).not_to include(read_notification)
      end
    end

    describe '.old' do
      let!(:old_notification) { create(:notification, created_at: 10.days.ago) }
      let!(:recent_notification) { create(:notification, created_at: 1.day.ago) }

      it 'returns notifications older than the specified number of days' do
        expect(Notification.old(7)).to include(old_notification)
        expect(Notification.old(7)).not_to include(recent_notification)
      end
    end
  end
end
