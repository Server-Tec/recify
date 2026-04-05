# Recify - Social Recipe App

Eine umfassende Flutter-App für Kochrezepte mit sozialen Funktionen, Benutzerbewertungen und internationaler Küche.

## ✨ Features

### 🍳 Rezepte
- **120+ Rezepte** aus aller Welt
- Detaillierte Zutatenlisten und Kochschritte
- Nährwertangaben (Kalorien, Protein, Kohlenhydrate, Fett)
- Schwierigkeitsgrade und Kochzeiten
- Kategorien: Frühstück, Mittagessen, Abendessen, Vorspeisen

### 👥 Soziale Funktionen
- **Benutzer-Authentifizierung** mit Firebase
- **Bewertungssystem** - Sterne-Bewertungen für jedes Rezept
- Persönliche Favoriten
- Suchfunktion nach Rezepten

### 💰 Monetarisierung
- Integrierte PayPal-Spenden-Buttons
- Unterstützung der Entwickler

### 🎨 Design
- Moderne Material Design 3 UI
- Responsive Layout
- Dunkles/Helles Theme
- Intuitive Navigation

## 🚀 Installation & Setup

### Voraussetzungen
- Flutter SDK (Version 3.0+)
- Dart SDK
- Android Studio oder VS Code
- Firebase-Konto für Auth und Firestore

### Schritte
1. **Repository klonen:**
   ```bash
   git clone https://github.com/Server-Tec/recify.git
   cd recify
   ```

2. **Dependencies installieren:**
   ```bash
   flutter pub get
   ```

3. **Firebase konfigurieren:**
   - Firebase-Projekt erstellen
   - Authentication und Firestore aktivieren
   - `lib/firebase_options.dart` mit deinen Firebase-Konfiguration aktualisieren

4. **App starten:**
   ```bash
   flutter run
   ```

5. **Release Build erstellen:**
   ```bash
   flutter build apk --release
   ```

## 📱 Verwendung

1. **Registrieren/Anmelden** mit E-Mail und Passwort
2. **Rezepte durchsuchen** oder nach Kategorien filtern
3. **Rezepte bewerten** mit dem Stern-System
4. **Favoriten speichern** für schnellen Zugriff
5. **Spenden** über die integrierten PayPal-Buttons

## 🛠 Technischer Stack

- **Framework:** Flutter 3.41.6
- **Sprache:** Dart 3.11.4
- **Backend:** Firebase (Auth, Firestore)
- **State Management:** Provider
- **UI:** Material Design 3
- **Plattformen:** Android, iOS, Web, Desktop

## 📂 Projektstruktur

```
lib/
├── main.dart          # Hauptapp mit Routing und Rezeptdaten
├── auth.dart          # Authentifizierung und Login-Seiten
├── rating.dart        # Bewertungs-Widget
└── firebase_options.dart # Firebase-Konfiguration

android/               # Android-spezifische Konfiguration
ios/                   # iOS-spezifische Konfiguration
```

## 🤝 Mitwirken

Beiträge sind willkommen! Bitte erstelle ein Issue oder Pull Request.

## 📄 Lizenz

Dieses Projekt ist unter der MIT-Lizenz lizenziert.

## 📞 Kontakt

Bei Fragen oder Feedback: [GitHub Issues](https://github.com/Server-Tec/recify/issues)
