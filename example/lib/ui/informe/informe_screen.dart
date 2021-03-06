import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:assecontservices/assecontservices.dart';

import 'detelhes_informe.dart';

class InformeRendimentoScreen extends StatefulWidget {

  @override
  _InformeRendmientoScreenState createState() => _InformeRendmientoScreenState();
}

class _InformeRendmientoScreenState extends State<InformeRendimentoScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ConnectionStatusSingleton connectionStatus = ConnectionStatusSingleton.getInstance();



  @override
  void initState() {
    context.read<InformeManager>().competencias(context.read<UserHoleriteManager>().user!);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<InformeManager>(
        builder: (_, informe, __){
          return CustomScaffold.custom(
              context: context,
              key: _scaffoldKey,
              height: 70,
              appTitle: 'Meu Informe de Rendimentos',
              appbar: Container(
                height: 40,
                margin: EdgeInsets.only(left: 30, right: 30, bottom: 20, top: 5),
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey, width: 1)
                ),
                child: DropdownButton<InformeRendimentosModel>(
                  isExpanded: true,
                  dropdownColor: Colors.white,
                  value: informe.competencia,
                  iconSize: 20,
                  elevation: 0,
                  icon: Icon(Icons.arrow_drop_down, color: Colors.black,),
                  style: TextStyle(color: Colors.black),
                  underline: Container(),
                  onChanged: ( newValue) {
                    informe.competencia = newValue;
                  },
                  items: informe.listcompetencias.
                   map<DropdownMenuItem<InformeRendimentosModel>>(( value) {
                    return DropdownMenuItem<InformeRendimentosModel>(
                      value: value,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text(value.anoReferencia ?? ''),
                      ),
                    );
                  }).toList(),
                ),
              ),
              body: Container(
                //height: MediaQuery.of(context).size.height - 100 - AppBar().preferredSize.height  -MediaQuery.of(context).padding.top,
                  child: !connectionStatus.hasConnection ?
                    Center(child: Text('Verifique sua Conex??o com Internet')) :
                    informe.listcompetencias.length == 0 ?
                    Center(
                      child: Text('Usu??rio n??o tem Informes',
                        style: TextStyle(fontSize: 20),),
                    ) : Center(
                        child: DetalhesInformes()
                    )
              ),
          );
        }
    );
  }
}