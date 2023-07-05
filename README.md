# Locker Management System

The Locker Management System is a mobile application built using Flutter that provides a convenient way for users to reserve and manage lockers. Users can browse available lockers, reserve and unreserve lockers, and control the lockers they have reserved.

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Project Structure](#project-structure)
- [Screens](#screens)
- [Widgets](#widgets)
- [Services](#services)
  - [API Service](#api-service)
  - [MQTT Service](#mqtt-service)
- [Models](#models)
- [Contributing](#contributing)
- [License](#license)

## Features

- User authentication (register, login, and logout)
- Browse available lockers
- Reserve and unreserve lockers
- View locker details and control reserved lockers
- View the user's reserved lockers
- Splash screen on app launch
- Real-time locker control using MQTT

## Installation

1. Ensure that you have the Flutter SDK installed on your machine. Follow the [Flutter installation guide](https://flutter.dev/docs/get-started/install) if needed.
2. Clone the repository:

```
git clone https://github.com/username/locker_management_system.git
```

3. Move into the project directory:

```
cd locker_management_system
```

4. Install dependencies:

```
flutter pub get
```

5. Run the app on an emulator or a connected device:

```
flutter run
```

## Usage

1. Launch the app on your device or emulator.
2. Register a new user or log in with an existing account.
3. Browse available lockers and reserve a locker of your choice.
4. View and control your reserved lockers.
5. Unreserve a locker when no longer needed.
6. Log out of your account.

## Project Structure

The project is organized into the following directories:

- `lib`: Contains the main Dart code, organized into the following subdirectories:
  - `screens`: Contains the screen (page) widgets.
  - `widgets`: Contains the custom reusable widgets.
  - `services`: Contains the API and MQTT service classes.
  - `models`: Contains the data models.
  - `utils`: Contains utility classes and constants.
- `assets`: Contains image assets used in the app.
- `test`: Contains unit and widget tests.

## Screens

- `SplashScreen`: Displays a splash screen on app launch for a specified duration before navigating to the main page.
- `RegisterPage`: Presents a registration form to the user for creating a new account.
- `LoginPage`: Presents a login form to the user for authentication.
- `MainPage`: Displays a list of lockers and provides options to reserve and control lockers.
- `LockerDetailsPage`: Displays detailed information about a reserved locker and provides options to control the locker.

## Widgets

- `LockerCard`: A custom widget that displays a locker's information and provides options for reserving, unreserving, and controlling the locker.

## Services

### API Service

`ApiService` is a class that handles communication with the backend API for user authentication, locker reservation, and locker management. Key methods include:

- `registerUser()`: Registers a new user with the provided information.
- `loginUser()`: Authenticates a user using their email and password.
- `getLockers()`: Retrieves a list of available lockers.
- `reserveLocker()`: Reserves a locker for a user.
- `unreserveLocker()`: Unreserves a locker for a user.
- `getUserEmail()`: Retrieves the email of the user who reserved a locker.

### MQTT Service

`MqttService` is a class that handles communication with the MQTT broker for real-time locker control. Key methods include:

- `connect()`: Connects to the MQTT broker using the provided credentials.
- `disconnect()`: Disconnects from the MQTT broker.
- `subscribe()`: Subscribes to an MQTT topic.
- `unsubscribe()`: Unsubscribes from an MQTT topic.
- `publish()`: Publishes a message to an MQTT topic.

## Models

- `User`: A model class representing a user, including their ID, email, password, full name, and phone number.
- `Locker`: A model class representing a locker, including its ID, user ID (if reserved), image URL, availability, size, and price.

## Contributing

Contributions are welcome. If you find a bug or have a suggestion for improvement, feel free to open an issue or submit a pull request.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more information.