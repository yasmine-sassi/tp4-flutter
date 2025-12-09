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
dart run build_runner build --delete-conflicting-outputs
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
- **Dio + Retrofit Section** (Teal buttons)
  - Random Quote (Dio) → Single random quote using Dio + Retrofit
  - All Quotes (Dio) → List of quotes using Dio + Retrofit

## 📂 Project Structure

```
lib/
├── models/
│   ├── quote.dart              # Model with @JsonSerializable
│   └── quote.g.dart            # Generated serialization code
│
├── services/
│   ├── api_service.dart        # Retrofit API interface
│   └── api_service.g.dart      # Generated implementation
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

---

## 🔍 Detailed Comparison

### 1. MOINS DE CODE (Less Code)

#### Avec HTTP (quote_screen.dart)

```dart
Future _fetchQuote() async {
  final Uri url = Uri.parse(address);
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final List<dynamic> quoteJson = convert.json.decode(response.body);
    Quote quote = Quote.fromJSON(quoteJson[0]);
    return quote;
  } else {
    return Quote(text: 'Error retrieving quote', author: '');
  }
}
```

#### Avec Dio/Retrofit (quote_screen_dio.dart)

```dart
Future<void> _fetchQuote() async {
  try {
    final quotes = await _apiService.getRandomQuote();
    // Quote déjà désérialisé automatiquement!
  } on DioException catch (e) {
    // Gestion d'erreur
  }
}
```

**Avantages:**

- ❌ Plus besoin de `Uri.parse()`
- ❌ Plus besoin de vérifier `statusCode`
- ❌ Plus besoin de `json.decode()` manuel
- ✅ Désérialisation automatique avec `json_serializable`
- ✅ Code plus concis et lisible

---

### 2. MEILLEURE STRUCTURE (Better Structure)

#### Architecture HTTP (Ancienne)

```
lib/
  screens/
    quote_screen.dart         ← Logique réseau mélangée avec UI
    quotes_list_screen.dart   ← Code dupliqué
  models/
    quote.dart                ← Désérialisation manuelle
```

#### Architecture Dio/Retrofit (Nouvelle)

```
lib/
  services/
    api_service.dart          ← API centralisée, réutilisable
    api_service.g.dart        ← Code généré automatiquement
  models/
    quote.dart                ← Annotations @JsonSerializable
    quote.g.dart              ← Désérialisation générée
  screens/
    quote_screen_dio.dart     ← UI uniquement
    quotes_list_screen_dio.dart
```

**Avantages:**

- ✅ **Séparation des responsabilités**: API service séparé de l'UI
- ✅ **Réutilisation**: Un seul `ApiService` pour toutes les screens
- ✅ **Maintenabilité**: Changement d'URL en un seul endroit
- ✅ **Testabilité**: Facile de mocker `ApiService` pour les tests

---

### 3. AUTOMATISATION (Automation)

#### Avec HTTP (Manuel)

```dart
// quote.dart - Désérialisation manuelle
Quote.fromJSON(Map<String, dynamic> map)
  : text = map['q'] ?? '',
    author = map['a'] ?? '';
```

**Problèmes:**

- 🔴 Erreurs de typage (map['q'] vs map['Q'])
- 🔴 Oubli de champs
- 🔴 Maintenance difficile si l'API change

#### Avec Dio/Retrofit (Automatique)

```dart
// quote.dart - Annotations seulement
@JsonSerializable()
class Quote {
  @JsonKey(name: 'q')
  final String text;

  @JsonKey(name: 'a')
  final String author;

  // Généré automatiquement par build_runner
  factory Quote.fromJson(Map<String, dynamic> json) => _$QuoteFromJson(json);
}
```

```dart
// api_service.dart - Définition déclarative
@RestApi(baseUrl: 'https://zenquotes.io/api')
abstract class ApiService {
  @GET('/random')
  Future<List<Quote>> getRandomQuote();

  @GET('/quotes')
  Future<List<Quote>> getAllQuotes();
}
```

**Avantages de l'automatisation:**

- ✅ **Code généré** par `build_runner build`
- ✅ **Type-safe**: Erreurs détectées à la compilation
- ✅ **Documentation claire**: Les annotations servent de documentation
- ✅ **Moins d'erreurs humaines**

---

### 4. FONCTIONNALITÉS AVANCÉES DE DIO

#### Configuration centralisée

```dart
final dio = Dio(BaseOptions(
  connectTimeout: const Duration(seconds: 5),
  receiveTimeout: const Duration(seconds: 3),
));
```

#### Intercepteurs (Logging, Auth, etc.)

```dart
dio.interceptors.add(LogInterceptor(
  requestBody: true,
  responseBody: true,
));
```

#### Gestion d'erreur typée

```dart
} on DioException catch (e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
      // Timeout spécifique
    case DioExceptionType.badResponse:
      // Mauvaise réponse
  }
}
```

**Fonctionnalités incluses:**

- ✅ Timeouts configurables
- ✅ Retry automatique
- ✅ Upload/Download avec progression
- ✅ Cache intégré
- ✅ Intercepteurs pour authentication
- ✅ Support FormData et multipart

---

## 📊 Summary Comparison

| Critère              | HTTP           | Dio + Retrofit |
| -------------------- | -------------- | -------------- |
| **Lignes de code**   | ~50 par screen | ~30 par screen |
| **Code dupliqué**    | Beaucoup       | Minimal        |
| **Désérialisation**  | Manuelle       | Automatique    |
| **Type safety**      | Faible         | Forte          |
| **Gestion d'erreur** | Basique        | Avancée        |
| **Configuration**    | Par appel      | Centralisée    |
| **Maintenabilité**   | 🟡 Moyenne     | 🟢 Excellente  |
| **Testabilité**      | 🟡 Difficile   | 🟢 Facile      |

---

## 🛠️ Commands Used

```bash
# Ajouter les dépendances
flutter pub add dio retrofit json_annotation
flutter pub add --dev retrofit_generator build_runner json_serializable

# Générer le code
dart run build_runner build --delete-conflicting-outputs

# Watch mode (régénère automatiquement)
dart run build_runner watch --delete-conflicting-outputs
```

---

## ✅ Conclusion

- **Moins de code**: 40% de réduction du code boilerplate
- **Meilleure structure**: Séparation claire API/UI/Models
- **Automatisation**: Code généré, moins d'erreurs, plus de productivité

**Recommandation**: Utiliser Dio + Retrofit pour tout projet professionnel!

---

## 📚 Additional Resources

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)
- [Dio Documentation](https://pub.dev/packages/dio)
- [Retrofit Documentation](https://pub.dev/packages/retrofit)
- [json_serializable Documentation](https://pub.dev/packages/json_serializable)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
