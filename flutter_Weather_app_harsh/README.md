# flutter_Weather_app_harsh

Polished, bold & vibrant weather app built for the Flutter Intern Hackathon (Darwix AI).

Features:
- City search with suggestions and error handling
- Current weather (temp, feels-like, humidity, wind, condition, icon)
- 5-day forecast (horizontal cards)
- Hourly forecast (next ~24h)
- Favorites with shared_preferences
- Current location (geolocator)
- Unit toggle (°C/°F, km/h ↔ mph)
- Bold & vibrant UI with full-screen Lottie animations and glass cards

Setup:
1. Replace YOUR_OPENWEATHERMAP_API_KEY in lib/core/constants.dart
2. flutter pub get
3. flutter run

Notes:
- Lottie files are referenced from assets folder (included placeholders). Replace with local Lottie JSON files if desired.
