class Country {
  const Country({
    required this.name,
    required this.flag,
    required this.dial,
  });

  final String name;
  final String flag;
  final String dial;
}

const List<Country> kCountries = [
  Country(name: 'Nigeria', flag: '🇳🇬', dial: '+234'),
  Country(name: 'Ghana', flag: '🇬🇭', dial: '+233'),
  Country(name: 'Kenya', flag: '🇰🇪', dial: '+254'),
  Country(name: 'South Africa', flag: '🇿🇦', dial: '+27'),
  Country(name: 'United Kingdom', flag: '🇬🇧', dial: '+44'),
  Country(name: 'United States', flag: '🇺🇸', dial: '+1'),
  Country(name: 'Canada', flag: '🇨🇦', dial: '+1'),
  Country(name: 'India', flag: '🇮🇳', dial: '+91'),
  Country(name: 'France', flag: '🇫🇷', dial: '+33'),
  Country(name: 'Germany', flag: '🇩🇪', dial: '+49'),
];
