# Communico

### 🚀 A Modern Communication and Entertainment Platform

**Communico** is a feature-rich Flutter web application designed to streamline communication, foster collaboration, and provide entertainment. This side project showcases advanced technologies, clean architecture, and seamless deployment.

---

## 🌟 Features

1. **Real-Time Messaging**  
   - Instant individual and group chats powered by WebSockets for real-time interactions.

2. **AI Chat Bot**  
   - Engage with an intelligent chatbot for assistance, conversation, or fun.

3. **Group Chat with Unique Links**  
   - Share group and chat conversations using secure, unique links for easy access.

4. **Radio Stations**  
   - Enjoy chill music with integrated radio station support.

5. **Real-Time Collaboration**  
   - Reliable and low-latency communication for real-time group interactions.

6. **Seamless Deployment**  
   - Fully automated CI/CD pipeline deploying the app to Azure Virtual Machines.

---

## 🛠️ Technical Overview

1. **Frontend**  
   - Developed using **Flutter Web** for a responsive and engaging user interface.  
   - **BLoC/Cubit** for state management to ensure scalable and testable logic.  

2. **Backend**  
   - Utilizes WebSocket-based backend for real-time communication.  
   - Azure-hosted environment for robust and scalable infrastructure.  

3. **Architecture**  
   - Implements **Clean Architecture** with distinct layers:  
     - `Data` for handling APIs and repositories.  
     - `Domain` for business logic.  
     - `Presentation` for UI and state management.  
     - `Service` for external integrations like AI and radio APIs.  

4. **DevOps**  
   - CI/CD pipeline ensures continuous integration and automated deployments to VMs.

---

## 💻 Project Setup

### Prerequisites
- Flutter SDK
- Dart SDK
- Azure account for deployment

### Steps to Run Locally
1. Clone the repository:
   ```bash
   git clone <repository-url>
   ```
2. Navigate to the project directory:
   ```bash
   cd communico
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run the application:
   ```bash
   flutter run -d web
   ```

---

## 🚀 Deployment
The CI/CD pipeline automatically builds, tests, and deploys the app to a VM. To set up:
1. Configure VM or GitHub Actions.
2. Link the repository to your pipeline.
3. Deploy the app using the pipeline.

---

## 🤝 Contributions
Feel free to contribute to **Communico** by submitting issues or pull requests. All contributions are welcome!

---

### ✨ Author
Muhammad Ashar  
[GitHub Profile](https://github.com/as3hr)  
