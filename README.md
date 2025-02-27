# Task Manager - Flutter Application

## Description

Task Manager is a simple and intuitive Flutter application designed to help you organize and manage your daily tasks effectively.  It provides a user-friendly interface to add, schedule, and track your tasks, ensuring you stay on top of your commitments. The application also features local notifications to remind you of upcoming tasks, and supports both light and dark themes for a personalized experience.

## Features

- **Add Tasks:** Easily create new tasks with titles, detailed notes, due dates, start and end times.
- **Task Scheduling:** Set specific dates and times for your tasks.
- **Reminders:** Configure reminders to be notified before your tasks are due.
- **Repeating Tasks:** Set tasks to repeat daily, weekly, or monthly for recurring activities.
- **Task Categorization:**  Color-code tasks for visual organization and prioritization.
- **Task Completion:** Mark tasks as completed to track your progress.
- **Delete Tasks:** Remove tasks that are no longer needed.
- **Date-Based Task View:** View tasks organized by date using a convenient date picker timeline.
- **Local Notifications:** Receive timely notifications for scheduled tasks, even when the app is in the background.
- **Theme Support:**  Switch between light and dark themes to suit your preference and environment.
- **Persistent Data Storage:** Tasks are stored locally using SQLite database, ensuring your data is saved even after closing the app.


## Technologies Used
- Flutter: UI framework for building cross-platform mobile applications.

- GetX: State management, dependency injection, and routing library for Flutter.

- GetStorage: Fast, persistent, and easy-to-use local storage for Flutter.

- SQLite: Local database for storing task data.

- intl: Internationalization and localization support, used for date and time formatting.

- hexcolor: Library for using hexadecimal color codes in Flutter.

- month_year_picker: Flutter widget for selecting month and year.

- flutter_local_notifications: Flutter plugin for displaying local notifications.

- timezone: Library for working with timezones, necessary for scheduling notifications correctly.

- date_picker_timeline: Widget for displaying a horizontal date picker timeline.

- flutter_staggered_animations: Library for creating staggered animations in Flutter.

## Getting Started
Prerequisites
Flutter SDK installed on your machine. Flutter Installation Guide

## Installation
1) Clone the repository:

  - git clone https://github.com/EmmanuelVegher/taskmanager.git
  - cd taskmanager

2) Get dependencies:

  flutter pub get

3) Run the application:

  flutter run

Choose the target device (emulator/simulator or physical device) when prompted.

## Project Structure

task_manager/
├── AllWidgets/             # Custom widgets used throughout the app
│   ├── button.dart
│   └── input_field.dart
├── assets/                # Application assets (images, fonts, etc.)
│   └── image/
│       └── taskManager2.jpg
├── controllers/           # State management controllers (GetX controllers)
│   └── task_controller.dart
├── db/                    # Database related files
│   └── db_helper.dart
├── model/                 # Data models
│   └── task.dart
├── services/              # Services like notifications and theme management
│   ├── notification_services.dart
│   └── theme_services.dart
├── to-do/                 # Specific feature related files (e.g., Notified Page)
│   └── notified_page.dart
├── theme.dart             # Application theme definitions
├── splashscreen.dart      # Splash screen implementation
├── main.dart              # Entry point of the application
├── pubspec.yaml           # Project dependencies and configuration
├── README.md              # Project documentation (this file)


## Contributing
Contributions are welcome! If you'd like to contribute to the development of Task Manager, please follow these steps:

1) Fork the repository.

2) Create a new branch for your feature or bug fix.

3) Make your changes and commit them with clear and concise commit messages.

4) Push your changes to your forked repository.

5) Submit a pull request to the main repository.


## Contact
Emmanuel Vegher - vegher.emmanuel@gmail.com