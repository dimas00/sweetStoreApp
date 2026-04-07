import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ItensWidget extends StatelessWidget {
  const ItensWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
        childAspectRatio: 0.68,
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
      shrinkWrap: true,
      children: [
        for(int i = 1; i<6; i++)
        Container(
          padding: EdgeInsets.only(left: 15, right: 15 ,top: 10),
          margin: EdgeInsets.symmetric(vertical: 8,horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:  BorderRadius.circular(20)
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "-50%",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Icon(Icons.favorite_border,
                    color: Colors.red,
                  ),
                ],
              ),
              InkWell(
                onTap: (){
                  Navigator.pushNamed(context, "/itemPage");
                },
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: Image.asset(
                    "imagens/$i.png",
                    height: 120,
                    width: 120,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 8),
                alignment: Alignment.centerLeft,
                child: Text("Nome do produto",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                ),
               ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Descrição do produto",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.deepPurple,

                  ),
                ),
              ),
              Padding(padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("\$55",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:  FontWeight.bold,
                      color: Colors.deepPurple,),
                  ),
                  Icon(
                    Icons.shopping_cart_checkout,
                    color: Colors.deepPurple,
                  )
                ],
              ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
