require 'rails_helper'

RSpec.describe TaskTag, type: :model do
  let(:task) { create(:task) }
  let(:tag) { create(:tag) }
  let(:task_tag) { create(:task_tag, task: task, tag: tag) }

  it 'has a valid factory' do
    expect(task_tag).to be_valid
  end

  it 'is invalid without a task' do
    task_tag.task = nil
    expect(task_tag).not_to be_valid
  end

  it 'is invalid without a tag' do
    task_tag.tag = nil
    expect(task_tag).not_to be_valid
  end
end
