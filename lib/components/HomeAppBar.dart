// import 'package:flutter/material.dart';
// import 'package:badges/badges.dart' as badges;
// class HomeAppBar extends StatelessWidget {
//   const HomeAppBar({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.white,
//       padding: EdgeInsets.all(25),
//       child: Row(children: [
//
//         Image.asset("imagens/logo-cathafire.png",
//           width: 50,
//           height: 50,
//         ),
//         Padding(padding: EdgeInsets.only(left: 20,),
//           child: Text(
//             "Catcha Fire",
//             style: TextStyle(
//               fontSize: 30,
//               fontWeight: FontWeight.bold,
//               color: Colors.deepPurpleAccent,
//             ),
//           ),
//         ),
//         Spacer(),
//         InkWell(
//           onTap: (){
//             Navigator.pushNamed(context, "/carrinho");
//           },
//           child:
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Icon(
//               Icons.list,
//               size: 40,
//               color: Colors.deepPurpleAccent,),
//           ),
//         ),
//         badges.Badge(
//          badgeStyle: badges.BadgeStyle(
//            badgeColor: Colors.red,
//            padding: EdgeInsets.all(7),
//          ),badgeContent: Text("3", style: TextStyle(color: Colors.white),),
//           child: InkWell(
//             onTap:() {
//               Navigator.pushNamed(context, "/carrinho");
//             },
//             child: Icon(Icons.shopping_bag_outlined,
//             size: 30,
//             color: Colors.deepPurpleAccent  ,),
//           ),
//         )
//       ]),
//     );
//   }
// }
