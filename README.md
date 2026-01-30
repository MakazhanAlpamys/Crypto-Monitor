# CryptoTracker

A premium cryptocurrency tracking application built with Flutter. Monitor real-time crypto prices, manage your portfolio, track your watchlist, exchange crypto assets, and stay updated with the latest market trends.

![Flutter](https://img.shields.io/badge/Flutter-3.x-blue)
![Dart](https://img.shields.io/badge/Dart-3.x-blue)
![License](https://img.shields.io/badge/License-MIT-green)

## Features

### 📊 Market Overview
- Real-time cryptocurrency prices
- Price charts with multiple time ranges (24h, 7d, 30d, 90d, 1y)
- Market cap, volume, and supply statistics
- All-time high/low tracking
- **Top Gainers & Top Losers** sections with horizontal scrolling cards
- Mini sparkline charts for quick trend visualization

### 💼 Portfolio Management (NEW!)
- Track your crypto holdings with beautiful UI
- Total balance card with gradient design
- Pie chart distribution of assets
- Profit/Loss tracking per asset and overall
- 24h change monitoring
- Quick actions: Deposit, Withdraw, Exchange
- Individual asset performance tracking

### 💱 Exchange (NEW!)
- Simulated crypto-to-crypto exchange
- Buy/Sell mode toggle
- Real-time exchange rate calculation
- Fee estimation display
- Coin selection modal with search
- Exchange confirmation dialog

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
- Dark Mode (default) with premium glass-morphism design
- Light Mode
- System Theme

### 🔧 Technical Features
- Built with Flutter & Riverpod for state management
- Supabase backend for authentication and data storage
- CoinGecko API for cryptocurrency data
- Responsive design for all screen sizes
- Beautiful animations with flutter_animate
- Interactive charts with fl_chart

## Screenshots

| Market | Portfolio | Exchange | Coin Details |
|--------|-----------|----------|--------------|
| 📈 | 💼 | 💱 | 📊 |

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
│   ├── config/          # App configuration (API, Supabase)
│   ├── constants/       # App constants
│   ├── localization/    # Multi-language support
│   ├── theme/           # App themes (dark/light) & colors
│   └── utils/           # Utility functions & formatters
├── data/
│   ├── datasources/     # API clients (CoinGecko)
│   ├── models/          # Data models (Coin, Portfolio, Chart)
│   └── repositories/    # Data repositories
├── providers/           # Riverpod providers
│   ├── providers.dart   # Main providers
│   ├── portfolio_provider.dart  # Portfolio state management
│   └── auth_notifier.dart       # Auth state
└── ui/
    ├── pages/
    │   ├── auth/        # Login, Register pages
    │   ├── coin_details/ # Coin details with charts
    │   ├── exchange/    # Crypto exchange page
    │   ├── home/        # Home & Profile pages
    │   ├── market/      # Market overview page
    │   ├── portfolio/   # Portfolio management page
    │   └── watchlist/   # Watchlist page
    └── widgets/
        ├── cards/       # Coin cards, stat cards
        ├── charts/      # Price charts
        ├── common/      # Glass container, shimmer, text fields
        └── sections/    # Trending section
```

## Technologies Used

- **Flutter** - UI framework
- **Riverpod** - State management
- **Supabase** - Backend (Auth, Database)
- **CoinGecko API** - Cryptocurrency data
- **fl_chart** - Charts
- **flutter_animate** - Animations
- **Google Fonts** - Typography
- **Dio** - HTTP client
- **cached_network_image** - Image caching

## New Features in v2.0

### Portfolio Page
- Beautiful gradient balance card
- Asset distribution pie chart
- Individual asset tracking with P/L
- Quick action buttons

### Exchange Page
- Buy/Sell cryptocurrency simulation
- Real-time rate calculation
- Network and exchange fee display
- Coin selector with search

### Trending Section
- Top Gainers horizontal scroll
- Top Losers horizontal scroll
- Mini sparkline charts
- Animated cards

### Enhanced Navigation
- 4-tab bottom navigation (Market, Portfolio, Watchlist, Profile)
- Smooth transitions
- Active state indicators

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
- CryptoHub project for design inspiration
