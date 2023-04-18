class UpdateQualifying {
    UpdateQualifying({
        required this.qualifiying,
    });

    String qualifiying;

    factory UpdateQualifying.fromJson(Map<String, dynamic> json) => UpdateQualifying(
        qualifiying: json["qualifiying"],
    );

    Map<String, dynamic> toJson() => {
        "qualifiying": qualifiying,
    };
}