# frozen_string_literal: true

class GroupTask < ApplicationRecord
  belongs_to :group
  belongs_to :task
end
