import 'package:carpooling_passenger/data/models/helpers/only_id.dart';

class FileCarpooling {
    FileCarpooling({
        required this.nameFile,
        required this.id,
        required this.user,
        required this.url,
        required this.fileType,
    });

    String nameFile;
    int id;
    OnlyId user;
    String url;
    OnlyId fileType;

    factory FileCarpooling.fromJson(Map<String, dynamic> json) => FileCarpooling(
        nameFile: json["nameFile"],
        id: json["id"],
        user: OnlyId.fromJson(json["user"]),
        url: json["url"],
        fileType: OnlyId.fromJson(json["fileType"]),
    );

    Map<String, dynamic> toJson() => {
        "nameFile": nameFile,
        "id": id,
        "user": user.toJson(),
        "url": url,
        "fileType": fileType.toJson(),
    };
}