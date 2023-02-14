class OnlyId {
    OnlyId({
        required this.id,
    });

    int id;

    factory OnlyId.fromJson(Map<String, dynamic> json) => OnlyId(
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
    };
}