class SignInFormModel {
  final String? nis;
  final String? password;

  SignInFormModel({
    this.nis,
    this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'nis': nis,
      'password': password,
    };
  }

  SignInFormModel copyWith({
    String? nis,
    String? password,
  }) =>
      SignInFormModel(
          nis: nis ?? this.nis, password: password ?? this.password);
}
