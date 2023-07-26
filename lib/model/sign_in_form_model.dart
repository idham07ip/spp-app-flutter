class SignInFormModel {
  final String? nipd;
  final String? password;

  SignInFormModel({
    this.nipd,
    this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'nipd': nipd,
      'password': password,
    };
  }

  SignInFormModel copyWith({
    String? nipd,
    String? password,
  }) =>
      SignInFormModel(
          nipd: nipd ?? this.nipd, password: password ?? this.password);
}
