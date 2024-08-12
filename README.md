# Task Manager Application

## 專案簡介
這個專案是一個任務管理系統，允許用戶創建、管理和分類他們的任務。

## 技術棧
- Ruby 3.2.0
- Rails 7.1.3
- PostgreSQL

## 安裝指南
1. 克隆專案到本地
    ```bash
    git clone git@github.com:Qkauia/task_management_system.git
    cd task-manager
    ```
2. 安裝依賴
    ```bash
    bundle install
    ```
3. 設定資料庫
    ```bash
    rails db:create
    rails db:migrate
    ```

## Table Schema

### users

| Column                 | Data Type         | Description                                |
|------------------------|-------------------|--------------------------------------------|
| email                  | string            | User's email address, not null, unique     |
| password_hash          | string            | Hashed password for the user, not null     |
| password_salt          | string            | Salt used for hashing the password, not null |
| created_at             | datetime          | Record creation timestamp, not null        |
| updated_at             | datetime          | Record last updated timestamp, not null    |

### tasks
| Column     | Data Type | Description                                                         |
|------------|-----------|---------------------------------------------------------------------|
| title      | string    | Title of the task                                                   |
| content    | text      | Content or description of the task                                  |
| start_time | datetime  | Start time of the task                                              |
| end_time   | datetime  | End time of the task                                                |
| priority   | integer   | Priority of the task (1: low, 2: medium, 3: high)                   |
| status     | integer   | Status of the task (1: pending, 2: in progress, 3: completed)       |
| user_id    | bigint    | ID of the user who created the task, not null                       |
| created_at | datetime  | Record creation timestamp, not null                                 |
| updated_at | datetime  | Record last updated timestamp, not null                             |
| deleted_at | datetime  | Record last deleted timestamp (used for soft delete functionality)  |

### tags
| Column     | Data Type | Description                      |
|------------|-----------|----------------------------------|
| name       | string    | Name of the tag                  |
| created_at | datetime  | Record creation timestamp, not null |
| updated_at | datetime  | Record last updated timestamp, not null |

### task_tags
| Column     | Data Type | Description                      |
|------------|-----------|----------------------------------|
| task_id    | bigint    | ID of the associated task, not null |
| tag_id     | bigint    | ID of the associated tag, not null |
| created_at | datetime  | Record creation timestamp, not null |
| updated_at | datetime  | Record last updated timestamp, not null |

### Indexes
- **users**
  - `index_users_on_email` (unique)
  - `index_users_on_reset_password_token` (unique)

- **tasks**
  - `index_tasks_on_user_id`

- **task_tags**
  - `index_task_tags_on_tag_id`
  - `index_task_tags_on_task_id`

### Foreign Keys
- **task_tags**
  - `tag_id` references `tags`
  - `task_id` references `tasks`

- **tasks**
  - `user_id` references `users`
