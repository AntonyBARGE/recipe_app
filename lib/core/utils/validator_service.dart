class ValidatorService {
  static const EMAIL_REGEX =
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
  static String? validateEmail(String value) {
    if (value.contains('@yopmail')) return "validation.email";

    value = value.replaceAll(RegExp(r"\s+\b|\b\s"), "");

    RegExp regex = RegExp(EMAIL_REGEX);

    return !regex.hasMatch(value) ? 'validation.email' : null;
  }

  static String? samePasswordValidation(String password, String repassword) =>
      password != repassword ? 'validation.password.verif' : null;

  static String? validatePassword(String value) {
    const pattern = r'^.{8,}$';
    RegExp regex = RegExp(pattern);

    return !regex.hasMatch(value) ? 'validation.password' : null;
  }

  static String? validateUsername(String value) {
    const pattern = r'^[(a-z)|(A-Z)|(0-9)|( )]{6,20}$';
    RegExp regex = RegExp(pattern);
    return !regex.hasMatch(value.trim()) ? 'validation.username' : null;
  }

  static String? validateRequired(String? value) =>
      value == null || value.trim().isEmpty ? 'Ce champ est obligatoire' : null;
}
