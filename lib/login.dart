import 'package:flutter/material.dart';
import 'package:so/so.dart';
import 'package:sologin/home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late Color themeColor;
  late Size mediaSize;
  TextEditingController loginController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    themeColor = Theme.of(context).primaryColor;
    mediaSize = MediaQuery.of(context).size;
    return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover, image: AssetImage('assets/images/bg.jpg')),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(45),
            child: _buildBottom(),
          ),
        ));
  }

  Widget _buildBottom() {
    return SizedBox(
        width: mediaSize.width,
        child: Column(children: [
          const Center(
              child: CircleAvatar(
                  radius: 70,
                  backgroundImage:
                      AssetImage("assets/images/sample-person.jpg"))),
          const SizedBox(height: 50),
          Card(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30))),
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: _buildForm(),
            ),
          ),
        ]));
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
          child: Text(
            "Welcome to SO Platform",
            style: TextStyle(
              color: Colors.purple,
              fontSize: 32,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 50),
        _buildTextField(loginController, title: "Login"),
        const SizedBox(height: 50),
        _buildTextField(passwordController,
            isPassword: true, title: "Password"),
        const SizedBox(height: 30),
        _buildLoginButton()
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller,
      {isPassword = false, title}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: title,
        icon: isPassword
            ? const Icon(Icons.remove_red_eye)
            : const Icon(Icons.verified_user_sharp),
      ),
      obscureText: isPassword,
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
        onPressed: () => login(),
        style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            elevation: 20,
            shadowColor: themeColor,
            backgroundColor: themeColor,
            minimumSize: const Size.fromHeight(60)),
        child: const Text("Login", style: TextStyle(color: Colors.white)));
  }

  void login() async {
    Client client = Client("emqim12.engravsystems.com", "emqimtest");
    String status = await client.login(
        loginController.value.text, passwordController.value.text);
    await Future.delayed(const Duration(seconds: 1));
    if (!context.mounted) return;
    if (status == "") {
      var home = Home(client: client);
      Navigator.push(context, MaterialPageRoute(builder: (context) => home));
    } else {
      var a = AlertDialog(
          content: Column(
        children: [
          Text("Unable to login $status"),
          ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Login'))
        ],
      ));
      Navigator.push(context, MaterialPageRoute(builder: (context) => a));
    }
  }
}
