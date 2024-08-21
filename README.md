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
    ```bash
   yarn install
    ```
3. 設定資料庫
    ```bash
    rails db:create
    rails db:migrate
    ```
4. 建立資料
    ```bash
    rails db:seed
    ```
5. 啟動rails and yarn
    ```bash
    bin/dev
    ```

## Database Structure

### Extensions
This project uses the following PostgreSQL extension:
- `plpgsql`: Procedural language support for PostgreSQL.

### Tables

#### `notifications`
| Column     | Type                | Description                  |
|------------|--------------------|------------------------------|
| `user_id`  | `bigint` (foreign key) | References the `users` table. |
| `task_id`  | `bigint` (foreign key) | References the `tasks` table. |
| `message`  | `string`            | Notification message.        |
| `read_at`  | `datetime`          | Timestamp when notification was read. |
| `created_at` | `datetime`        | Timestamp when the record was created. |
| `updated_at` | `datetime`        | Timestamp when the record was last updated. |

**Indexes:**
- `index_notifications_on_task_id`
- `index_notifications_on_user_id`

#### `tags`
| Column     | Type        | Description                  |
|------------|-------------|------------------------------|
| `name`     | `string`    | Name of the tag.             |
| `created_at` | `datetime` | Timestamp when the record was created. |
| `updated_at` | `datetime` | Timestamp when the record was last updated. |

#### `task_tags`
| Column     | Type                | Description                  |
|------------|--------------------|------------------------------|
| `task_id`  | `bigint` (foreign key) | References the `tasks` table. |
| `tag_id`   | `bigint` (foreign key) | References the `tags` table. |
| `created_at` | `datetime`        | Timestamp when the record was created. |
| `updated_at` | `datetime`        | Timestamp when the record was last updated. |

**Indexes:**
- `index_task_tags_on_tag_id`
- `index_task_tags_on_task_id`

#### `task_users`
| Column     | Type                | Description                  |
|------------|--------------------|------------------------------|
| `user_id`  | `bigint` (foreign key) | References the `users` table. |
| `task_id`  | `bigint` (foreign key) | References the `tasks` table. |
| `created_at` | `datetime`        | Timestamp when the record was created. |
| `updated_at` | `datetime`        | Timestamp when the record was last updated. |

**Indexes:**
- `index_task_users_on_task_id`
- `index_task_users_on_user_id`

#### `tasks`
| Column     | Type                | Description                  |
|------------|--------------------|------------------------------|
| `title`    | `string`           | Task title.                  |
| `content`  | `text`             | Task content.                |
| `start_time` | `datetime`       | Start time for the task.     |
| `end_time`   | `datetime`       | End time for the task.       |
| `priority`  | `integer` (default: 1, not null) | Task priority (1: low, 2: medium, 3: high). |
| `status`    | `integer` (default: 1, not null) | Task status (1: pending, 2: in progress, 3: completed). |
| `user_id`   | `bigint` (foreign key) | References the `users` table. |
| `created_at` | `datetime`        | Timestamp when the record was created. |
| `updated_at` | `datetime`        | Timestamp when the record was last updated. |
| `deleted_at` | `datetime`        | Soft delete timestamp.       |

**Indexes:**
- `index_tasks_on_deleted_at`
- `index_tasks_on_user_id`

#### `users`
| Column     | Type                | Description                  |
|------------|--------------------|------------------------------|
| `email`    | `string` (default: "", not null) | User email address (must be unique). |
| `created_at` | `datetime`        | Timestamp when the record was created. |
| `updated_at` | `datetime`        | Timestamp when the record was last updated. |
| `password_hash` | `string` (not null) | Hashed password.            |
| `password_salt` | `string` (not null) | Password salt.              |
| `role`     | `string`           | User role (e.g., admin, regular user). |
| `deleted_at` | `datetime`        | Soft delete timestamp.       |
| `avatar`   | `string`           | Path to user avatar.         |

**Indexes:**
- `index_users_on_deleted_at`
- `index_users_on_email` (unique)

### Foreign Keys
- `notifications`: `task_id`, `user_id`
- `task_tags`: `task_id`, `tag_id`
- `task_users`: `task_id`, `user_id`
- `tasks`: `user_id`

---