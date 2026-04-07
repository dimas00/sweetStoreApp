import 'package:flutter/material.dart';

class CategoriasWidget extends StatelessWidget {
  const CategoriasWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for(int i = 1; i<6;i++ )
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset("imagens/$i.png",
                width: 50,
                height: 50,
                ),
                Text("nome categoria", style: TextStyle(
                  fontWeight:  FontWeight.bold,
                  fontSize: 16,
                  color: Colors.deepPurpleAccent,
                ),)
              ],),
          )
      ],),
    );
  }
}

