import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../config.dart';


class CustomMenuItem extends StatelessWidget {
  CustomMenuItem(this.icon, this.titulo, this.function);

  Widget icon;
  String titulo;
  VoidCallback function;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 115,
      child: Column(
        children: [
          InkWell(
            onTap: function,
            child:  Container(
              padding: EdgeInsets.all(10),
              height: 70, width: 70,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Config.corPri
              ),
              child: icon,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(titulo, textAlign: TextAlign.center,),
          )
        ],
      ),
    );
  }
}

