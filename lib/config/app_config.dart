class AppConfig {
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://your-project.supabase.co',
  );
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'your-anon-key',
  );
  static const String weatherApiKey = String.fromEnvironment(
    'WEATHER_API_KEY',
    defaultValue: 'your-openweather-api-key',
  );
  static const String appName = '智能衣橱';
  static const String version = '1.0.0';
  static const String bucketClothing = 'clothing';
  static const String bucketAvatars = 'avatars';
  static const String bucketOutfits = 'outfits';
  static const int maxPhotosPerItem = 5;
}
