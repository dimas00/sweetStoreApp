import 'package:flutter/material.dart';

Widget buildFooter({
  required double total,
  required VoidCallback? onPressed,
}) {
  return Container(
    margin: EdgeInsets.all(20),
    height: 60,
    decoration: BoxDecoration(
      color: Colors.deepPurple,
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total: R\$${total.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
            ),
            child: Text(
              "Finalizar",
              style: TextStyle(color: Colors.deepPurple),
            ),
          ),
        ],
      ),
    ),
  );
}