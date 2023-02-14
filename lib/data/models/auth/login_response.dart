import '../user/user.dart';

class LoginResponse {
    LoginResponse({
        required this.token,
        required this.user,
    });

    String token;
    User user;

    factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        token: json["token"],
        user: User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "token": token,
        "user": user.toJson(),
    };
}