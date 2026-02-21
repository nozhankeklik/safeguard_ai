# SafeGuard AI 🛡️

A Proof-of-Concept (PoC) mobile application demonstrating AI-driven safety analysis, seamlessly integrated with automated email reporting via n8n workflows.

> **Note:** This project was developed to showcase a Clean Architecture approach in Flutter, connected to an automated backend pipeline for industrial safety.

<img width="1363" height="955" alt="Image" src="https://github.com/user-attachments/assets/1a032db6-07ab-4e10-9f2a-6d1aa7bbab3f" />

## ⚙️ How it Works (Core Workflow)
* **Detection:** The app captures or selects an image and sends it to Google Gemini AI for intelligent risk analysis.
* **Integration:** Flutter transmits the analysis results to an n8n webhook.
* **Automation:** The n8n workflow processes the data and automatically generates and sends a professional email report to pre-defined recipients.

## 🛠 Tech Stack
* **Frontend:** Flutter, Dart
* **Architecture:** Clean Architecture, Dependency Injection (GetIt)
* **State Management:** BLoC
* **Backend & Automation:** n8n (Workflow Engine), RESTful APIs, Google Gemini AI

## 🚀 Quick Start & Mock Mode

To make UI and architecture testing easier without setting up the n8n backend or API keys locally, the app includes a **Mock Mode**. 

```bash
git clone https://github.com/nozhankeklik/safeguard_ai.git
cd safeguard_ai
flutter pub get
flutter run
```
To toggle the backend connection (n8n/Gemini) or use static data, modify the _useMockData flag in lib/core/init/injection_container.dart.
