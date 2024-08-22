# Task Manager Application

## Project Overview
This project is a task management system that allows users to create, manage, and categorize their tasks, with support for group functionality and a notification system.

## Tech Stack
- Ruby 3.2.0
- Rails 7.1.3
- PostgreSQL

## Installation Guide
1. Clone the project locally:
    ```bash
    git clone git@github.com:Qkauia/task_management_system.git
    cd task-manager
    ```
2. Install dependencies:
    ```bash
    bundle install
    yarn install
    ```
3. Set up the database:
    ```bash
    rails db:create
    rails db:migrate
    ```
4. Seed the database:
    ```bash
    rails db:seed
    ```
5. Start the server:
    ```bash
    bin/dev
    ```

## Database Structure

### Extensions
This project uses the following PostgreSQL extension:
- `plpgsql`: Procedural language support for PostgreSQL.

### Tables

#### `groups`
| Column     | Type                | Description                  |
|------------|--------------------|------------------------------|
| `id`       | `bigint`            | Primary key.                 |
| `name`     | `string`           | Group name.                  |
| `user_id`  | `integer`          | Creator (Group Leader).      |
| `deleted_at` | `datetime`       | Soft delete timestamp.       |
| `created_at` | `datetime`       | Timestamp when the record was created. |
| `updated_at` | `datetime`       | Timestamp when the record was last updated. |

#### `group_users`
| Column     | Type                | Description                  |
|------------|--------------------|------------------------------|
| `group_id` | `bigint` (foreign key) | References the `groups` table. |
| `user_id`  | `bigint` (foreign key) | References the `users` table. |
| `created_at` | `datetime`       | Timestamp when the record was created. |
| `updated_at` | `datetime`       | Timestamp when the record was last updated. |

**Indexes:**
- `index_group_users_on_group_id`
- `index_group_users_on_user_id`

**Associations:**
- `belongs_to :group`
- `belongs_to :user`

#### `group_tasks`
| Column     | Type                | Description                  |
|------------|--------------------|------------------------------|
| `group_id` | `bigint` (foreign key) | References the `groups` table. |
| `task_id`  | `bigint` (foreign key) | References the `tasks` table. |
| `created_at` | `datetime`       | Timestamp when the record was created. |
| `updated_at` | `datetime`       | Timestamp when the record was last updated. |

**Indexes:**
- `index_group_tasks_on_group_id`
- `index_group_tasks_on_task_id`

**Associations:**
- `belongs_to :group`
- `belongs_to :task`

#### `tasks`
| Column     | Type                | Description                  |
|------------|--------------------|------------------------------|
| `title`    | `string`           | Task title.                  |
| `content`  | `text`             | Task content.                |
| `start_time` | `datetime`       | Start time for the task.     |
| `end_time` | `datetime`         | End time for the task.       |
| `priority` | `integer` (default: 1, not null) | Task priority (1: low, 2: medium, 3: high). |
| `status`   | `integer` (default: 1, not null) | Task status (1: pending, 2: in progress, 3: completed). |
| `user_id`  | `bigint` (foreign key) | References the `users` table. |
| `deleted_at` | `datetime`       | Soft delete timestamp.       |
| `created_at` | `datetime`       | Timestamp when the record was created. |
| `updated_at` | `datetime`       | Timestamp when the record was last updated. |

**Indexes:**
- `index_tasks_on_deleted_at`
- `index_tasks_on_user_id`

#### `users`
| Column     | Type                | Description                  |
|------------|--------------------|------------------------------|
| `email`    | `string` (default: "", not null) | User email address (must be unique). |
| `password_hash` | `string` (not null) | Hashed password.            |
| `password_salt` | `string` (not null) | Password salt.              |
| `role`     | `string`           | User role (e.g., admin, regular user). |
| `avatar`   | `string`           | Path to user avatar.         |
| `deleted_at` | `datetime`       | Soft delete timestamp.       |
| `created_at` | `datetime`       | Timestamp when the record was created. |
| `updated_at` | `datetime`       | Timestamp when the record was last updated. |

**Indexes:**
- `index_users_on_deleted_at`
- `index_users_on_email` (unique)

### Foreign Keys
- `group_tasks`: `group_id`, `task_id`
- `group_users`: `group_id`, `user_id`
- `tasks`: `user_id`
- `notifications`: `user_id`, `task_id`
- `task_tags`: `task_id`, `tag_id`
- `task_users`: `task_id`, `user_id`
