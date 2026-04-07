import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


import '../../controller/login_controller.dart';
import 'home.dart';
class Login extends StatelessWidget {

  final LoginController _controller = LoginController();
     Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Login", style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.deepPurple,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: const BoxDecoration(
                  // color: Colors.black87,
                    borderRadius:
                    BorderRadius.all(Radius.circular(30))),
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                margin: const EdgeInsets.fromLTRB(0, 40, 0, 0),

              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: TextField(
                  onChanged: _controller.setLogin,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(

                          borderRadius: BorderRadius.circular(20.0)),hoverColor: Colors.deepPurple,
                      labelText: 'Login'),
                ),
              ),
              Container(
                //color: Colors.lightGreen,
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: TextField(
                  obscureText: true,
                  onChanged: _controller.setSenha,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      labelText: 'Senha'),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.8),
                    child: Material(
                      color: Colors.deepPurpleAccent,
                      elevation: 9,
                      shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(30)
                      ),
                      child: InkWell(
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Home()
                          ));
                        },
                        child: Container(

                          padding: EdgeInsets.all(12),
                          //color: Colors.deepPurpleAccent,
                          width: 300,
                          height: 50,
                          child: Column(
                            children:<Widget> [
                              Text('Login', style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }



}

