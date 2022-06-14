import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text("Ray"),
            accountEmail: const Text("raiymbek132@gmail.com"),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.network(
                  'https://upload.wikimedia.org/wikipedia/commons/thumb/9/9a/Gull_portrait_ca_usa.jpg/1920px-Gull_portrait_ca_usa.jpg',
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/background_image.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(FontAwesomeIcons.listUl, size: 20.0,),
            title: const Text("Assets"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/assets');
            },
          ),
          ListTile(
            leading: const Icon(FontAwesomeIcons.bell, size: 20.0,),
            title: const Text("Notification"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/notification');
            },
          ),
          ListTile(
            leading: const Icon(FontAwesomeIcons.gear, size: 20.0,),
            title: const Text("Settings"),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/settings');
            },
          ),
          const Divider(height: 1.0, color: Colors.grey, indent: 15.0, endIndent: 15.0,),
          ListTile(
            leading: const Icon(FontAwesomeIcons.arrowRightFromBracket, size: 20.0,),
            title: const Text("Log out"),
            onTap: () {
              int count = 0;
              Navigator.popUntil(context, (route) {
                return count++ == 2;
              });
            },
          ),
        ],
      ),
    );
  }
}