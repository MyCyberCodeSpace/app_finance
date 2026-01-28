# Finance Control

A simple and intuitive app to manage your personal finances. Built with Flutter, it allows you to track income, expenses, financial goals and more, all offline on your device.

## About the App

Finance Control was born from the need to have practical financial control without depending on online services. With it you can:

- Record all your financial transactions (income, expenses and investments)
- Categorize your spending and earnings by type
- Track your balance in real time
- Create savings goals and track progress
- Manage recurring expenses (credit card, fixed bills, installments)
- Filter and view your data by category and period
- Store everything locally on your phone with SQLite

## Screenshots

_Coming soon - Screenshots will be added here_

## Database Structure

### Table: finance_records
Stores all financial transactions.

| Field                | Type       | Description                                  |
|---------------------|------------|----------------------------------------------|
| `id`                | INTEGER    | Unique identifier                            |
| `date`              | TEXT       | Transaction date                             |
| `value`             | REAL       | Transaction value                            |
| `type_id`           | INTEGER    | Type reference (FK)                          |
| `description`       | TEXT       | Optional description                         |
| `payment_id`        | INTEGER    | Payment method (FK)                          |
| `due_day`           | INTEGER    | Due day (if recurring)                       |
| `status_id`         | INTEGER    | Installment status (FK)                      |
| `created_at`        | TEXT       | Creation date                                |
| `updated_at`        | TEXT       | Last update date                             |
| `is_deleted`        | INTEGER    | Soft delete (0/1)                            |

### Table: finance_types
Defines transaction categories (Food, Salary, etc).

| Field              | Type       | Description                                  |
|-------------------|------------|----------------------------------------------|
| `id`              | INTEGER    | Unique identifier                            |
| `name`            | TEXT       | Type name                                    |
| `finance_category`| TEXT       | Category: income/expense/investment          |
| `icon`            | TEXT       | Icon (optional)                              |
| `color`           | TEXT       | Color (optional)                             |
| `is_active`       | INTEGER    | If active (0/1)                              |
| `created_at`      | TEXT       | Creation date                                |
| `has_limit`       | INTEGER    | If has spending limit (0/1)                  |
| `limit_value`     | REAL       | Limit value                                  |

### Table: finance_payment
Available payment methods.

| Field         | Type       | Description                                  |
|--------------|------------|----------------------------------------------|
| `id`         | INTEGER    | Unique identifier                            |
| `payment_name`| TEXT      | Payment method name                          |

### Table: finance_target
Savings goals you want to achieve.

| Field         | Type       | Description                                  |
|--------------|------------|----------------------------------------------|
| `id`         | INTEGER    | Unique identifier                            |
| `name`       | TEXT       | Goal name                                    |
| `value`      | REAL       | Target value                                 |
| `created_at` | TEXT       | Creation date                                |

### Table: finance_saving
Deposits made to your savings goals.

| Field       | Type       | Description                                  |
|------------|------------|----------------------------------------------|
| `id`       | INTEGER    | Unique identifier                            |
| `name`     | TEXT       | Deposit description                          |
| `value`    | REAL       | Deposited value                              |
| `target_id`| INTEGER    | Goal reference (FK)                          |
| `created_at`| TEXT      | Deposit date                                 |

### Table: finance_balance
Stores the current total balance.

| Field          | Type       | Description                                  |
|---------------|------------|----------------------------------------------|
| `id`          | INTEGER    | Unique identifier                            |
| `total_balance`| REAL      | Current balance                              |

### Table: finance_status
Status of recurring installments.

| Field        | Type       | Description                                  |
|-------------|------------|----------------------------------------------|
| `id`        | INTEGER    | Unique identifier                            |
| `status_name`| TEXT      | Status name (Pending, Paid, etc)             |

## Technologies

- **Flutter** - Cross-platform framework
- **Dart** - Programming language
- **SQLite** - Local database
- **flutter_bloc** - State management
- **flutter_modular** - Dependency injection and routing
- **Material Design 3** - Modern design system

## How to Run

```bash
# Clone the repository
git clone https://github.com/MyCyberCodeSpace/app_finance.git

# Enter the folder
cd finance_control

# Install dependencies
flutter pub get

# Run the app
flutter run
```