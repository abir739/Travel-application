import 'package:json_annotation/json_annotation.dart';

part 'usersmodel.g.dart';

@JsonSerializable()
class User {
  String? id;
  String? role;
  String? username;
  String? password;
  String? salt;
  String? logo;
  String? phone;
  String? email;
  String? gender;
  String? firstName;
  String? lastName;
  DateTime? birthDate;
  String? picture;
  String? address;
  String? zipCode;
  String? countryId;
  String? stateId;
  String? cityId;
  String? languageId;
  String? secondLanguageId;
  String? facebookKey;
  String? profile;
  bool? enableOauth;
  int? sessionTimeout;
  bool? multipleSession;
  bool? phoneValidated;
  String? phoneValidationCode;
  bool? emailValidated;
  String? emailValidationCode;
  String? authenticationMode;
  bool? enabled;
  String? confirmationToken;
  DateTime? passwordRequestedAt;
  bool? locked;
  bool? expired;
  DateTime? expiresAt;
  bool? credentialsExpired;
  DateTime? credentialsExpireAt;
  DateTime? lastLogin;
  DateTime? lastFailedLogin;
  int? loginCount;
  int? failedLoginCount;
  int? lastFailedLoginCount;
  DateTime? createdAt;
  String? creatorUserId;
  DateTime? updatedAt;
  String? updaterUserId;

  // Relationships
  // String? country;
  // String? state;
  // String? city;
  // String? language;
  // String? secondLanguage;

  User({
    this.id,
    this.role,
    this.username,
    this.password,
    this.salt,
    this.logo,
    this.phone,
    this.email,
    this.gender,
    this.firstName,
    this.lastName,
    this.birthDate,
    this.picture,
    this.address,
    this.zipCode,
    this.countryId,
    this.stateId,
    this.cityId,
    this.languageId,
    this.secondLanguageId,
    this.facebookKey,
    this.profile,
    this.enableOauth,
    this.sessionTimeout,
    this.multipleSession,
    this.phoneValidated,
    this.phoneValidationCode,
    this.emailValidated,
    this.emailValidationCode,
    this.authenticationMode,
    this.enabled,
    this.confirmationToken,
    this.passwordRequestedAt,
    this.locked,
    this.expired,
    this.expiresAt,
    this.credentialsExpired,
    this.credentialsExpireAt,
    this.lastLogin,
    this.lastFailedLogin,
    this.loginCount,
    this.failedLoginCount,
    this.lastFailedLoginCount,
    this.createdAt,
    this.creatorUserId,
    this.updatedAt,
    this.updaterUserId,
    // this.country,
    // this.state,
    // this.city,
    // this.language,
    // this.secondLanguage,
  });
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
