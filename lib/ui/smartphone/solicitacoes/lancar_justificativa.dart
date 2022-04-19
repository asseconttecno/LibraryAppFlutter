import '../../../services/memorando/memorando_manager.dart';
import '../../../settintgs.dart';
import '../../../ui/smartphone/camera/camera.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class LancarJustificativa extends StatefulWidget {

  @override
  _LancarJustificativaState createState() => _LancarJustificativaState();
}

class _LancarJustificativaState extends State<LancarJustificativa> {
  Widget icone = Container();
  Widget icone2 = Container() ;

  @override
  void initState() {
    context.read<MemorandosManager>().updateObs(false);
    super.initState();
  }



  @override
  Widget build(BuildContext context) {

        return Consumer<MemorandosManager>(
            builder: (_, memo, __) {

              return Container(//height: 310, width: 300,
                child: Column(mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                  Padding(padding: EdgeInsets.only(left: 15, right: 15, bottom: 3),
                    child: DateTimeField(
                      format: DateFormat('dd/MM/yyyy'),
                      keyboardType: TextInputType.datetime,
                      controller: memo.controlerData,
                      decoration: InputDecoration(
                        labelText: "Data:",
                        prefixIcon: Icon(Icons.today,),
                      ),
                      onShowPicker: (context, currentValue) {
                        return showDatePicker(
                            context: context,
                            firstDate: DateTime(1900),
                            initialDate: currentValue ?? DateTime.now(),
                            lastDate: DateTime(2100)
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 10,),
                  Padding(padding: EdgeInsets.only(left: 10, right: 10),
                    child: Container(padding: EdgeInsets.all(5),
                      child: TextField(maxLength: 255, maxLines: 2, readOnly: false,
                        decoration: InputDecoration(labelText: "OBS:",
                          border: OutlineInputBorder(borderSide: BorderSide(width: 5 ,color: Colors.blue)),
                          prefixIcon: Icon(Icons.edit,),
                        ),
                        controller: memo.controlerObs,
                      ),
                    ),
                  ),
                  SizedBox(height: 5,),
                  Row(mainAxisAlignment: MainAxisAlignment.center ,
                    children: <Widget>[
                      Container(decoration: BoxDecoration(//color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular (50) ),
                          border: Border.all(color: Colors.grey)
                      ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 8, bottom: 8, right: 16),
                          child: PopupMenuButton<int>(
                            itemBuilder: (context) => [
                              if(!Settings.isWin)
                              PopupMenuItem(
                                value: 1,
                                child: Text("Camera"),
                              ),
                              PopupMenuItem(
                                value: 2,
                                child: Text("Galeria"),
                              ),
                            ],
                            initialValue: 1,
                            offset: Offset(10,5),
                            onSelected: (value) async {
                              if(value == 1){
                                memo.foto = (await CustomCamera().getImage()) ?? memo.foto;
                              }else{
                                memo.foto = (await CustomCamera().getGallery()) ?? memo.foto;
                              }

                              if(memo.foto != null){
                                setState(() {
                                  icone = Icon(Icons.attach_file, color: Colors.blueAccent,);
                                  icone2 = IconButton(
                                    onPressed: (){
                                      setState(() {
                                        icone = Container();
                                        icone2 = Container();
                                      });
                                    },
                                    icon: Icon(Icons.delete), color: Colors.red,
                                  );
                                });
                              }else{
                                setState(() {
                                  icone = Container();
                                  icone2 = Container();
                                });
                              }
                            },
                            child: Container(
                              child: Row(children: <Widget>[
                                Padding(padding: EdgeInsets.only(left:10 ,right: 10),
                                  child: Icon(Icons.camera_alt,),
                                ),
                                Text("Comprovante", ),
                              ],),
                            ),
                          ),
                        ),
                      ),
                      icone,
                      icone2
                  ],),
                  SizedBox(height: 20,),
                  Row(mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        child: FlatButton(
                          padding: EdgeInsets.only(top: 12,),
                          child: Text("Cancelar", style: TextStyle(fontSize: 14),),
                          onPressed: (){
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      Container(
                        child: FlatButton(
                          padding: EdgeInsets.only(top: 12,),
                          child: Text("Ok",style: TextStyle(fontSize: 14),),
                          onPressed: () async {
                            List _i = memo.controlerData.text.split("/");
                            DateTime datahora = DateTime(int.parse(_i[2]), int.parse(_i[1]), int.parse(_i[0]));

                            await context.read<MemorandosManager>().postMemorando(
                                datahora, memo.controlerObs.text, 1, img: memo.foto,
                                sucess: () async {
                                  context.read<MemorandosManager>().memorandosUpdate();
                                  await Future.delayed(Duration(milliseconds: 100));
                                  SuccessAlertBox(
                                      context: context,
                                      title: 'Sucesso',
                                      messageText: 'Solicitação realizada!',
                                      buttonText: 'ok'
                                  );
                                },
                                error: () async {
                                  await Future.delayed(Duration(milliseconds: 100));
                                  DangerAlertBox(
                                      context: context,
                                      title: 'Falha',
                                      messageText: 'Não foi possivel realizar a solicitação!',
                                      buttonText: 'ok'
                                  );
                                }
                            );
                            Navigator.pop(context);
                          },
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 5,),
                ],
                ),);
            },
        );
  }
}

