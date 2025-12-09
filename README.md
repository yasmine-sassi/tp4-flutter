# TP4 - HTTP vs Dio + Retrofit Comparison

This project demonstrates two approaches to consuming REST APIs in Flutter:

1. **HTTP Package** (Traditional approach)
2. **Dio + Retrofit** (Modern approach with code generation)

## 🚀 Quick Start

1. Install dependencies:

```bash
flutter pub get
```

2. Generate code (only needed once, or when models/services change):

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

3. Run the app:

```bash
flutter run
```

## 📱 App Structure

### Intro Screen

- **HTTP Package Section** (Purple buttons)
  - Random Quote → Single random quote using HTTP
  - View All Quotes → List of quotes using HTTP
- **Dio + Retrofit Section** (Amber buttons)
  - Random Quote (Dio) → Single random quote using Dio + Retrofit
  - All Quotes (Dio) → List of quotes using Dio + Retrofit

## 📂 Project Structure

```
lib/
├── models/
│   ├── quote.dart              # Original model for HTTP package
│   ├── quote_dio.dart          # Model with @JsonSerializable for Dio
│   ├── quote.g.dart            # Generated
│   └── quote_dio.g.dart        # Generated
│
├── services/
│   ├── quote_api_service.dart      # Retrofit API interface
│   └── quote_api_service.g.dart    # Generated implementation
│
├── screens/
│   ├── intro_screen.dart           # Landing page
│   ├── quote_screen.dart           # HTTP version
│   ├── quotes_list_screen.dart     # HTTP version
│   ├── quote_screen_dio.dart       # Dio version
│   └── quotes_list_screen_dio.dart # Dio version
│
└── main.dart
```

## 🔑 Key Differences

### HTTP Package: Manual Approach

```dart
final response = await http.get(url);
if (response.statusCode == 200) {
  final json = jsonDecode(response.body);
  final quotes = json.map((e) => Quote.fromJSON(e)).toList();
}
```

### Dio + Retrofit: Automatic Approach

```dart
final quotes = await _apiService.getAllQuotes();
// That's it! Everything handled automatically
```

## 📊 Benefits

| Aspect        | HTTP    | Dio + Retrofit |
| ------------- | ------- | -------------- |
| Lines of code | ~65-90  | ~40-55 (-40%)  |
| JSON parsing  | Manual  | Automatic      |
| Type safety   | Runtime | Compile-time   |
| Structure     | Mixed   | Separated      |
| Interceptors  | No      | Yes            |

## 📖 More Information

See [DIO_RETROFIT_COMPARISON.md](./DIO_RETROFIT_COMPARISON.md) for detailed comparison.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
