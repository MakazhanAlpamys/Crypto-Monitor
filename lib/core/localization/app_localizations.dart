// App Localizations - Support for EN, RU, KZ languages

enum AppLanguage {
  english('en', 'English', '🇺🇸'),
  russian('ru', 'Русский', '🇷🇺'),
  kazakh('kk', 'Қазақша', '🇰🇿');

  const AppLanguage(this.code, this.name, this.flag);
  final String code;
  final String name;
  final String flag;
}

class AppLocalizations {
  final AppLanguage language;

  AppLocalizations(this.language);

  static final Map<String, Map<AppLanguage, String>> _localizedStrings = {
    // Auth - Login
    'welcomeBack': {
      AppLanguage.english: 'Welcome Back',
      AppLanguage.russian: 'С возвращением',
      AppLanguage.kazakh: 'Қош келдіңіз',
    },
    'signInToContinue': {
      AppLanguage.english: 'Sign in to continue tracking your crypto',
      AppLanguage.russian: 'Войдите, чтобы продолжить отслеживание криптовалют',
      AppLanguage.kazakh: 'Криптовалютаны бақылауды жалғастыру үшін кіріңіз',
    },
    'emailAddress': {
      AppLanguage.english: 'Email address',
      AppLanguage.russian: 'Электронная почта',
      AppLanguage.kazakh: 'Электрондық пошта',
    },
    'password': {
      AppLanguage.english: 'Password',
      AppLanguage.russian: 'Пароль',
      AppLanguage.kazakh: 'Құпия сөз',
    },
    'forgotPassword': {
      AppLanguage.english: 'Forgot password?',
      AppLanguage.russian: 'Забыли пароль?',
      AppLanguage.kazakh: 'Құпия сөзді ұмыттыңыз ба?',
    },
    'signIn': {
      AppLanguage.english: 'Sign In',
      AppLanguage.russian: 'Войти',
      AppLanguage.kazakh: 'Кіру',
    },
    'dontHaveAccount': {
      AppLanguage.english: "Don't have an account? ",
      AppLanguage.russian: 'Нет аккаунта? ',
      AppLanguage.kazakh: 'Аккаунтыңыз жоқ па? ',
    },
    'signUp': {
      AppLanguage.english: 'Sign Up',
      AppLanguage.russian: 'Регистрация',
      AppLanguage.kazakh: 'Тіркелу',
    },
    'continueAsGuest': {
      AppLanguage.english: 'Continue as Guest',
      AppLanguage.russian: 'Продолжить как гость',
      AppLanguage.kazakh: 'Қонақ ретінде жалғастыру',
    },
    'or': {
      AppLanguage.english: 'or',
      AppLanguage.russian: 'или',
      AppLanguage.kazakh: 'немесе',
    },

    // Auth - Sign Up
    'createAccount': {
      AppLanguage.english: 'Create Account',
      AppLanguage.russian: 'Создать аккаунт',
      AppLanguage.kazakh: 'Аккаунт құру',
    },
    'startTracking': {
      AppLanguage.english: 'Start tracking your favorite cryptocurrencies',
      AppLanguage.russian: 'Начните отслеживать любимые криптовалюты',
      AppLanguage.kazakh: 'Сүйікті криптовалюталарыңызды бақылауды бастаңыз',
    },
    'confirmPassword': {
      AppLanguage.english: 'Confirm password',
      AppLanguage.russian: 'Подтвердите пароль',
      AppLanguage.kazakh: 'Құпия сөзді растаңыз',
    },
    'passwordMustContain': {
      AppLanguage.english: 'Password must contain:',
      AppLanguage.russian: 'Пароль должен содержать:',
      AppLanguage.kazakh: 'Құпия сөз құрамында болуы керек:',
    },
    'atLeast6Chars': {
      AppLanguage.english: 'At least 6 characters',
      AppLanguage.russian: 'Минимум 6 символов',
      AppLanguage.kazakh: 'Кемінде 6 таңба',
    },
    'mixOfLettersNumbers': {
      AppLanguage.english: 'A mix of letters and numbers recommended',
      AppLanguage.russian: 'Рекомендуется сочетание букв и цифр',
      AppLanguage.kazakh: 'Әріптер мен сандардың араласуы ұсынылады',
    },
    'alreadyHaveAccount': {
      AppLanguage.english: 'Already have an account? ',
      AppLanguage.russian: 'Уже есть аккаунт? ',
      AppLanguage.kazakh: 'Аккаунтыңыз бар ма? ',
    },

    // Validation
    'pleaseEnterEmail': {
      AppLanguage.english: 'Please enter your email',
      AppLanguage.russian: 'Пожалуйста, введите email',
      AppLanguage.kazakh: 'Электрондық поштаңызды енгізіңіз',
    },
    'pleaseEnterValidEmail': {
      AppLanguage.english: 'Please enter a valid email',
      AppLanguage.russian: 'Пожалуйста, введите корректный email',
      AppLanguage.kazakh: 'Жарамды электрондық поштаны енгізіңіз',
    },
    'pleaseEnterPassword': {
      AppLanguage.english: 'Please enter your password',
      AppLanguage.russian: 'Пожалуйста, введите пароль',
      AppLanguage.kazakh: 'Құпия сөзіңізді енгізіңіз',
    },
    'passwordTooShort': {
      AppLanguage.english: 'Password must be at least 6 characters',
      AppLanguage.russian: 'Пароль должен содержать минимум 6 символов',
      AppLanguage.kazakh: 'Құпия сөз кемінде 6 таңбадан тұруы керек',
    },
    'pleaseConfirmPassword': {
      AppLanguage.english: 'Please confirm your password',
      AppLanguage.russian: 'Пожалуйста, подтвердите пароль',
      AppLanguage.kazakh: 'Құпия сөзді растаңыз',
    },
    'passwordsDoNotMatch': {
      AppLanguage.english: 'Passwords do not match',
      AppLanguage.russian: 'Пароли не совпадают',
      AppLanguage.kazakh: 'Құпия сөздер сәйкес келмейді',
    },

    // Messages
    'welcomeBackMsg': {
      AppLanguage.english: 'Welcome back!',
      AppLanguage.russian: 'С возвращением!',
      AppLanguage.kazakh: 'Қош келдіңіз!',
    },
    'loginFailed': {
      AppLanguage.english: 'Login failed',
      AppLanguage.russian: 'Ошибка входа',
      AppLanguage.kazakh: 'Кіру қатесі',
    },
    'accountCreated': {
      AppLanguage.english: 'Account created successfully!',
      AppLanguage.russian: 'Аккаунт успешно создан!',
      AppLanguage.kazakh: 'Аккаунт сәтті құрылды!',
    },
    'checkEmail': {
      AppLanguage.english: 'Account created! Check your email to verify.',
      AppLanguage.russian: 'Аккаунт создан! Проверьте почту для подтверждения.',
      AppLanguage.kazakh: 'Аккаунт құрылды! Растау үшін поштаңызды тексеріңіз.',
    },
    'signUpFailed': {
      AppLanguage.english: 'Sign up failed',
      AppLanguage.russian: 'Ошибка регистрации',
      AppLanguage.kazakh: 'Тіркелу қатесі',
    },

    // Profile Page
    'profile': {
      AppLanguage.english: 'Profile',
      AppLanguage.russian: 'Профиль',
      AppLanguage.kazakh: 'Профиль',
    },
    'manageYourAccount': {
      AppLanguage.english: 'Manage your account',
      AppLanguage.russian: 'Управление аккаунтом',
      AppLanguage.kazakh: 'Аккаунтты басқару',
    },
    'signedIn': {
      AppLanguage.english: 'Signed In',
      AppLanguage.russian: 'В системе',
      AppLanguage.kazakh: 'Жүйеде',
    },
    'guestMode': {
      AppLanguage.english: 'Guest Mode',
      AppLanguage.russian: 'Гостевой режим',
      AppLanguage.kazakh: 'Қонақ режимі',
    },
    'signOut': {
      AppLanguage.english: 'Sign Out',
      AppLanguage.russian: 'Выйти',
      AppLanguage.kazakh: 'Шығу',
    },
    'signInToAccount': {
      AppLanguage.english: 'Sign in to your account',
      AppLanguage.russian: 'Войдите в аккаунт',
      AppLanguage.kazakh: 'Аккаунтқа кіріңіз',
    },
    'accessWatchlist': {
      AppLanguage.english: 'Access your watchlist and sync across devices',
      AppLanguage.russian: 'Доступ к избранному и синхронизация между устройствами',
      AppLanguage.kazakh: 'Таңдаулыларға қол жеткізу және құрылғылар арасында синхрондау',
    },
    'settings': {
      AppLanguage.english: 'Settings',
      AppLanguage.russian: 'Настройки',
      AppLanguage.kazakh: 'Баптаулар',
    },
    'notifications': {
      AppLanguage.english: 'Notifications',
      AppLanguage.russian: 'Уведомления',
      AppLanguage.kazakh: 'Хабарламалар',
    },
    'enabled': {
      AppLanguage.english: 'Enabled',
      AppLanguage.russian: 'Включено',
      AppLanguage.kazakh: 'Қосылған',
    },
    'disabled': {
      AppLanguage.english: 'Disabled',
      AppLanguage.russian: 'Отключено',
      AppLanguage.kazakh: 'Өшірілген',
    },
    'theme': {
      AppLanguage.english: 'Theme',
      AppLanguage.russian: 'Тема',
      AppLanguage.kazakh: 'Тақырып',
    },
    'dark': {
      AppLanguage.english: 'Dark',
      AppLanguage.russian: 'Тёмная',
      AppLanguage.kazakh: 'Қараңғы',
    },
    'light': {
      AppLanguage.english: 'Light',
      AppLanguage.russian: 'Светлая',
      AppLanguage.kazakh: 'Жарық',
    },
    'system': {
      AppLanguage.english: 'System',
      AppLanguage.russian: 'Системная',
      AppLanguage.kazakh: 'Жүйелік',
    },
    'language': {
      AppLanguage.english: 'Language',
      AppLanguage.russian: 'Язык',
      AppLanguage.kazakh: 'Тіл',
    },
    'selectLanguage': {
      AppLanguage.english: 'Select Language',
      AppLanguage.russian: 'Выберите язык',
      AppLanguage.kazakh: 'Тілді таңдаңыз',
    },
    'selectTheme': {
      AppLanguage.english: 'Select Theme',
      AppLanguage.russian: 'Выберите тему',
      AppLanguage.kazakh: 'Тақырыпты таңдаңыз',
    },
    'about': {
      AppLanguage.english: 'About',
      AppLanguage.russian: 'О приложении',
      AppLanguage.kazakh: 'Қолданба туралы',
    },
    'version': {
      AppLanguage.english: 'Version',
      AppLanguage.russian: 'Версия',
      AppLanguage.kazakh: 'Нұсқа',
    },
    'privacyPolicy': {
      AppLanguage.english: 'Privacy Policy',
      AppLanguage.russian: 'Политика конфиденциальности',
      AppLanguage.kazakh: 'Құпиялылық саясаты',
    },
    'readPrivacyPolicy': {
      AppLanguage.english: 'Read our privacy policy',
      AppLanguage.russian: 'Ознакомьтесь с политикой',
      AppLanguage.kazakh: 'Саясатпен танысыңыз',
    },
    'termsOfService': {
      AppLanguage.english: 'Terms of Service',
      AppLanguage.russian: 'Условия использования',
      AppLanguage.kazakh: 'Қызмет көрсету шарттары',
    },
    'readTerms': {
      AppLanguage.english: 'Read our terms',
      AppLanguage.russian: 'Ознакомьтесь с условиями',
      AppLanguage.kazakh: 'Шарттармен танысыңыз',
    },
    'poweredBy': {
      AppLanguage.english: 'Powered by CoinGecko API',
      AppLanguage.russian: 'Работает на CoinGecko API',
      AppLanguage.kazakh: 'CoinGecko API негізінде жұмыс істейді',
    },

    // Sign out dialog
    'signOutConfirm': {
      AppLanguage.english: 'Are you sure you want to sign out?',
      AppLanguage.russian: 'Вы уверены, что хотите выйти?',
      AppLanguage.kazakh: 'Шығуға сенімдісіз бе?',
    },
    'cancel': {
      AppLanguage.english: 'Cancel',
      AppLanguage.russian: 'Отмена',
      AppLanguage.kazakh: 'Болдырмау',
    },

    // Watchlist
    'watchlist': {
      AppLanguage.english: 'Watchlist',
      AppLanguage.russian: 'Избранное',
      AppLanguage.kazakh: 'Таңдаулылар',
    },
    'yourFavoriteCoins': {
      AppLanguage.english: 'Your favorite coins',
      AppLanguage.russian: 'Ваши избранные монеты',
      AppLanguage.kazakh: 'Сіздің таңдаулы монеталарыңыз',
    },
    'noFavoritesYet': {
      AppLanguage.english: 'No favorites yet',
      AppLanguage.russian: 'Пока нет избранных',
      AppLanguage.kazakh: 'Әзірге таңдаулылар жоқ',
    },
    'startAddingCoins': {
      AppLanguage.english: 'Start adding coins to your watchlist\nby tapping the star icon',
      AppLanguage.russian: 'Добавляйте монеты в избранное\nнажав на иконку звезды',
      AppLanguage.kazakh: 'Жұлдыз белгішесін басу арқылы\nтаңдаулыларға монеталар қосыңыз',
    },
    'exploreMarket': {
      AppLanguage.english: 'Explore Market',
      AppLanguage.russian: 'Исследовать рынок',
      AppLanguage.kazakh: 'Нарықты зерттеу',
    },
    'signInRequired': {
      AppLanguage.english: 'Sign in Required',
      AppLanguage.russian: 'Требуется вход',
      AppLanguage.kazakh: 'Кіру қажет',
    },
    'signInToSave': {
      AppLanguage.english: 'Sign in to save your favorite\ncryptocurrencies to your watchlist',
      AppLanguage.russian: 'Войдите, чтобы сохранять\nизбранные криптовалюты',
      AppLanguage.kazakh: 'Таңдаулы криптовалюталарды\nсақтау үшін кіріңіз',
    },
    'failedToLoad': {
      AppLanguage.english: 'Failed to load watchlist',
      AppLanguage.russian: 'Не удалось загрузить избранное',
      AppLanguage.kazakh: 'Таңдаулыларды жүктеу сәтсіз аяқталды',
    },
    'tryAgain': {
      AppLanguage.english: 'Try Again',
      AppLanguage.russian: 'Повторить',
      AppLanguage.kazakh: 'Қайталау',
    },
    'removeFromWatchlist': {
      AppLanguage.english: 'Remove from Watchlist',
      AppLanguage.russian: 'Удалить из избранного',
      AppLanguage.kazakh: 'Таңдаулылардан жою',
    },
    'removeFromWatchlistConfirm': {
      AppLanguage.english: 'Remove %s from your watchlist?',
      AppLanguage.russian: 'Удалить %s из избранного?',
      AppLanguage.kazakh: '%s-ті таңдаулылардан жою керек пе?',
    },
    'remove': {
      AppLanguage.english: 'Remove',
      AppLanguage.russian: 'Удалить',
      AppLanguage.kazakh: 'Жою',
    },
    'removedFromWatchlist': {
      AppLanguage.english: '%s removed from watchlist',
      AppLanguage.russian: '%s удалён из избранного',
      AppLanguage.kazakh: '%s таңдаулылардан жойылды',
    },
    'addedToWatchlist': {
      AppLanguage.english: 'Added to watchlist',
      AppLanguage.russian: 'Добавлено в избранное',
      AppLanguage.kazakh: 'Таңдаулыларға қосылды',
    },
    'removedFromWatchlistShort': {
      AppLanguage.english: 'Removed from watchlist',
      AppLanguage.russian: 'Удалено из избранного',
      AppLanguage.kazakh: 'Таңдаулылардан жойылды',
    },
    'signInToManageWatchlist': {
      AppLanguage.english: 'Please sign in to add coins to your watchlist.',
      AppLanguage.russian: 'Войдите, чтобы добавлять монеты в избранное.',
      AppLanguage.kazakh: 'Монеталарды таңдаулыларға қосу үшін кіріңіз.',
    },
    'failedToUpdate': {
      AppLanguage.english: 'Failed to update watchlist',
      AppLanguage.russian: 'Не удалось обновить избранное',
      AppLanguage.kazakh: 'Таңдаулыларды жаңарту сәтсіз аяқталды',
    },

    // Market
    'market': {
      AppLanguage.english: 'Market',
      AppLanguage.russian: 'Рынок',
      AppLanguage.kazakh: 'Нарық',
    },
    'searchCoins': {
      AppLanguage.english: 'Search coins...',
      AppLanguage.russian: 'Поиск монет...',
      AppLanguage.kazakh: 'Монеталарды іздеу...',
    },

    // Home
    'home': {
      AppLanguage.english: 'Home',
      AppLanguage.russian: 'Главная',
      AppLanguage.kazakh: 'Басты бет',
    },
  };

  String get(String key) {
    return _localizedStrings[key]?[language] ?? _localizedStrings[key]?[AppLanguage.english] ?? key;
  }

  String getFormatted(String key, String value) {
    return get(key).replaceAll('%s', value);
  }
}
