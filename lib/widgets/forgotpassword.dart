import 'package:flutter/material.dart';

class ForgotPswScreen extends StatefulWidget {
  const ForgotPswScreen({super.key});

  @override
  State<ForgotPswScreen> createState() => _ForgotPswScreenState();
}

class _ForgotPswScreenState extends State<ForgotPswScreen> {
  final _forgotpasskey = GlobalKey<FormState>();
  TextEditingController forgetpas = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Forgot Password Page",
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
        ),
        body: SafeArea(
            child: Center(
                child: ListView(
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/");
                    },
                    icon: const Icon(Icons.arrow_back))
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                  child: SizedBox(
                    height: 200,
                    child: Image.asset("assests/png_images/ForgotPas.png"),
                  ),
                ),
                const Text(
                  "Enter your email to reset your password",
                  style: TextStyle(fontSize: 20),
                ),
                Column(
                  children: [
                    Padding(
                      padding:
                         const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                      child: Form(
                        key: _forgotpasskey,
                        child: TextFormField(
                          controller: forgetpas,
                          validator: (forgetpas) {
                            if (forgetpas!.isEmpty && forgetpas != "") {
                              return "Email is required";
                            }
                          },
                          decoration: InputDecoration(
                              hintText: "Enter Email",
                              labelText: "Enter Email",
                              labelStyle: TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                      ),
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            backgroundColor: Colors.blue),
                        onPressed: () {
                          if (_forgotpasskey.currentState!.validate()) ;
                        },
                        child: Text(
                          "Reset Your Passsword",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ))
                  ],
                )
              ],
            ),
          ],
        ))),
      ),
    );
  }
}
