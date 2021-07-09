import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:dashtech/domain/auth/adapters/auth_repository_adapter.dart';
import 'package:dashtech/domain/auth/failures/auth_failure.dart';
import 'package:dashtech/domain/auth/models/auth_profile.dart';
import 'package:dashtech/domain/core/failures/base_failure.dart';
import 'package:dashtech/infrastructure/auth/dto/auth_profile_token_dto.dart';
import 'package:dashtech/infrastructure/core/graphql/graphql_api.dart';
import 'package:dashtech/infrastructure/core/service/graphql_service.dart';
import 'package:dashtech/infrastructure/core/service/http_service.dart';
import 'package:dashtech/infrastructure/core/service/storage_service.dart';
import 'package:dashtech/infrastructure/core/service/token_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

class AuthRepository implements IAuthRepository {
  final GraphqlService graphqlService = Get.find();
  final HttpService httpService = Get.find();
  final TokenService tokenService = Get.find();
  final StorageService storageService = Get.find();

  // Register device with firebase token
  @override
  Future<Either<BaseFailure, bool>> sendDeviceToken(
    String token,
    String identifier,
    String platform,
  ) async {
    final response = await graphqlService.client.execute(
      ProfileRegisterDeviceMutation(
        variables: ProfileRegisterDeviceArguments(
          identifier: identifier,
          platform: platform,
          token: token,
        ),
      ),
    );

    if (response.hasErrors) {
      return left(const BaseFailure.notFound());
    }

    return right(response.data!.profileRegisterDevice);
  }

  // Send email verification to user
  @override
  Future<Either<BaseFailure, bool>> sendEmailCode(String email) async {
    final response = await graphqlService.client.execute(
      AuthSendEmailConfirmationQuery(
        variables: AuthSendEmailConfirmationArguments(
          email: email,
        ),
      ),
    );

    if (response.hasErrors) {
      return left(const BaseFailure.notFound());
    }

    return right(response.data!.authSendEmailConfirmation);
  }

  // Validate code sent by email
  @override
  Future<Either<BaseFailure, AuthConfirmEmailCode$Query$Profile>> confirmEmailCode(
    String email,
    String code,
  ) async {
    final response = await graphqlService.client.execute(
      AuthConfirmEmailCodeQuery(
        variables: AuthConfirmEmailCodeArguments(
          email: email,
          code: code,
        ),
      ),
    );

    if (response.hasErrors) {
      return left(const BaseFailure.notFound());
    }

    return right(response.data!.authConfirmEmailCode!);
  }

  // Set profile autolog url if user email iss same as intranet logged user
  // TODO: jwt login ?
  @override
  Future<Either<BaseFailure, bool>> setProfileAutolog(
    String profileId,
    String autologUrl,
  ) async {
    final response = await graphqlService.client.execute(
      ProfileSetAutologMutation(
        variables: ProfileSetAutologArguments(
          profileId: profileId,
          autologUrl: autologUrl,
        ),
      ),
    );

    if (response.hasErrors) {
      return left(const BaseFailure.notFound());
    }

    return right(response.data!.profileSetAutolog);
  }

  @override
  Future<Either<AuthFailure, AuthProfile>> login(
    String profileId,
    String email,
  ) async {
    try {
      final response = await httpService.connect.post(
        DotEnv().env['BASE_URL']! + '/auth/login',
        {
          'profileId': profileId,
          'email': email,
        },
      );

      final AuthProfileTokenDto tokenDto = AuthProfileTokenDto.fromJson(response.body);
      final AuthProfile authProfile = tokenDto.toDomain();

      print(tokenDto.toString());
      print(authProfile.toString());

      String fullName = authProfile.email.split('@')[0].replaceAll('.', ' ');
      tokenService.expirationDate.value = tokenDto.expirationTime.toLocal();
      tokenService.token.value = tokenDto.accessToken;
      storageService.box.write('fullName', fullName);
      storageService.box.write('email', authProfile.email);
      return right(authProfile);
    } catch (e) {
      return left(const AuthFailure.unexpected());
    }
  }

  @override
  Future<Either<BaseFailure, String>> getProfileIconLink(
    String picture,
  ) async {
    final response = await graphqlService.client.execute(
      ProfileGetIconLinkByPictureQuery(
        variables: ProfileGetIconLinkByPictureArguments(
          picture: picture,
        ),
      ),
    );

    if (response.hasErrors) {
      return left(const BaseFailure.notFound());
    }

    return right(response.data!.profileGetIconLinkByPicture);
  }
}
