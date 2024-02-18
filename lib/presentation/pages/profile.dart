
import 'package:flutter/material.dart';
import 'package:utsmobilewilbert/data/model/auth.dart';
import 'package:utsmobilewilbert/data/services/auth.dart';
import 'package:utsmobilewilbert/presentation/pages/auth/state.dart';

class PageProfile extends StatefulWidget {
  const PageProfile({Key? key}) : super(key: key);

  @override
  _PageProfileState createState() => _PageProfileState();
}

class _PageProfileState extends State<PageProfile> {
  Widget build(BuildContext context) {
    Account user;
    if (AuthState.loggedInAccount != null) {
      user = AuthState.loggedInAccount!;
    } else {
      user = Account(
          id: 'not login yet',
          name: 'not login yet',
          email: 'not login yet',
          password: 'not login yet');
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/profile_image.png'),
            ),
            SizedBox(height: 16),
            Text(
              '${user.name}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '${user.email}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                AuthService.logout(context);
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
