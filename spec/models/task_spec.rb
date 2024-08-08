require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:user) { create(:user) }
  let(:task) { build(:task, user: user) }

  it 'has a valid factory' do
    expect(task).to be_valid
  end

  it 'is invalid without a title' do
    task.title = nil
    expect(task).not_to be_valid
  end

  it 'is invalid without a user' do
    task.user = nil
    expect(task).not_to be_valid
  end

  it 'is invalid without a priority' do
    task.priority = nil
    expect(task).not_to be_valid
  end

  it 'is invalid without a status' do
    task.status = nil
    expect(task).not_to be_valid
  end

  it 'can have a low priority' do
    task.priority = :low
    expect(task).to be_valid
  end

  it 'can have a high priority' do
    task.priority = :high
    expect(task).to be_valid
  end

  it 'can have a pending status' do
    task.status = :pending
    expect(task).to be_valid
  end

  it 'can have a completed status' do
    task.status = :completed
    expect(task).to be_valid
  end
end
