import 'package:flutter/material.dart';

class ActivesPage extends StatefulWidget {
  const ActivesPage({Key? key}) : super(key: key);

  @override
  State<ActivesPage> createState() => _ActivesPageState();
}

class _ActivesPageState extends State<ActivesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Actives'),
      ),
      body: Container(),
    );
  }
}
