class Parameter {
    Parameter({
        required this.id,
         this.parameterName,
         this.parameterValue,
         this.parameterRelationShip,
         this.updater,
         this.updateDate,
         this.companyid,
    });

    int id;
    String? parameterName;
    String? parameterValue;
    Parameter? parameterRelationShip;
    dynamic? updater;
    DateTime? updateDate;
    dynamic? companyid;

    factory Parameter.fromJson(Map<String, dynamic> json) => Parameter(
        id: json["id"],
        parameterName: json["parameterName"],
        parameterValue:  json["parameterValue"],
        parameterRelationShip:json["parameterRelationShip"] == null
            ? null
            : Parameter.fromJson(json["parameterRelationShip"]),
        updater: json["updater"],
        updateDate: DateTime.parse(json["updateDate"]),
        companyid: json["companyid"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "parameterName": parameterName,
        "parameterValue": parameterValue,
        "parameterRelationShip": parameterRelationShip?.toJson(),
        "updater": updater,
        //Todo: Tener presente el formato de la fecha
        "updateDate": "${updateDate?.year.toString().padLeft(4, '0')}-${updateDate?.month.toString().padLeft(2, '0')}-${updateDate?.day.toString().padLeft(2, '0')}",
        "companyid": companyid,
    };
}