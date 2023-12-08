import 'package:flutter/material.dart';
import 'package:journal_app/screens/navbar.dart';
import 'package:journal_app/screens/registerscreen.dart';
import 'package:journal_app/services/auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  String email="";
  String password="";



  // form key
  final _formKey = GlobalKey<FormState>();

  // text editing controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthMethods _auth = AuthMethods();

  useLogin()async{
    bool logged = await _auth.logInWithEmailPassword(email, password);
    if(logged){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>NavBar(auth: _auth)));
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error occured while logging in"),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {

    // email field
    final emailField = TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        return null;
      },
      onSaved: (value)
      {
        _emailController.text = value!;
      },

      textInputAction: TextInputAction.next,

      decoration: InputDecoration(
        prefixIcon: Icon(Icons.email),
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Email",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),

    );

    // password field
    final passwordField = TextFormField(
      controller: _passwordController,
      autofocus: false,
      obscureText: true,
      validator: (value) {
        if (value==null || value.isEmpty) {
          return 'Please enter your password';
        }
        return null;
      },
      onSaved: (value)
      {
        _passwordController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock),
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Password",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
    );
    
    final loginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.red,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),

        onPressed: () {
          if (_formKey.currentState!.validate()) {
            setState(() {
              email = _emailController.text;
              password = _passwordController.text;
            });
            useLogin();
          }

        },

        child: const Text(
          "Login",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
      ),
    );


    // login with google button
    final loginWithGoogleButton = Material(
      elevation: 5.0,
      // Setting border of radius to 30 and color black
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
        side: const BorderSide(color: Colors.black, width: 0.5), // Adjust thickness and color as needed
      ),
      color: Colors.white,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          _auth.signWithGoogle(context);
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage("assets/google.png"),
              height: 35.0,
            ),
            SizedBox(width: 10.0), // Add some space between the logo and text
            Text(
              "Login with Google",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
          ],
        ),
      ),
    );

    // login with facebook button
    final loginWithFacebookButton = Material(
      elevation: 5.0,
      // Setting border of radius to 30 and color black
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
        side: const BorderSide(color: Colors.black, width: 0.5), // Adjust thickness and color as needed
      ),
      color: Colors.white,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),

        onPressed: () {
          // Handle Facebook login logic here
        },

        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage("assets/facebook.png"),
              height: 35.0,
            ),
            SizedBox(width: 10.0), // Add some space between the logo and text
            Text(
              "Login with Facebook",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body:Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(
                      height: 100.0,
                      child: Image(
                        image: AssetImage("assets/logo.png"),
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 45.0),

                    emailField,
                    const SizedBox(height: 10.0),

                    passwordField,
                    const SizedBox(height: 20.0),

                    loginWithGoogleButton,
                    const SizedBox(height: 10.0),

                    loginWithFacebookButton,
                    const SizedBox(height: 10.0),

                    loginButton,
                    const SizedBox(height: 10.0),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          "Don't have an account?",
                          style: TextStyle(color: Colors.black),
                        ),
                        const SizedBox(width: 5.0),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            "Register",
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ) 
              ),
            ),
          ),
        ),
      ),
    );
  }
}