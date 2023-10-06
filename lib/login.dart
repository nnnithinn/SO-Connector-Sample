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
      decoration: BoxDecoration(
        color: themeColor,
        image: DecorationImage(
          image: const AssetImage("assets/images/logo.jpg"),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(themeColor.withOpacity(0.5), BlendMode.dstATop),
        )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(children: [
          Positioned(top: 80, child: _buildTop()),
          Positioned(bottom: 0, child: _buildBottom())
        ],),
      ),
    );
  }

  Widget _buildTop() {
    return SizedBox(
      width: mediaSize.width,
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.flight_takeoff_outlined, size: 100, color: Colors.white),
          Text(
            "SO Login",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 40,
              letterSpacing: 2,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBottom() {
    return SizedBox(
      width: mediaSize.width,
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          )
        ),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: _buildForm(),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Welcome to SO Platform",
          style: TextStyle(
            color: themeColor,
            fontSize: 32,
            fontWeight: FontWeight.w500,
          ),
        ),
        _buildGreyText("Please enter your credentials"),
        const SizedBox(height: 60),
        _buildGreyText("Login"),
        _buildTextField(loginController),
        const SizedBox(height: 60),
        _buildGreyText("Password"),
        _buildTextField(passwordController, isPassword: true),
        const SizedBox(height: 20),
        _buildLoginButton()
      ],
    );
  }

  Widget _buildGreyText(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.grey),
    );
  }

  Widget _buildTextField(TextEditingController controller, {isPassword = false}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        icon: isPassword ? Icon(Icons.remove_red_eye) : Icon(Icons.done),
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
          minimumSize: const Size.fromHeight(60)
        ),
        child: const Text("Login", style: TextStyle(color: Colors.white))
    );
  }

  void login() async {
    Client client = Client("emqim12.engravsystems.com", "emqimtest");
    String status = await client.login(loginController.value.text, passwordController.value.text);
    await Future.delayed(const Duration(seconds: 1));
    if(!context.mounted) return;
    if(status == "") {
      var home = Home(client: client);
      Navigator.push(context, MaterialPageRoute(builder: (context) => home));
    } else {
      var a = AlertDialog(
          content: Column(
            children: [
              Text("Unable to login $status"),
              ElevatedButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Login'))
            ],
          )
      );
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => a));
    }
  }
}