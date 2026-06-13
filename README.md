# 🏥 K24Klik Redesign MVP - UI/UX Case Study

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Firebase](https://img.shields.io/badge/firebase-ffca28?style=for-the-badge&logo=firebase&logoColor=black)
![Riverpod](https://img.shields.io/badge/Riverpod-State_Management-blue?style=for-the-badge)
![UI/UX](https://img.shields.io/badge/UI%2FUX-Design_Thinking-success?style=for-the-badge)

A minimalist, cross-platform (Mobile & Web) redesign of a local pharmacy delivery application, built as a final project for the **Human-Computer Interaction (HCI) and UI/UX** course at UIN Prof. K.H. Saifuddin Zuhri Purwokerto (2026).

This project aims to solve complex user navigation, visual clutter, and cognitive overload by implementing a clean, user-centered interface based on real empirical user data and usability testing.

---

## 🔗 Live Project Links

*   🌐 **Live Web App (Firebase Hosting):** `[INSERT YOUR FIREBASE WEB LINK HERE]`
*   📱 **Android APK Download:** Available in `docs/apk/`
*   🎨 **Figma Prototype:** `[INSERT YOUR FIGMA SHARE LINK HERE]`
*   📄 **Full Academic Report:** Available in `docs/Report/`

---

## 🧠 UI/UX Methodology & Highlights

This application was researched, designed, and evaluated using the **Design Thinking** framework (Empathize, Define, Ideate, Prototype, Test).

*   **Heuristic Evaluation:** Evaluated the original app using Jakob Nielsen's 10 Usability Heuristics, identifying core issues with *Aesthetic and Minimalist Design* and *User Control & Freedom* (invasive pop-ups).
*   **Empirical Research:** Conducted a user survey (32 respondents) and stakeholder interviews at local pharmacy branches to define real-world pain points.
*   **Ergonomics & Thumb Zone:** Call-to-action buttons are sized to meet Apple HIG standards (Min 44x44 pt) and placed within the ergonomic bottom "Thumb Zone".
*   **Adaptive Responsive Layout:** The UI automatically adapts from a mobile edge-to-edge layout to a constrained, centered desktop layout for web browsers.
*   **Usability Testing:** The High-Fidelity prototype was tested with 12 real users using the **System Usability Scale (SUS)**, achieving a highly **Acceptable Score of 78.33**.

---

## ✨ Application Features

*   🔐 **Firebase Authentication:** Real email/password registration, login, and secure password reset.
*   ☁️ **Cloud Firestore:** Real-time fetching of medicine products, storing user profiles, and saving order history.
*   🛒 **State Management:** Complex cart logic handled cleanly via `flutter_riverpod`.
*   🌍 **Bilingual Support (EN/ID):** Instant dynamic language switching across the entire app.
*   🌙 **Dark Mode:** Integrated dark theme toggle for visual ergonomics (reducing eye strain for nighttime users).
*   ❤️ **Favorites System:** Users can like products and view them in their personal favorites tab.
*   🛍️ **Mock Checkout:** Streamlined, single-page checkout simulation with dynamic delivery fees and an ethical UX privacy warning.

---

## 📂 Repository Structure

This repository is organized using a feature-first approach for the codebase, and a dedicated `docs` folder for academic and design assets.

```text
📦 Final-Project-UAS-of-Human-Computer-Interaction-UI-UX-Course
 ┣ 📂 docs/                               # All academic and design assets
 ┃ ┣ 📂 apk/                              # Compiled Android application
 ┃ ┣ 📂 Code & Software Explanations/     # Deep-dive explanations of the Flutter architecture
 ┃ ┣ 📂 Diagrams/                         # C4, ERD, and Sequence Diagrams
 ┃ ┣ 📂 Evaluations Surveys Forms/        # SUS Results and Google Form raw data
 ┃ ┣ 📂 Figma Designs/                    # Hi-Fi, Lo-Fi Wireframes, and Storyboards
 ┃ ┣ 📂 Original App Info/                # Screenshots and evaluation of the old K24Klik app
 ┃ ┣ 📂 Presentation/                     # Final PowerPoint Slide Deck
 ┃ ┣ 📂 Proofs Photos/                    # Stakeholder interview photos and field proof
 ┃ ┗ 📂 Report/                           # The final comprehensive Word Document
 ┣ 📂 lib/                                # Flutter Source Code
 ┃ ┣ 📂 l10n/                             # Localization files (EN/ID)
 ┃ ┣ 📂 models/                           # Data models (User, Product, Order)
 ┃ ┣ 📂 providers/                        # Riverpod state controllers
 ┃ ┣ 📂 screens/                          # UI Screens
 ┃ ┣ 📂 widgets/                          # Reusable UI components
 ┃ ┗ 📜 main.dart                         # App entry point & Theme config
 ┗ 📜 README.md
```


## 🚀 Getting Started

To run this project locally on your machine:

* 1. Clone the repository

git clone https://github.com/BandarAbdulrab/Final-Project-UAS-of-Human-Computer-Interaction-UI-UX-Course.git

cd Final-Project-UAS-of-Human-Computer-Interaction-UI-UX-Course

* 2. Install dependencies

flutter pub get

* 3. Run the app (Web or Mobile Emulator)

flutter run -d chrome

(Note: To test Firebase features, ensure the firebase_options.dart is properly configured with an active Firebase project).


## ⚖️ Academic Disclaimer
This project is built strictly for educational purposes as part of a university UI/UX assignment. It is a conceptual mockup. All product images, brands, and the "K24Klik" trademark belong to PT. K-24 Indonesia and other firms. Do not enter real credit card or personal data into this application.

Created by: Bandar Abdulrab (2026)
