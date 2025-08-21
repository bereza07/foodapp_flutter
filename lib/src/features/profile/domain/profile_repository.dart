

import 'package:foodapp/src/features/profile/domain/user_profile.dart';

abstract class ProfileRepository {

  Future<UserProfile?> getProfile(String userId);
  Future<void> updateProfile (UserProfile profile);
}