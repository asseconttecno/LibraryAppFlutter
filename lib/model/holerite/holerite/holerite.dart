import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';


class ChartPizza {
  final String desc;
  final double valor;

  ChartPizza(this.desc, this.valor);
}

class ChartColum {
  final int ind;
  final String data;
  final double valor;
  ChartColum(this.ind, this.data, this.valor);
}

// To parse this JSON data, do
//
//     final holeriteModel = holeriteModelFromMap(jsonString);


class HoleriteModel {
  HoleriteModel({
    this.holeriteTipo,
    this.holeriteTipoCod,
    this.vencimentos,
    this.descontos,
    this.liquido,
    this.dataCriacao,
    this.dataVisualizacao,
    this.historicos,
  });

  final String? holeriteTipo;
  final int? holeriteTipoCod;
  final double? vencimentos;
  final double? descontos;
  final double? liquido;
  final String? dataCriacao;
  final String? dataVisualizacao;
  final List<Historico>? historicos;

  factory HoleriteModel.fromJson(String str) => HoleriteModel.fromMap(json.decode(str));


  String toJson() => json.encode(toMap());

  factory HoleriteModel.fromMap(Map<String, dynamic> json) => HoleriteModel(
    holeriteTipo: json["holeriteTipo"] == null ? null : json["holeriteTipo"],
    holeriteTipoCod: competenciaCodigo(json["holeriteTipo"]),
    vencimentos: json["vencimentos"] == null ? null : double.tryParse(json["vencimentos"].toString().replaceAll('.', '').replaceAll(',', '.')),
    descontos: json["descontos"] == null ? null : double.tryParse(json["descontos"].toString().replaceAll('.', '').replaceAll(',', '.')),
    liquido: json["liquido"] == null ? null : double.tryParse(json["liquido"].toString().replaceAll('.', '').replaceAll(',', '.')),
    dataCriacao: json["dataCriacao"] == null ? null : json["dataCriacao"],
    dataVisualizacao: json["dataVisualizacao"] == null ? null : json["dataVisualizacao"],
    historicos: json["historicos"] == null ? null : List<Historico>.from(json["historicos"].map((x) => Historico.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "holeriteTipo": holeriteTipo == null ? null : holeriteTipo,
    "holeriteTipoCod": holeriteTipoCod == null ? null : holeriteTipoCod,
    "vencimentos": vencimentos == null ? null : vencimentos,
    "descontos": descontos == null ? null : descontos,
    "liquido": liquido == null ? null : liquido,
    "dataCriacao": dataCriacao == null ? null : dataCriacao,
    "dataVisualizacao": dataVisualizacao == null ? null : dataVisualizacao,
    "historicos": historicos == null ? null : List<dynamic>.from(historicos!.map((x) => x.toMap())),
  };

  static int competenciaCodigo(String? comp){
    switch (comp) {
      case "Sal??rio":
        return 1;
      case "Pr?? Labore":
        return 2;
      case "Adiantamento":
        return 3;
      case "1?? Parcela 13?? Sal??rio":
        return 4;
      case "2?? Parcela 13?? Sal??rio":
        return 5;
      case "PLR":
        return 6;
      case "Abono":
        return 7;
      default:
        return 1;
    }
  }

  List<ChartColum> toColum(List<Historico> list){
    int i = 0;
    List<ChartColum> listmap = [];
    if(list != null && (list.length ) > 0){
      while(i < ((list.length) > 3 ? 3 : (list.length )) ){
        listmap.add(ChartColum(i, list[i].competencia!, list[i].liquido! ),);
        i++;
      }
    }
    listmap.sort((a, b) => b.ind.compareTo(a.ind));
    return listmap;
  }
}

class Historico {
  Historico({
    this.competencia,
    this.liquido,
  });

  String? competencia;
  double? liquido;

  factory Historico.fromJson(String str) => Historico.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Historico.fromMap(Map<String, dynamic> json) {
    String _data = '';
    List s = json["competencia"].toString().split("/");
    if(s.length == 3){
      _data = DateFormat("MMMM y", 'Pt-Br').format(
          DateTime(int.parse(s[2].toString().split(' ').first), int.parse(s[1]), int.parse(s[0]) )).toUpperCase();
    }
    return Historico(
      competencia: _data,
      liquido: json["liquido"] == null ? null : double.tryParse(json["liquido"].toString().replaceAll('.', '').replaceAll(',', '.')),
    );
  }

  Map<String, dynamic> toMap() => {
    "competencia": competencia == null ? null : competencia,
    "liquido": liquido == null ? null : liquido,
  };

}


// To parse this JSON data, do
//
//     final competenciasModel = competenciasModelFromMap(jsonString);

class CompetenciasModel {
  CompetenciasModel({
    this.mes,
    this.ano,
    this.descricao,
  });

  int? mes;
  int? ano;
  String? descricao;

  List<CompetenciasModel> fromList(List json) {
    if(json.isNotEmpty){
      List<CompetenciasModel> list = json.map((e) => CompetenciasModel?.fromString(e.toString())).toList();
      try{
        list.sort((a,b) => b.ano!.compareTo(a.ano!) );
      }catch(e){
        debugPrint(e.toString());
      }
      return list;
    }else{
      return [];
    }
  }

  factory CompetenciasModel.fromString(String json) {
    List<String> _data = json.split("/");
    return CompetenciasModel(
      mes: int.tryParse(_data.first),
      ano: int.tryParse(_data.last),
      descricao: DateFormat("MMMM yyyy", 'Pt-Br').format(
          DateTime(int.parse(_data.last), int.parse(_data.first) )).toUpperCase(),
    );
  }
}

