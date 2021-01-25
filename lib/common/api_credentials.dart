class ApiCredentials {
  static final ApiCredentials _apiCredentials = new ApiCredentials._();

  factory ApiCredentials() {
    return _apiCredentials;
  }

  ApiCredentials._();

  final String _apiKey = "YOUR_API_HERE";
  String get apiKey => _apiKey;
}
