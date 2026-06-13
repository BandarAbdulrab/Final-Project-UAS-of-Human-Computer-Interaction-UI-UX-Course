import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../models/user_model.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    required this.user,
    this.radius = 36,
  });

  final UserModel user;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final imageUrl = user.photoUrl.isNotEmpty
        ? user.photoUrl
        : 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(user.name.isEmpty ? 'User' : user.name)}&background=2E7D32&color=fff&size=128';

    return CircleAvatar(
      radius: radius,
      backgroundColor: kK24Green.withValues(alpha: 0.15),
      backgroundImage: NetworkImage(imageUrl),
    );
  }
}
