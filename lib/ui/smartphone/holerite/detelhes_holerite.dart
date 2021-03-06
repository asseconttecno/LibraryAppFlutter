import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:intl/intl.dart';
import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_common/common.dart' as common;
import 'package:charts_common/src/common/color.dart' as colors;

import '../../../common/common.dart';
import '../../../config.dart';
import '../../../controllers/controllers.dart';
import '../../../model/model.dart';


class DetalhesHolerite extends StatefulWidget {
  final List<HoleriteModel> holerite;
  final int mes;
  final int ano;
  DetalhesHolerite(this.holerite, this.mes, this.ano);

  @override
  _DetalhesHoleriteState createState() => _DetalhesHoleriteState();
}

class _DetalhesHoleriteState extends State<DetalhesHolerite> {
  bool load = false;
  HoleriteModel? holerite;
  var mask = NumberFormat.currency(locale: 'pt_Br', customPattern: 'R\$#,##0.00');

  init(){
    if(context.read<HoleriteManager>().dropdowntipo != ''){
      List<HoleriteModel>? _temp  = widget.holerite.where((e) =>
        e.holeriteTipo == context.read<HoleriteManager>().dropdowntipo).toList();
      if(_temp != null && _temp.isNotEmpty){
        holerite = _temp.first;
      }
    }
    if(holerite == null){
      holerite = widget.holerite.first;
    }
    context.read<HoleriteManager>().dropdowntipoInit(holerite?.holeriteTipo ?? '');
  }

  @override
  void initState() {
    init();
    super.initState();
  }


  double getPorcentagem(double valor, double total){
    if(total == 0){
      return 0.0;
    }
    double result = 0;
    try{
      result = (valor/total) * 100.0;
    }catch(e){
      result = 0;
    }
    return double.parse(result.toStringAsFixed(1));
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height - (WidgetsBinding.instance?.window.padding.top ?? 0);
    double width = MediaQuery.of(context).size.width;


    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(width: 70, color: Theme.of(context).scaffoldBackgroundColor))
        ),
        width: width,
        height: height,
        alignment: Alignment.topCenter,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                height: 35,
                margin: EdgeInsets.symmetric(horizontal: 40,),
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey, width: 1)
                ),
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: context.watch<HoleriteManager>().dropdowntipo,
                  iconSize: 20,
                  dropdownColor: Colors.white,
                  elevation: 0,
                  icon: Icon(Icons.arrow_drop_down, color: Colors.black,),
                  style: TextStyle(color: Colors.black),
                  underline: Container(),
                  onChanged: (newValue) async {
                    setState(() {
                      context.read<HoleriteManager>().dropdowntipo = newValue!;
                      holerite = widget.holerite.firstWhere((e) => e.holeriteTipo == newValue);
                    });
                  },
                  items: widget.holerite.map((e) => e.holeriteTipo).toList()
                      .map<DropdownMenuItem<String>>(( value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Padding(
                        padding:  EdgeInsets.symmetric(vertical: 8),
                        child: Text(value ?? ''),
                      ),
                    );
                  }).toList(),
                ),
              ),
              Container(
                height: 185, width: width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 108,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Colors.blue[900],
                                borderRadius: BorderRadius.circular(30)
                            ),
                            child: Center(
                              child: Text("Proventos\n${mask.format(holerite?.vencimentos ?? 0)}",
                                textAlign: TextAlign.center, style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Container(
                            width: 108,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Colors.red[900],
                                borderRadius: BorderRadius.circular(30)
                            ),
                            child: Center(
                              child: Text("Descontos\n${mask.format(holerite?.descontos ?? 0)}",
                                textAlign: TextAlign.center, style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Container(
                            width: 108,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(30)
                            ),
                            child: Center(
                              child: Text("Liquido\n${mask.format(holerite?.liquido ?? 0)}",
                                textAlign: TextAlign.center, style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Container(alignment: Alignment.center,
                          padding: EdgeInsets.only(top: 5),
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(25)
                          ),
                          child: Column(mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text('Proventos'.toUpperCase(), style: TextStyle(color: Colors.black),),
                              SizedBox(height: 4,),
                              Container(
                                height: 138, width: width * 0.59,
                                child: charts.PieChart<String>([charts.Series<ChartPizza, String>(
                                    id: 'Pizza',
                                    domainFn: (ChartPizza sales, _) => sales.desc,
                                    measureFn: (ChartPizza sales, _) => sales.valor,
                                    colorFn: (ChartPizza sales, cor) {
                                      if(sales.desc != 'Proventos'){
                                        return colors.Color.fromHex( code: 'fFF9800');
                                      }else{
                                        return colors.Color.fromHex( code: 'f0D47A1');
                                      }
                                    },
                                    data: [
                                      ChartPizza('Proventos',
                                        getPorcentagem(holerite?.vencimentos ?? 10.0,
                                            holerite?.vencimentos != null && holerite?.liquido != null
                                                ? (holerite?.vencimentos ?? 0) + (holerite?.liquido ?? 0) :
                                            holerite?.vencimentos != null || holerite?.liquido != null
                                                ? (holerite?.vencimentos ?? 0) + (holerite?.liquido ?? 0) : 100.0),
                                      ),
                                      ChartPizza('Liquido',
                                        getPorcentagem(holerite?.liquido ?? 0.0,
                                            holerite?.vencimentos != null && holerite?.liquido != null
                                                ? (holerite?.vencimentos ?? 0) + (holerite?.liquido ?? 0) :
                                            holerite?.vencimentos != null || holerite?.liquido != null
                                                ? (holerite?.vencimentos ?? 0) + (holerite?.liquido ?? 0) : 100.0),)
                                    ],
                                    labelAccessorFn: (ChartPizza sales, _) => '${sales.valor.toString()}%')
                                ],
                                    animate: true,
                                    layoutConfig: charts.LayoutConfig(
                                      leftMarginSpec: common.MarginSpec.fixedPixel(0),
                                      rightMarginSpec: common.MarginSpec.fixedPixel(0),
                                      topMarginSpec: common.MarginSpec.fixedPixel(12),
                                      bottomMarginSpec: common.MarginSpec.fixedPixel(2),
                                    ),
                                    behaviors: [
                                      new charts.DatumLegend(
                                        position: charts.BehaviorPosition.bottom,
                                        horizontalFirst: true,
                                        cellPadding: EdgeInsets.only(left: width * 0.06, bottom: 2),
                                        entryTextStyle: common.TextStyleSpec(
                                          fontSize: (11).toInt(), color: charts.MaterialPalette.black,
                                        ),
                                        showMeasures: false,
                                        legendDefaultMeasure: charts.LegendDefaultMeasure.none,
                                      ),
                                    ],
                                    defaultRenderer: new charts.ArcRendererConfig(
                                        arcRendererDecorators: [
                                          charts.ArcLabelDecorator(
                                            insideLabelStyleSpec: charts.TextStyleSpec(
                                              fontSize: (12).toInt(), color: charts.MaterialPalette.white,
                                            ),
                                            outsideLabelStyleSpec: new charts.TextStyleSpec(
                                              fontSize: (11).toInt(), color: charts.MaterialPalette.black,
                                            ),
                                            labelPosition: charts.ArcLabelPosition.auto,
                                          )
                                        ])
                                ),
                              )
                            ],
                          )
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10,),
              Container(alignment: Alignment.center,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(25)
                  ),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text('L??quido nos ultimos 3 meses', style: TextStyle(color: Colors.black),),
                      SizedBox(height: 10,),
                      Container(height: height * 0.25,
                        child: charts.BarChart(
                          [charts.Series<ChartColum, String>(
                            id: 'Holerites',
                            displayName: 'L??quido nos ultimos 3 meses',
                            domainFn: (ChartColum sales, _) => sales.data,
                            measureFn: (ChartColum sales, _) => sales.valor,
                            colorFn: (_, __) => colors.Color.fromHex( code: 'f0D47A1'),
                            data: HoleriteModel().toColum(holerite!.historicos!.toList()),
                            labelAccessorFn: (ChartColum sales, _) =>
                            'R\$${sales.valor.toInt()}',
                          ),
                          ],
                          selectionModels: [
                            charts.SelectionModelConfig<String>(
                              type: charts.SelectionModelType.info,
                              updatedListener: (v){
                                if(v.selectedDatum.length > 0){
                                  context.read<HoleriteManager>().dropdowndata = v.selectedDatum.first.datum.data;

                                }
                              }
                            )
                          ],
                          animate: true,
                          vertical: true,
                          domainAxis: new charts.OrdinalAxisSpec(
                              renderSpec: new charts.SmallTickRendererSpec(

                                // Tick and Label styling here.
                                  labelStyle: new charts.TextStyleSpec(
                                      fontSize: (width * 0.03).toInt(), // size in Pts.
                                      color: charts.MaterialPalette.black),

                                  // Change the line colors to match text color.
                                  lineStyle: new charts.LineStyleSpec(
                                      color: charts.MaterialPalette.black))),
                          defaultRenderer: common.BarRendererConfig(
                            barRendererDecorator: charts.BarLabelDecorator<String>(
                                labelPadding: (height * 0.020).toInt(),
                                labelPlacement: common.BarLabelPlacement.opposeAxisBaseline,
                                insideLabelStyleSpec: charts.TextStyleSpec(
                                  fontSize: (width * 0.03).toInt(), color: charts.MaterialPalette.white,
                                ),
                                outsideLabelStyleSpec: new charts.TextStyleSpec(
                                  fontSize: (width * 0.03).toInt(), color: charts.MaterialPalette.black,
                                )
                            ),
                            cornerStrategy: const charts.ConstCornerStrategy(20),
                          ),
                        ),
                      ),
                    ],
                  )
              ),
              SizedBox(height: 15,),
              Text("Disponibilizado\n${holerite?.dataCriacao ?? ''}", textAlign: TextAlign.center,),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
          heroTag: 'File',
          backgroundColor: Config.corPri,
          focusColor: Colors.blue,
          foregroundColor: Colors.amber,
          hoverColor: Colors.green,
          splashColor: Colors.tealAccent,
          // focusColor: Settings.corPri.withOpacity(0.5),
          onPressed: () async {
            carregar(context);
            File? a = await HoleriteManager().holeriteresumo(
                context.read<UserHoleriteManager>().user,
                widget.mes, widget.ano, holerite?.holeriteTipoCod );
            Navigator.pop(context);
            if(a != null){
              await Navigator.push(context, MaterialPageRoute(
                  builder: (context)=> FileHero(a, 'holerite-${widget.ano}-${widget.mes}')));
            }else{
              InfoAlertBox(
                  context: context,
                  title: 'Aten????o',
                  infoMessage: 'N??o foi possivel carregar o holerite\nverifique sua conex??o com internet!',
                  buttonText: 'ok'
              );
            }
          },
          label: Text('Visualizar'.toUpperCase(), style: TextStyle(fontSize: 20, color: Colors.white),)

      ),
    );
  }
}
