# Communico Frontend

A modern communication platform built with Flutter Web, featuring real-time messaging, group chats, AI chatbot integration, and entertainment features including radio stations.

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