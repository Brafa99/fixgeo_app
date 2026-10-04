class RegisterClientData {
  const RegisterClientData({
    this.firstName = '',
    this.lastName = '',
    this.city = '',
    this.phone = '',
    this.countryCode = '+591',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.acceptedTerms = false,
  });

  final String firstName;
  final String lastName;
  final String city;
  final String phone;
  final String countryCode;
  final String email;
  final String password;
  final String confirmPassword;
  final bool acceptedTerms;

  RegisterClientData copyWith({
    String? firstName,
    String? lastName,
    String? city,
    String? phone,
    String? countryCode,
    String? email,
    String? password,
    String? confirmPassword,
    bool? acceptedTerms,
  }) {
    return RegisterClientData(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      city: city ?? this.city,
      phone: phone ?? this.phone,
      countryCode: countryCode ?? this.countryCode,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      acceptedTerms: acceptedTerms ?? this.acceptedTerms,
    );
  }
}
