import 'package:for_dev/domain/entities/entities_exports.dart';

class AccountModel {
  final String accessToken;

  AccountModel(this.accessToken);

  factory AccountModel.fromJson(Map json) => AccountModel(json['accessToken']);

  AccountEntity toEntity() => AccountEntity(accessToken);
}
