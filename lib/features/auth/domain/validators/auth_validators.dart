class AuthValidators {
  // Email doğrulama regex'i
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return emailRegex.hasMatch(email);
  }

  // Şifrelerin eşleşip eşleşmediğini kontrol eder
  static bool isPasswordMatching(String password, String confirmPassword) {
    return password == confirmPassword;
  }

  // Şifre uzunluğu doğrulaması (opsiyonel olarak eklenebilir)
  static bool isPasswordLengthValid(String password, {int minLength = 6}) {
    return password.length >= minLength;
  }
}
