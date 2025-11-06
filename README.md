# 🌦️ Flutter Weather App: Harsh Yadav  

> **A bold, vibrant, and fully-featured Flutter weather forecast application built for the Darwix AI Flutter Intern Hackathon Challenge.**  
> Get real-time weather updates, forecasts, and a stunning animated UI that adapts to the weather around you.  

---

## ✨ Features

### 🧩 Core (Mandatory)
- 🔍 **City Search** — Search weather by city name with live suggestions and error handling.  
- 🌡️ **Current Weather Display**: Temperature, humidity, wind speed, “feels like” temperature, weather condition & icons.  
- 📅 **5-Day Forecast**:Scrollable daily forecast with min/max temperatures and condition icons.  
- 🖼️ **Clean & Responsive UI**: Modern gradient backgrounds, elegant layout, and smooth transitions.  
- 💾 **Favorite Cities**: Save, view, and remove favorite locations using `shared_preferences`.

---

### 🌟 Bonus (Implemented)
- 📍 **Current Location (GPS)**: Auto-detects user location and fetches live weather.  
- 🕒 **Hourly Forecast**: Displays next 12–24 hours of temperature and conditions.  
- 🌈 **Animated Weather Effects**: Full-screen Lottie animations for sunny, cloudy, rainy, stormy, and snowy scenes.  
- 🔄 **Unit Conversion**: Toggle between Celsius / Fahrenheit and km/h / mph; preference saved locally.  

---

## 🧠 Tech Stack

| Category | Library / Tool |
|-----------|----------------|
| Framework | **Flutter (Stable)** |
| Language | **Dart** |
| Networking | [`dio`](https://pub.dev/packages/dio) |
| Location | [`geolocator`](https://pub.dev/packages/geolocator), [`permission_handler`](https://pub.dev/packages/permission_handler) |
| Local Storage | [`shared_preferences`](https://pub.dev/packages/shared_preferences) |
| Animations | [`lottie`](https://pub.dev/packages/lottie) |
| Images | [`cached_network_image`](https://pub.dev/packages/cached_network_image) |
| Formatting | [`intl`](https://pub.dev/packages/intl) |
| Fonts | [`google_fonts`](https://pub.dev/packages/google_fonts) |

---

## 🧭 App Structure
lib/
├── main.dart
├── models/
├── services/ # API, location, preferences
├── screens/
│ ├── home_screen.dart
│ ├── weather_detail_screen.dart
│ ├── favorites_screen.dart
├── widgets/
├── utils/
├── theme/


---

## ⚙️ Setup & Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Harshiitmadras/flutter_Weather_app_harsh.git
   cd flutter_Weather_app_harsh
2.Install dependencies 

3.Set up OpenWeatherMap API key

4.Create an account → https://openweathermap.org/api

5.Copy your API Key and paste it inside

6.Run the app
---

##💡 Highlights

🎨 Bold & vibrant Apple-style design glass cards, gradients, and dynamic animations.

⚡ Optimized for performance minimal rebuilds and cached assets.

🧭 Fully responsive adapts beautifully to phones and tablets.

🧩 Hackathon-ready architecture clean, modular, and easy to extend.


