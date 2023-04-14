
class PushTokenRequest {
    PushTokenRequest({
        required this.pushtoken,
    });

    String pushtoken;

    factory PushTokenRequest.fromJson(Map<String, dynamic> json) => PushTokenRequest(
        pushtoken: json["pushtoken"],
    );

    Map<String, dynamic> toJson() => {
        "pushtoken": pushtoken,
    };
}