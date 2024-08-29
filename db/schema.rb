# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 20_240_823_113_613) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'active_storage_attachments', force: :cascade do |t|
    t.string 'name', null: false
    t.string 'record_type', null: false
    t.bigint 'record_id', null: false
    t.bigint 'blob_id', null: false
    t.datetime 'created_at', null: false
    t.index ['blob_id'], name: 'index_active_storage_attachments_on_blob_id'
    t.index %w[record_type record_id name blob_id], name: 'index_active_storage_attachments_uniqueness',
                                                    unique: true
  end

  create_table 'active_storage_blobs', force: :cascade do |t|
    t.string 'key', null: false
    t.string 'filename', null: false
    t.string 'content_type'
    t.text 'metadata'
    t.string 'service_name', null: false
    t.bigint 'byte_size', null: false
    t.string 'checksum'
    t.datetime 'created_at', null: false
    t.index ['key'], name: 'index_active_storage_blobs_on_key', unique: true
  end

  create_table 'active_storage_variant_records', force: :cascade do |t|
    t.bigint 'blob_id', null: false
    t.string 'variation_digest', null: false
    t.index %w[blob_id variation_digest], name: 'index_active_storage_variant_records_uniqueness', unique: true
  end

  create_table 'group_tasks', force: :cascade do |t|
    t.bigint 'group_id', null: false
    t.bigint 'task_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['group_id'], name: 'index_group_tasks_on_group_id'
    t.index ['task_id'], name: 'index_group_tasks_on_task_id'
  end

  create_table 'group_users', force: :cascade do |t|
    t.bigint 'group_id', null: false
    t.bigint 'user_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['group_id'], name: 'index_group_users_on_group_id'
    t.index ['user_id'], name: 'index_group_users_on_user_id'
  end

  create_table 'groups', force: :cascade do |t|
    t.string 'name'
    t.datetime 'deleted_at'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.integer 'user_id'
  end

  create_table 'notifications', force: :cascade do |t|
    t.bigint 'user_id', null: false
    t.bigint 'task_id', null: false
    t.string 'message'
    t.datetime 'read_at'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['task_id'], name: 'index_notifications_on_task_id'
    t.index ['user_id'], name: 'index_notifications_on_user_id'
  end

  create_table 'tags', force: :cascade do |t|
    t.string 'name'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'task_tags', force: :cascade do |t|
    t.bigint 'task_id', null: false
    t.bigint 'tag_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['tag_id'], name: 'index_task_tags_on_tag_id'
    t.index ['task_id'], name: 'index_task_tags_on_task_id'
  end

  create_table 'task_users', force: :cascade do |t|
    t.bigint 'user_id', null: false
    t.bigint 'task_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['task_id'], name: 'index_task_users_on_task_id'
    t.index ['user_id'], name: 'index_task_users_on_user_id'
  end

  create_table 'tasks', force: :cascade do |t|
    t.string 'title'
    t.text 'content'
    t.datetime 'start_time'
    t.datetime 'end_time'
    t.integer 'priority', default: 1, null: false
    t.integer 'status', default: 1, null: false
    t.bigint 'user_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.datetime 'deleted_at'
    t.integer 'position'
    t.boolean 'important'
    t.index ['deleted_at'], name: 'index_tasks_on_deleted_at'
    t.index ['user_id'], name: 'index_tasks_on_user_id'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'email', default: '', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'password_hash', null: false
    t.string 'password_salt', null: false
    t.string 'role'
    t.datetime 'deleted_at'
    t.string 'avatar'
    t.index ['deleted_at'], name: 'index_users_on_deleted_at'
    t.index ['email'], name: 'index_users_on_email', unique: true
  end

  add_foreign_key 'active_storage_attachments', 'active_storage_blobs', column: 'blob_id'
  add_foreign_key 'active_storage_variant_records', 'active_storage_blobs', column: 'blob_id'
  add_foreign_key 'group_tasks', 'groups'
  add_foreign_key 'group_tasks', 'tasks'
  add_foreign_key 'group_users', 'groups'
  add_foreign_key 'group_users', 'users'
  add_foreign_key 'notifications', 'tasks'
  add_foreign_key 'notifications', 'users'
  add_foreign_key 'task_tags', 'tags'
  add_foreign_key 'task_tags', 'tasks'
  add_foreign_key 'task_users', 'tasks'
  add_foreign_key 'task_users', 'users'
  add_foreign_key 'tasks', 'users'
end
