# Zemen AI — The Ultimate Offline Educational Assistant 🇪🇹

Zemen AI is a high-performance, **offline-first** educational tutor designed specifically for students in Ethiopia. It utilizes a hybrid AI engine to provide uninterrupted academic support, even in areas with limited or no internet connectivity.

## 🚀 Key Features

- **Hybrid Neural Engine:** Automatically toggles between a Cloud API (when online) and a local neural engine (when offline).
- **The Ultimate Professor Persona:** A bilingual (Amharic/English) tutor persona designed to explain complex academic concepts.
- **Premium UI/UX:** A state-of-the-art "Obsidian & Gold" design system featuring glassmorphism and fluid animations.
- **Academic Mastery:** Built-in support for subject-specific modules (Mathematics, Biology, History) and local quiz generation.
- **Resource Management:** Real-time monitoring of neural load, RAM usage, and battery health to ensure long study sessions.

## 🛠️ Tech Stack

- **Framework:** Flutter (Android / Windows)
- **State Management:** Provider
- **Database:** SQLite (via `sqflite`) for persistent chat history and module data.
- **Animations:** `flutter_animate`
- **Branding:** Custom Glassmorphic design with `Google Fonts`.

## 📂 Project Structure

- `lib/services/ai_engine_service.dart`: The core Hybrid logic.
- `lib/services/extraction_service.dart`: Handles the decompression of large neural weights.
- `lib/services/database_service.dart`: SQLite persistence layer.
- `lib/screens/`: High-fidelity UI screens including the Onboarding flow and Chat Interface.

## 🔧 Getting Started

1.  **Prerequisites:** Flutter SDK installed and a device/emulator ready.
2.  **Install Dependencies:**
    ```bash
    flutter pub get
    ```
3.  **Run the App:**
    ```bash
    flutter run
    ```
4.  **Brain Sync:** Upon first launch, select the "Ultimate Professor" brain to experience the real-time neural weight extraction flow.

## 📜 Roadmap & Vision
Zemen AI aims to bridge the digital divide by bringing elite-level AI tutoring to every student's pocket, regardless of their data plan.

---
Developed with ❤️ by **Biniyam Wegene**
