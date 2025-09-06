# Weather App

A simple Flutter weather app using the OpenWeatherMap API.

## Features

- Search weather by city name
- Shows current weather, hourly forecast, and additional info (humidity, wind, pressure, visibility)
- Responsive and modern UI
- Error handling for invalid city names
- Sun/Moon/Cloud icons based on weather and time

## Screenshots

<!-- Add your screenshots here -->
<!-- ![screenshot](screenshots/screen1.png) -->

## Getting Started

1. **Clone this repo:**
   ```sh
   git clone https://github.com/your-username/your-repo-name.git
   cd your-repo-name
   ```

2. **Install dependencies:**
   ```sh
   flutter pub get
   ```

3. **Set up your API key:**
   - Copy `lib/secrets.example.dart` to `lib/secrets.dart`
   - Add your [OpenWeatherMap](https://openweathermap.org/api) API key in `lib/secrets.dart`:
     ```dart
     const openWeatherapiKey = 'YOUR_API_KEY_HERE';
     ```

4. **Run the app:**
   ```sh
   flutter run
   ```

## Build APK

```sh
flutter build apk --release
```
The APK will be in `build/app/outputs/flutter-apk/app-release.apk`.

## Notes

- Do **not** commit your real API key. `lib/secrets.dart` is in `.gitignore`.
- For a new API key, sign up at [OpenWeatherMap](https://openweathermap.org/api).

## Credits

- [Flutter](https://flutter.dev/)
- [OpenWeatherMap](https://openweathermap.org/)
- [weather_icons package](https://pub.dev/packages/weather_icons) (optional)

---

Feel free to fork, star, and contribute!
