abstract final class CompanyRegistrationValidators {
  static String? requiredText(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName es obligatorio';
    }
    return null;
  }

  static String? document(String? value) {
    final document = value?.trim() ?? '';
    if (document.isEmpty) return 'El documento es obligatorio';
    if (!RegExp(r'^[A-Za-z0-9-]+$').hasMatch(document)) {
      return 'Usá únicamente letras, números o guiones';
    }
    if (document.length < 5) return 'Ingresá un documento válido';
    return null;
  }

  static String? phone(String? value) {
    final phone = value?.trim() ?? '';
    if (phone.isEmpty) return 'El número de teléfono es obligatorio';
    if (!RegExp(r'^\d{8}$').hasMatch(phone)) {
      return 'Ingresá un número válido de 8 dígitos';
    }
    return null;
  }

  static String? optionalEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return null;
    final valid = RegExp(
      r"^[A-Za-z0-9.!#$%&'*+/=?^_`{|}~-]+@[A-Za-z0-9-]+(?:\.[A-Za-z0-9-]+)+$",
    ).hasMatch(email);
    return valid ? null : 'Ingresá un correo electrónico válido';
  }

  static String? password(String? value) {
    final password = value ?? '';
    if (password.isEmpty) return 'La contraseña es obligatoria';
    if (password.length < 8) return 'Debe tener al menos 8 caracteres';
    if (!RegExp('[A-Za-z]').hasMatch(password)) {
      return 'Debe incluir al menos una letra';
    }
    if (!RegExp(r'\d').hasMatch(password)) {
      return 'Debe incluir al menos un número';
    }
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) return 'Repetí tu contraseña';
    if (value != password) return 'Las contraseñas no coinciden';
    return null;
  }
}
