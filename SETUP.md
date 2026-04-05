# Recify - Schnellstart-Anleitung

## 🚀 Sofort loslegen (unter 5 Minuten)

### 1. Repository klonen
```bash
git clone https://github.com/Server-Tec/recify.git
cd recify
```

### 2. Dependencies installieren
```bash
flutter pub get
```

### 3. App starten (funktioniert sofort!)
```bash
flutter run
```

**Die App läuft jetzt komplett ohne weitere Konfiguration!** 🎉

## 🔧 Firebase aktivieren (Optional - für erweiterte Funktionen)

Wenn du die vollen Funktionen (mehrere Benutzer, geteilte Bewertungen) nutzen möchtest:

### Firebase-Konfiguration:
1. Öffne `lib/main.dart`
2. Ändere `const bool USE_FIREBASE = false;` zu `true`
3. Erstelle ein Firebase-Projekt bei [Firebase Console](https://console.firebase.google.com/)
4. Aktiviere Authentication (E-Mail/Passwort) und Firestore
5. Aktualisiere `lib/firebase_options.dart` mit deiner Firebase-Konfiguration
6. Platziere `google-services.json` in `android/app/`

### Firebase-Projekt erstellen (Detail-Anleitung):
1. Gehe zu [Firebase Console](https://console.firebase.google.com/)
2. Klicke "Projekt hinzufügen"
3. Gib einen Projektnamen ein (z.B. "recify-app")
4. Aktiviere Google Analytics (empfohlen)

#### Authentication aktivieren:
1. Gehe zu "Authentication" in der Firebase Console
2. Klicke auf "Erste Schritte"
3. Wähle "E-Mail/Passwort" als Anmeldemethode
4. Aktiviere es

#### Firestore aktivieren:
1. Gehe zu "Firestore Database"
2. Klicke "Datenbank erstellen"
3. Wähle "Im Testmodus starten" (für Entwicklung)
4. Wähle eine Region (z.B. europe-west)

## 📱 Funktionen - Sofort verfügbar:

### ✅ Immer verfügbar:
- **120+ Rezepte** aus aller Welt durchsuchen
- Nach Kategorien filtern (Frühstück, Mittagessen, Abendessen, Vorspeise)
- Nährwertinformationen (Kalorien, Protein, Kohlenhydrate, Fett)
- Responsive Material Design 3 UI
- Spenden-Buttons (PayPal)
- Suchfunktion
- Favoriten speichern (lokal)

### 🔐 Mit Firebase zusätzlich:
- Mehrere Benutzer-Accounts
- Bewertungen werden cloud-synchronisiert
- Geteilte Bewertungen von anderen Benutzern
- Persistente Daten über Geräte hinweg

## 🎯 Demo-Modus (Standard):
Die App startet automatisch im Demo-Modus:
- Du bist als "Demo User" eingeloggt
- Bewertungen werden lokal gespeichert
- Alle Rezepte sind verfügbar
- Keine Firebase-Konfiguration nötig

## 🔧 Systemvoraussetzungen:
- Flutter SDK 3.0+
- Dart SDK 3.0+
- Android Studio oder VS Code
- Android Emulator oder physisches Gerät

## 📦 Release Build erstellen:
```bash
flutter build apk --release
```

## ❓ Probleme?:
- Stelle sicher, dass Flutter richtig installiert ist: `flutter doctor`
- Bei Build-Fehlern: `flutter clean && flutter pub get`
- Firebase-Fehler: Überprüfe `USE_FIREBASE = true` und Konfiguration

## 🎉 Fertig!
Die App ist sofort einsatzbereit - kein Setup erforderlich! 🍳✨</content>
<parameter name="filePath">c:\Users\Admin\Desktop\recify\SETUP.md