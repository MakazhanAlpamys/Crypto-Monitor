# CryptoTracker

A premium cryptocurrency tracking application built with Flutter. Monitor real-time crypto prices, manage your watchlist, and stay updated with the latest market trends.

![Flutter](https://img.shields.io/badge/Flutter-3.x-blue)
![Dart](https://img.shields.io/badge/Dart-3.x-blue)
![License](https://img.shields.io/badge/License-MIT-green)

## Features

### 📊 Market Overview
- Real-time cryptocurrency prices
- Price charts with multiple time ranges (24h, 7d, 30d, 90d, 1y)
- Market cap, volume, and supply statistics
- All-time high/low tracking

### ⭐ Watchlist
- Add favorite coins to watchlist
- Sync across devices (requires account)
- Quick access to tracked cryptocurrencies

### 👤 User Management
- **Sign In / Sign Up** - Create account or sign in
- **Guest Mode** - Browse market without registration
- **Profile Management** - Manage your account settings

### 🌐 Multi-Language Support
- 🇺🇸 English
- 🇷🇺 Русский (Russian)
- 🇰🇿 Қазақша (Kazakh)

### 🎨 Themes
- Dark Mode (default)
- Light Mode
- System Theme

### 🔧 Technical Features
- Built with Flutter & Riverpod for state management
- Supabase backend for authentication and data storage
- CoinGecko API for cryptocurrency data
- Responsive design for all screen sizes

## Screenshots

| Market | Coin Details | Watchlist | Profile |
|--------|--------------|-----------|---------|
| 📈 | 📊 | ⭐ | 👤 |

## Getting Started

### Prerequisites
- Flutter SDK 3.x
- Dart SDK 3.x
- Supabase project (for auth features)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/MakazhanAlpamys/Crypto-Monitor.git
cd crypto
```

2. Install dependencies:
```bash
flutter pub get
```

3. Configure Supabase:
   - Create a project at [supabase.com](https://supabase.com)
   - Update `lib/core/config/supabase_config.dart` with your credentials

4. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
├── core/
│   ├── config/          # App configuration
│   ├── constants/       # App constants
│   ├── localization/    # Multi-language support
│   ├── theme/           # App themes (dark/light)
│   └── utils/           # Utility functions
├── data/
│   ├── datasources/     # API clients
│   ├── models/          # Data models
│   └── repositories/    # Data repositories
├── providers/           # Riverpod providers
└── ui/
    ├── pages/           # Screen pages
    └── widgets/         # Reusable widgets
```

## Technologies Used

- **Flutter** - UI framework
- **Riverpod** - State management
- **Supabase** - Backend (Auth, Database)
- **CoinGecko API** - Cryptocurrency data
- **fl_chart** - Charts
- **Google Fonts** - Typography

## API

This app uses the [CoinGecko API](https://www.coingecko.com/en/api) for cryptocurrency data.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- [CoinGecko](https://www.coingecko.com/) for providing cryptocurrency data API
- [Supabase](https://supabase.com/) for backend infrastructure
- Flutter community for amazing packages
