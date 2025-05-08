
# Task Manager Flutter App

A Windows Flutter task manager that allows users to create, organize, and manage tasks within color-coded groups. 

---

## Features

-  Create, edit, and delete **tasks and groups**
-  Assign tasks to **color-coded groups**
-  Automatically remove empty groups
-  Persistent local storage using **SQLite**
-  Group and task sorting (by due date or group)

---

## Project Structure

```
lib/
- main.dart              # App entry point, routing logic 
- task.dart              # Task and TaskGroup models
- task_database.dart     # SQLite database setup and access
- todo_page.dart         # Main task list screen
- task_page.dart         # Detailed task view
- group_page.dart        # Detailed group view
- create_item_page.dart  # Task creation form
- edit_item_page.dart    # Task editing form
- create_group_page.dart # Group creation form
- edit_group_page.dart   # Group editing form
```

---

## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- Dart >= 3.0
- For desktop: `window_manager` requires setup on Windows (Enable Developer Mode in windows developer settings)

###  Run the App

```bash
flutter pub get
flutter run -d windows 
```

---

## Built With

- **Flutter** (UI framework)
- **Provider** (state management)
- **SQLite** via `sqflite_common_ffi`
- **window_manager** (desktop window sizing)
- **flutter_material_color_picker** (color picker widget)

---

## Database Schema

The app uses a simple schema with two tables:

- `tasks`: stores task ID, title, description, due date, and groupId
- `groups`: stores group ID, title, color (ARGB int), and taskCount

---

