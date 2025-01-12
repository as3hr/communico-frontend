# Communico Frontend

A modern communication platform built with Flutter Web, featuring real-time messaging, group chats, AI chatbot integration, and entertainment features including radio stations.

## 💻 Backend

Check Out the backend of Communico [here](https://github.com/as3hr/communico-backend)

## ScreenShots
![1](https://github.com/user-attachments/assets/ac2eacbf-0fca-4054-ba00-cb7bf55ec6bf)
![2](https://github.com/user-attachments/assets/e450ba92-a0bb-485a-9290-7c1e55f7b37e)
![3](https://github.com/user-attachments/assets/10293a79-8f79-4108-9f33-b75e809d4f6e)
![4](https://github.com/user-attachments/assets/55f32a8c-c230-4213-abc8-0532ffc00869)
![5](https://github.com/user-attachments/assets/052ac6ac-8eb9-44fa-9843-57594fabe2a5)

## 🚀 Features

- Real-time messaging with instant updates
- Group chat functionality with member management
- AI-powered chatbot for automated interactions
- Interactive and animated user interface
- Radio station integration for entertainment
- Responsive design
- Secure authentication and authorization

## 🛠️ Technologies

- **Framework:** Flutter Web
- **Architecture:** Clean Architecture
  - Data Layer: API integrations and local storage
  - Domain Layer: Business logic and entities
  - Presentation Layer: UI components and screens
  - Service Layer: Platform services and utilities
- **State Management:** BLoC (Business Logic Component) and Cubit
- **Real-time Communication:** Socket.IO


## 📋 Prerequisites

- Flutter SDK (version X.X.X)
- Dart SDK (version X.X.X)
- IDE (VS Code/Android Studio)
- Git

## 🔧 Installation

1. Clone the repository:
```bash
git clone https://github.com/as3hr/communico-frontend.git
```

2. Navigate to the project directory:
```bash
cd communico-frontend
```

3. Install dependencies:
```bash
flutter pub get
```

4. Configure base url:
- add a baseUrl of the backend in [constants.dart](lib/helpers/constants.dart) file

5. Run the application:
```bash
flutter run -d chrome
```

## 🏗️ Project Structure

```
lib
│   ├── data
│   │   ├── auth/
│   │   ├── chat/
│   │   ├── di/
│   │   ├── group/
│   │   ├── message/
│   │   └── user/
│   ├── di/
│   ├── domain/
│   │   ├── di/
│   │   ├── entities/
│   │   ├── failures/
│   │   ├── model/
│   │   ├── repositories/
│   │   └── stores/
│   ├── helpers/
│   │   ├── styles/
│   │   └── widgets/
│   ├── main.dart
│   ├── navigation/
│   │   ├── di/
│   ├── network/
│   │   ├── di/
│   │   ├── dio/
│   ├── presentation/
│   │   ├── auth/
│   │   ├── communico.dart
│   │   ├── di/
│   │   ├── home/
│   │   ├── main_page.dart
│   │   └── shared_room/
│   └── service/
│       ├── di/
```

## 🔌 API Integration

The frontend communicates with the backend through:
- RESTful APIs for standard CRUD operations
- Socket.IO for real-time messaging and updates

## 🎨 UI/UX Components

- Material Design widgets
- Custom backgrounds
- Responsive layouts
- Error handling and loading states

## 📦 Building for Production

1. Build the web application:
```bash
flutter build web --release
```

2. The built files will be available in `build/web/`

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Open a Pull Request

## 📄 License

This project is licensed under the [MIT License](LICENSE)

## 👥 Authors

- Muhammad Ashar - Software Engineer - [Github](https://github.com/as3hr)
