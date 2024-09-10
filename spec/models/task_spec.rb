# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:user) { create(:user) }
  let(:group) { create(:group, user:) }
  let(:task) { create(:task, user:, group:) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(task).to be_valid
    end

    it 'is not valid without a title' do
      task.title = nil
      expect(task).not_to be_valid
      expect(task.errors[:title]).to include(I18n.t('errors.messages.blank'))
    end

    it 'is not valid without content' do
      task.content = nil
      expect(task).not_to be_valid
      expect(task.errors[:content]).to include(I18n.t('errors.messages.blank'))
    end

    it 'is not valid with start_time greater than or equal to end_time' do
      task.start_time = 2.days.from_now
      task.end_time = 1.day.from_now
      expect(task).not_to be_valid
      expect(task.errors[:start_time]).to include(I18n.t('tasks.errors.start_time_greater_than_end_time'))
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:author).class_name('User') }
    it { is_expected.to belong_to(:group).optional }
    it { is_expected.to have_many(:task_users).dependent(:destroy) }
    it { is_expected.to have_many(:shared_users).through(:task_users).source(:user) }
    it { is_expected.to have_many(:tags).through(:task_tags) }
  end

  describe 'scopes' do
    let!(:task_high_priority) { create(:task, user:, priority: :high) }
    let!(:task_low_priority) { create(:task, user:, priority: :low) }

    describe '.filtered_by_status' do
      it 'returns tasks with the specified status' do
        task_in_progress = create(:task, user:, status: :in_progress)
        result = Task.filtered_by_status('in_progress')
        expect(result).to include(task_in_progress)
        expect(result).not_to include(task_high_priority)
      end
    end

    describe '.filtered_by_query' do
      let!(:task1) { create(:task, title: 'Learn Rails') }
      let!(:task2) { create(:task, title: 'Learn Ruby') }
      let!(:task3) { create(:task, title: 'Learn JavaScript') }

      it 'returns tasks that match the query in the title' do
        result = Task.filtered_by_query('Rails')
        expect(result).to include(task1)
        expect(result).not_to include(task2, task3)
      end

      it 'returns all tasks if query is blank' do
        result = Task.filtered_by_query('')
        expect(result).to include(task1, task2, task3)
      end
    end

    describe '.ordered_by' do
      before do
        Task.delete_all
      end

      let!(:task1) { create(:task, title: 'A Task', priority: :high) }
      let!(:task2) { create(:task, title: 'B Task', priority: :low) }

      it 'orders tasks by the given column and direction (ascending)' do
        result = Task.ordered_by(:title, :asc)
        expect(result.pluck(:title)).to eq(['A Task', 'B Task'])
      end

      it 'orders tasks by the given column and direction (descending)' do
        result = Task.ordered_by(:title, :desc)
        expect(result.pluck(:title)).to eq(['B Task', 'A Task'])
      end
    end

    describe 'default scope' do
      before do
        Task.delete_all
      end
      let!(:task1) { create(:task, title: 'Test Task 1', position: 2) }
      let!(:task2) { create(:task, title: 'Test Task 2', position: 1) }

      it 'orders tasks by position ascending by default' do
        result = Task.all
        expect(result).to eq([task2, task1])
      end
    end

    describe '.filter_by_tag' do
      let!(:tag1) { create(:tag, name: 'Work') }
      let!(:tag2) { create(:tag, name: 'Home') }
      let!(:task1) { create(:task, tags: [tag1]) }
      let!(:task2) { create(:task, tags: [tag2]) }

      it 'returns tasks with the specified tag' do
        result = Task.filter_by_tag(tag1.id)
        expect(result).to include(task1)
        expect(result).not_to include(task2)
      end
    end

    describe '.important' do
      let!(:important_task) { create(:task, important: true) }
      let!(:normal_task) { create(:task, important: false) }

      it 'returns only tasks marked as important' do
        result = Task.important
        expect(result).to include(important_task)
        expect(result).not_to include(normal_task)
      end
    end

    describe '.sorted' do
      it 'returns tasks sorted by priority and start_time' do
        expect(Task.sorted).to eq([task_high_priority, task_low_priority])
      end
    end

    describe '.owned_and_shared_by' do
      let!(:user) { create(:user) }
      let!(:task) { create(:task, user:) }
      let!(:shared_task) { create(:task) }
      let!(:task_user) { create(:task_user, task: shared_task, user:) }

      it 'returns tasks owned or shared with the specified user' do
        result = Task.owned_and_shared_by(user)
        expect(result).to include(task, shared_task)
      end
    end
  end

  describe '#human_priority' do
    it 'returns the human-readable version of priority' do
      expect(task.human_priority).to eq(I18n.t('enums.task.priority.medium'))
    end
  end

  describe '#human_status' do
    it 'returns the human-readable version of status' do
      expect(task.human_status).to eq(I18n.t('enums.task.status.pending'))
    end
  end

  describe '#shared_count' do
    context 'when the task belongs to multiple groups' do
      let(:author) { create(:user) }
      let(:group1) { create(:group, user: author) }
      let(:group2) { create(:group, user: author) }
      let(:task) { create(:task, groups: [group1, group2], user: author) }
      let(:other_user1) { create(:user) }
      let(:other_user2) { create(:user) }

      before do
        group1.users << other_user1
        group2.users << other_user2
      end

      it 'returns the total number of users across all groups excluding the author' do
        expect(task.shared_count).to eq(2)
      end
    end
  end
end
