// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usersmodel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String?,
      role: json['role'] as String?,
      username: json['username'] as String?,
      password: json['password'] as String?,
      salt: json['salt'] as String?,
      logo: json['logo'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      gender: json['gender'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      birthDate: json['birthDate'] == null
          ? null
          : DateTime.parse(json['birthDate'] as String),
      picture: json['picture'] as String?,
      address: json['address'] as String?,
      zipCode: json['zipCode'] as String?,
      countryId: json['countryId'] as String?,
      stateId: json['stateId'] as String?,
      cityId: json['cityId'] as String?,
      languageId: json['languageId'] as String?,
      secondLanguageId: json['secondLanguageId'] as String?,
      facebookKey: json['facebookKey'] as String?,
      profile: json['profile'] as String?,
      enableOauth: json['enableOauth'] as bool?,
      sessionTimeout: json['sessionTimeout'] as int?,
      multipleSession: json['multipleSession'] as bool?,
      phoneValidated: json['phoneValidated'] as bool?,
      phoneValidationCode: json['phoneValidationCode'] as String?,
      emailValidated: json['emailValidated'] as bool?,
      emailValidationCode: json['emailValidationCode'] as String?,
      authenticationMode: json['authenticationMode'] as String?,
      enabled: json['enabled'] as bool?,
      confirmationToken: json['confirmationToken'] as String?,
      passwordRequestedAt: json['passwordRequestedAt'] == null
          ? null
          : DateTime.parse(json['passwordRequestedAt'] as String),
      locked: json['locked'] as bool?,
      expired: json['expired'] as bool?,
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      credentialsExpired: json['credentialsExpired'] as bool?,
      credentialsExpireAt: json['credentialsExpireAt'] == null
          ? null
          : DateTime.parse(json['credentialsExpireAt'] as String),
      lastLogin: json['lastLogin'] == null
          ? null
          : DateTime.parse(json['lastLogin'] as String),
      lastFailedLogin: json['lastFailedLogin'] == null
          ? null
          : DateTime.parse(json['lastFailedLogin'] as String),
      loginCount: json['loginCount'] as int?,
      failedLoginCount: json['failedLoginCount'] as int?,
      lastFailedLoginCount: json['lastFailedLoginCount'] as int?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      creatorUserId: json['creatorUserId'] as String?,
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      updaterUserId: json['updaterUserId'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'role': instance.role,
      'username': instance.username,
      'password': instance.password,
      'salt': instance.salt,
      'logo': instance.logo,
      'phone': instance.phone,
      'email': instance.email,
      'gender': instance.gender,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'birthDate': instance.birthDate?.toIso8601String(),
      'picture': instance.picture,
      'address': instance.address,
      'zipCode': instance.zipCode,
      'countryId': instance.countryId,
      'stateId': instance.stateId,
      'cityId': instance.cityId,
      'languageId': instance.languageId,
      'secondLanguageId': instance.secondLanguageId,
      'facebookKey': instance.facebookKey,
      'profile': instance.profile,
      'enableOauth': instance.enableOauth,
      'sessionTimeout': instance.sessionTimeout,
      'multipleSession': instance.multipleSession,
      'phoneValidated': instance.phoneValidated,
      'phoneValidationCode': instance.phoneValidationCode,
      'emailValidated': instance.emailValidated,
      'emailValidationCode': instance.emailValidationCode,
      'authenticationMode': instance.authenticationMode,
      'enabled': instance.enabled,
      'confirmationToken': instance.confirmationToken,
      'passwordRequestedAt': instance.passwordRequestedAt?.toIso8601String(),
      'locked': instance.locked,
      'expired': instance.expired,
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'credentialsExpired': instance.credentialsExpired,
      'credentialsExpireAt': instance.credentialsExpireAt?.toIso8601String(),
      'lastLogin': instance.lastLogin?.toIso8601String(),
      'lastFailedLogin': instance.lastFailedLogin?.toIso8601String(),
      'loginCount': instance.loginCount,
      'failedLoginCount': instance.failedLoginCount,
      'lastFailedLoginCount': instance.lastFailedLoginCount,
      'createdAt': instance.createdAt?.toIso8601String(),
      'creatorUserId': instance.creatorUserId,
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'updaterUserId': instance.updaterUserId,
    };
