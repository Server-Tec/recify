# Recify Quantum

Eine moderne Flutter-App für gesunde Rezepte mit quanten-inspiriertem Design. Optimiert für biohacking und optimale Ernährung.

## Features

- ✨ 50 einzigartige Rezepte mit vollständigen Nährwertangaben und Zutatenlisten
- 🔍 Intelligente Rezeptsuche nach Name, Beschreibung und Kategorie
- ❤️ Favoriten-System für persönliche Rezeptsammlung
- 🤖 **KI-gestützte Funktionen:**
  - 📸 **Zutaten-Erkennung**: Foto aufnehmen und passende Rezepte vorschlagen
  - 🧠 **Nährwert-Analyse**: Detaillierte KI-basierte Nährwertbewertung
  - 🔊 **Sprachausgabe**: Rezepte vorlesen lassen
  - 🎯 **Persönliche Empfehlungen**: Maßgeschneiderte Rezeptvorschläge
- 🌙 Quantum UI mit Glas-Effekten und Neon-Design
- 📱 Responsive Design für alle Geräte

## Rezept-Kategorien

- Frühstück (Power-Bowls, Omeletts, Porridge)
- Drink (Smoothies, Tonics, Kaffees)
- Lunch (Currys, Salate, Wraps, Pizzas)
- Dinner (Suppen, Risottos, Fleischgerichte)
- Snack (Nüsse, Hummus, Protein-Snacks)
- Dessert (Schokolade, Joghurt, Früchte)
- Workout (Kohlenhydratreiche Mahlzeiten)
- Side (Beilagen)
- Base (Basisrezepte)

## Gesundheitsfokus

Jedes Rezept ist optimiert für:
- **ATP-Produktion**: Mitochondrien-Gesundheit
- **Insulin-Sensitivität**: Blutzucker-Kontrolle
- **Entzündungshemmung**: Anti-Inflammatory Effekte
- **Gehirnfunktion**: BDNF und Neurotransmitter
- **Muskelaufbau**: Protein-Synthese
- **Immunsystem**: Antioxidantien und Vitamine

## Technische Details

- **Flutter**: Cross-Platform UI Framework (3.1.0+)
- **State Management**: Provider Pattern
- **Persistence**: Shared Preferences
- **Design**: Custom Quantum-Inspired Theme
- **Architektur**: Clean Architecture (Domain/Data/Presentation)
- **KI/ML**: Google ML Kit für Bilderkennung, Flutter TTS für Sprachausgabe
- **Icons**: flutter_launcher_icons für automatische Generierung

## KI-Funktionen

### 🤖 Zutaten-Erkennung
- **Technologie**: Google ML Kit Image Labeling
- **Funktion**: Kamera-Integration zur Erkennung von Lebensmitteln
- **Algorithmus**: Filtern nach lebensmittelbezogenen Labels mit Matching-Score

### 🧠 Nährwert-Analyse
- **KI-Engine**: Eigene Analyse-Algorithmen
- **Metriken**: Kalorienberechnung, Makro-Verteilung, Gesundheitsbewertung
- **Insights**: Personalisierte Empfehlungen basierend auf Nährwerten

### 🔊 Sprachausgabe
- **Technologie**: Flutter TTS (Text-to-Speech)
- **Sprachen**: Deutsch (de-DE)
- **Features**: Anpassbare Geschwindigkeit und Tonhöhe

### 🎯 Persönliche Empfehlungen
- **Algorithmus**: Basierend auf Favoriten-Kategorien und Gesundheitspräferenzen
- **Lernfähigkeit**: Adaptiert sich an Nutzerverhalten
- **Kategorien**: Frühstück, Lunch, Dinner, Snacks, Drinks

## Installation

1. Flutter SDK 3.1.0+ installieren
2. `flutter pub get` ausführen
3. `flutter run` starten

## Build für Produktion

### Android
```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# App Bundle für Play Store
flutter build appbundle --release
```

### iOS
```bash
# Für iOS-Simulator
flutter run ios

# Release Build für App Store
flutter build ios --release
```

### Icons generieren
1. Platzieren Sie eine 1024x1024 PNG-Datei als `icon.png` in `assets/icons/`
2. Führen Sie aus: `flutter pub run flutter_launcher_icons:main`

## App Store Konfiguration

- **App-Name:** Recify Quantum
- **Bundle ID:** com.recify.quantum
- **Version:** 1.0.0
- **Mindestversion:** iOS 12.0, Android API 21
- **Kategorie:** Food & Drink

## Datenschutz & Rechtliches

- [Datenschutzrichtlinie](PRIVACY_POLICY.md)
- [Nutzungsbedingungen](TERMS_OF_SERVICE.md)

## Projektstruktur

```
lib/
├── core/           # Design-System & Services
│   ├── quantum_design.dart
│   └── favorites_provider.dart
├── data/           # Repository & Datenquellen
│   └── recipe_repository.dart
├── domain/         # Business-Modelle
│   └── models.dart
└── presentation/   # UI-Screens & Widgets
    ├── dashboard_screen.dart
    ├── recipe_screen.dart
    ├── recipe_card.dart
    ├── recipe_detail.dart
    ├── favorites_screen.dart
    └── root_nav.dart
```

## Entwicklung

Das Projekt folgt Clean Architecture Prinzipien und verwendet moderne Flutter Patterns für skalierbare App-Entwicklung.