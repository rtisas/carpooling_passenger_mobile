import 'package:carpooling_passenger/data/models/helpers/only_id.dart';
import 'package:carpooling_passenger/data/models/virtual_wallet/virtual_wallet.dart';

class HisotoryRecharge {
    HisotoryRecharge({
        required this.paymentValue,
        required this.referenceNumber,
        required this.id,
        required this.paymentDate,
        required this.virtualWallet,
        required this.paymentDescription,
        required this.updater,
    });

    int paymentValue;
    String referenceNumber;
    int id;
    String paymentDate;
    VirtualWalletResponse virtualWallet;
    String paymentDescription;
    OnlyId updater;

    factory HisotoryRecharge.fromJson(Map<String, dynamic> json) => HisotoryRecharge(
        paymentValue: json["paymentValue"],
        referenceNumber: json["referenceNumber"],
        id: json["id"],
        paymentDate: json["paymentDate"],
        virtualWallet: VirtualWalletResponse.fromJson(json["virtualWallet"]),
        paymentDescription: json["paymentDescription"],
        updater: OnlyId.fromJson(json["updater"]),
    );

    Map<String, dynamic> toJson() => {
        "paymentValue": paymentValue,
        "referenceNumber": referenceNumber,
        "id": id,
        "paymentDate": paymentDate,
        "virtualWallet": virtualWallet.toJson(),
        "paymentDescription": paymentDescription,
        "updater": updater.toJson(),
    };
}