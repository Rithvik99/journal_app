import 'package:flutter/material.dart';
import 'package:journal_app/screens/loginscreen.dart';
import 'package:journal_app/screens/navbar.dart';
import 'package:journal_app/services/auth.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  // form key
  final _formKey = GlobalKey<FormState>();


  String username = '';
  String email = '';
  String password = '';

  // text editing controllers
  final TextEditingController userNameEditingController = TextEditingController();
  final TextEditingController emailEditingController = TextEditingController();
  final TextEditingController passwordEditingController = TextEditingController();

  final AuthMethods _auth = AuthMethods();


  registration()async{
    if(password!=null && userNameEditingController.text!="" && emailEditingController.text!=""){
      bool created = await _auth.signUpWithEmailAndPassword(emailEditingController.text, passwordEditingController.text, userNameEditingController.text, context);
      if(created){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>NavBar(auth: _auth)));
      } else{
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Error occured while creating account"),
          ),
        );
      }
    }
  }

  // google login
  googleLogIn() async {
    try{
      bool google = await _auth.signInWithGoogle();

      if(google){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>NavBar(auth: _auth)));
      } else{
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Error occured while creating account"),
          ),
        );
      }
    } catch(e){
      print("Google Login Error");
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {

    // username field
    final userNameField = TextFormField(
      controller: userNameEditingController,
      keyboardType: TextInputType.name,
      autofocus: false,
      validator: (value) {
        if (value == null || value.isEmpty){
          return 'Please enter your username';
        }
        return null;
      },
      onSaved: (value) 
      {
        userNameEditingController.text = value!;
      },

      textInputAction: TextInputAction.next,

      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.person),
        contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Username",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),

    );

    // email field
    final emailField = TextFormField(
      controller: emailEditingController,
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
        emailEditingController.text = value!;
      },

      textInputAction: TextInputAction.next,

      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.email),
        contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Email",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),

    );

    // password field
    final passwordField = TextFormField(
      controller: passwordEditingController,
      autofocus: false,
      obscureText: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        return null;
      },
      onSaved: (value) 
      {
        passwordEditingController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock),
        contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Password",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
    );

    // register button
    final registerButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(16.0),
      color: Colors.red,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding:const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),

        onPressed: () {
          if(_formKey.currentState!.validate()){
            setState(() {
              username = userNameEditingController.text;
              email = emailEditingController.text;
              password = passwordEditingController.text;
            });
          }
          registration();
        },

        child: const Text(
          "Register",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
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
          googleLogIn();
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
        padding: const 
        EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),

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

                    userNameField,
                    const SizedBox(height: 10.0),

                    emailField,
                    const SizedBox(height: 10.0),

                    passwordField,
                    const SizedBox(height: 20.0),

                    loginWithGoogleButton,
                    const SizedBox(height: 10.0),

                    loginWithFacebookButton,
                    const SizedBox(height: 10.0),

                    registerButton,
                    const SizedBox(height: 10.0),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          "Have an account?",
                          style: TextStyle(color: Colors.black),
                        ),
                        const SizedBox(width: 5.0),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            "Login",
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