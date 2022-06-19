import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:igps/screens/home_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);
  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Welcome!",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 40.0),
                  TextFormField(
                    decoration: const InputDecoration(
                      icon: Icon(
                        FontAwesomeIcons.circleUser,
                        size: 20.0,
                      ),
                      labelText: "Username",
                    ),
                    validator: (String? value) {
                      if (value == null) {
                        return "Username is not inputted";
                      } else {
                        return null;
                      }
                    },
                    autocorrect: false,
                    enableSuggestions: false,
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    decoration: const InputDecoration(
                      icon: Icon(
                        FontAwesomeIcons.key,
                        size: 20.0,
                      ),
                      labelText: "Password",
                    ),
                    initialValue: 'dasASD312@#',
                    validator: (String? value) {
                      if (value == null || !RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$').hasMatch(value)) {
                        return "Your password is incorrect";
                      } else {
                        return null;
                      }
                    },
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                  ),
                  const SizedBox(height: 40.0),
                  Row(
                    children: [
                      Expanded(
                        child: DefaultButton(
                          formKey: formKey,
                          text: "Login",
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
                            }
                          },
                        ),
                      ),
                    ]
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DefaultButton extends StatelessWidget {
  const DefaultButton({Key? key, required this.formKey, required this.text, required this.onPressed,}) : super(key: key);

  final GlobalKey<FormState> formKey;
  final String text;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onPressed();
      },
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            )
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}