# SafeGuard AI 🛡️

A Proof-of-Concept (PoC) mobile application demonstrating AI-driven safety analysis, seamlessly integrated with automated n8n workflows.

> **Note:** This project was developed to showcase a Clean Architecture approach in Flutter, connected to an automated backend pipeline.

<img width="1363" height="955" alt="Image" src="https://github.com/user-attachments/assets/1a032db6-07ab-4e10-9f2a-6d1aa7bbab3f" />

## 🛠 Tech Stack
* **Frontend:** Flutter, Dart
* **Architecture:** Clean Architecture, Dependency Injection (GetIt)
* **State Management:** BLoC
* **Backend & Automation:** n8n, RESTful APIs, Google Gemini AI

## 🚀 Quick Start & Mock Mode

To make UI and architecture testing easier without setting up the n8n backend locally, the app includes a **Mock Mode**. 

```bash
git clone [https://github.com/nozhankeklik/safeguard_ai.git](https://github.com/nozhankeklik/safeguard_ai.git)
cd safeguard_ai
flutter pub get
flutter run
```
To toggle the backend connection, modify the _useMockData flag in lib/core/init/injection_container.dart.
