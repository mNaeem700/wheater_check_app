# 🌦 SkyCast 3D — Full-Stack Flutter Weather App

A complete, production-style weather application with a **Node.js/Express backend**
and a **Flutter frontend** featuring glassmorphism UI, animated gradient skies,
particle systems (rain/snow), and a genuinely interactive **3D-tilt weather card**
you can drag with your finger.

```
weather_app_project/
├── backend/            Node.js + Express API proxy/cache server
└── frontend/            Flutter mobile app (Android/iOS)
```

---

## ✨ Features

**Frontend**
- Live current weather + hourly (24h) + 5-day forecast
- GPS auto-location on launch, or search any city worldwide
- Real 3D interactions — not just fades:
  - Draggable 3D-tilt hero card (perspective `Matrix4` transform, springs back on release)
  - Rotating/swaying 3D weather icon with pulsing glow + parallax shadow
  - Animated multi-layer gradient sky that shifts per condition (clear/cloudy/rain/snow/storm/mist) and day/night
  - Custom-painted particle system: falling rain streaks, drifting snowflakes, floating cloud puffs
- Glassmorphism cards (frosted blur + translucency) throughout
- °C / °F unit toggle, persisted
- Recent searches, persisted
- Pull-to-refresh, graceful error states, offline-friendly caching on the backend
- Zero external animation/image assets required — everything is drawn in code, so it runs immediately after `flutter pub get`, no asset downloads needed

**Backend**
- Express REST API that proxies OpenWeatherMap (keeps your API key off the client)
- In-memory response caching (default 10 min) to reduce upstream calls
- Basic rate limiting
- Endpoints for current weather, forecast, and city search/geocoding (by city name or lat/lon)

---

## 🧱 Tech Stack

| Layer     | Tech |
|-----------|------|
| Frontend  | Flutter 3.x, Provider (state mgmt), `http`, `geolocator`, `shared_preferences`, `google_fonts`, `flutter_animate` |
| Backend   | Node.js, Express, Axios, `node-cache`, `express-rate-limit`, `dotenv`, `cors` |
| Data      | [OpenWeatherMap](https://openweathermap.org/api) (free tier) |

---

## 🚀 Getting Started

### 1. Backend setup

```bash
cd backend
npm install
cp .env.example .env
```

Edit `.env` and add your free API key from https://openweathermap.org/api:

```
OPENWEATHER_API_KEY=your_real_key_here
PORT=5000
```

Run it:

```bash
npm start          # production
npm run dev         # auto-restart on changes (nodemon)
```

The server starts at `http://localhost:5000`. Verify with:

```bash
curl "http://localhost:5000/api/weather/city/London"
```

### 2. Frontend setup

The `frontend/` folder contains the Dart source (`lib/`) and `pubspec.yaml`, but not the
generated native platform folders (`android/`, `ios/`, etc.) since those are large,
machine-generated, and best created fresh by the Flutter tool itself. This is the
standard workflow:

```bash
cd frontend
flutter create .          # generates android/ ios/ web/ etc. around the existing lib/
flutter pub get
```

> `flutter create .` will NOT overwrite your `lib/`, `pubspec.yaml`, or any files
> already present — it only fills in the missing native scaffolding.

**Point the app at your backend** — open `lib/services/weather_service.dart` and set `baseUrl`:

| Running on...                        | `baseUrl` value                         |
|---------------------------------------|------------------------------------------|
| Android emulator                      | `http://10.0.2.2:5000`                   |
| iOS simulator                         | `http://localhost:5000`                  |
| Physical device (same Wi-Fi as your PC) | `http://<your-computer-LAN-IP>:5000`   |
| Deployed backend (Render/Railway/etc.) | `https://your-backend-url.com`          |

**Add location permissions** (required by `geolocator`):

`android/app/src/main/AndroidManifest.xml` — inside `<manifest>`, above `<application>`:
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
<uses-permission android:name="android.permission.INTERNET"/>
```

`ios/Runner/Info.plist` — inside the root `<dict>`:
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>SkyCast uses your location to show local weather.</string>
```

Run it:

```bash
flutter run
```

---

## 🗂 Project Structure (Frontend)

```
lib/
├── main.dart                     App entry point
├── models/weather_model.dart      CurrentWeather, ForecastData, etc.
├── services/
│   ├── weather_service.dart       HTTP client for the backend API
│   └── location_service.dart      GPS via geolocator
├── providers/weather_provider.dart State management (Provider/ChangeNotifier)
├── screens/
│   ├── splash_screen.dart         3D animated intro
│   ├── home_screen.dart           Main dashboard
│   └── search_screen.dart         City search + recents
├── widgets/
│   ├── animated_background.dart   Animated gradient + floating orbs
│   ├── weather_particles.dart     Rain/snow/cloud particle system
│   ├── weather_icon_3d.dart       Rotating 3D icon with glow
│   ├── weather_card_3d.dart       Draggable 3D-tilt hero card
│   ├── glass_container.dart       Reusable glassmorphism card
│   ├── hourly_forecast.dart       Horizontal hourly scroller
│   └── forecast_list.dart         5-day forecast with min/max bar
├── theme/app_theme.dart
└── utils/weather_utils.dart       Icon/color/gradient mapping per condition
```

## 🗂 Project Structure (Backend)

```
backend/
├── server.js         Express app: routes, caching, normalization
├── package.json
└── .env.example
```

---

## 🔌 API Reference (Backend)

| Method | Endpoint | Description |
|--------|----------|--------------|
| GET | `/api/weather/city/:city?units=metric` | Current weather by city name |
| GET | `/api/weather/coords?lat=&lon=&units=metric` | Current weather by coordinates |
| GET | `/api/forecast/city/:city?units=metric` | Hourly + 5-day forecast by city |
| GET | `/api/forecast/coords?lat=&lon=&units=metric` | Hourly + 5-day forecast by coordinates |
| GET | `/api/search?q=` | City search/geocoding (autocomplete) |

`units` accepts `metric` (°C) or `imperial` (°F).

---

## 🎨 Why it looks the way it does

Instead of relying on downloaded Lottie files or bundled image assets (which would
require a network connection to fetch and bloat the zip), every visual effect is
built with plain Flutter primitives — `CustomPainter`, `Matrix4` perspective
transforms, `AnimationController`s, and `BackdropFilter` blur. That means:
- The project runs immediately after `flutter pub get`, with nothing extra to download
- It's easy to re-theme (all colors/gradients live in `utils/weather_utils.dart`)
- It's lightweight and performs well even on mid-range devices

---

## 🛣 Ideas for extending this further

- Add push notifications for severe weather alerts
- Add a home-screen widget (Android/iOS) showing current temp
- Swap the free OpenWeatherMap forecast endpoint for One Call API 3.0 for true daily min/max + UV index
- Add air quality index card
- Add a settings screen (theme, default city, refresh interval)
- Deploy the backend to Render/Railway/Fly.io and ship the API URL via `--dart-define`
- Read more about my projects on https://neemii.dev/projects/

---

## 📄 License

MIT — do whatever you like with this, attribution appreciated but not required.
