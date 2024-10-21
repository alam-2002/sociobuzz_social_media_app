import 'package:flutter/material.dart';
import 'package:sociobuzz_social_media_app/components/text_widget.dart';
import 'package:sociobuzz_social_media_app/features/profile/domain/entities/user_profile.dart';
import 'package:sociobuzz_social_media_app/features/profile/presentation/pages/profile_page.dart';

class UserTile extends StatelessWidget {
  final ProfileUser user;
  const UserTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return ListTile(
      title: Label(label: user.name),
      subtitle: Label(label: user.email, fontSize: 13, color: primary),
      leading: Icon(Icons.person, color: primary),
      trailing: Icon(Icons.arrow_forward, color: primary),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePage(uid: user.uid),
        ),
      ),
    );
  }
}
