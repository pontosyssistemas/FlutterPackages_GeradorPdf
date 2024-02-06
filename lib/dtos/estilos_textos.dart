import 'package:flutter/material.dart';

class EstilosTexto {
  String fontFamily;
  double fontSize;
  bool negrito;

  EstilosTexto(
      {this.fontFamily = "Arial", this.fontSize = 12, this.negrito = false});

  get getNegrito {
    if (negrito) return FontWeight.bold;

    return FontWeight.normal;
  }

  static Map<String, dynamic> toJson(EstilosTexto source) {
    return {
      'Font': source.fontFamily,
      'FontSize': source.fontSize,
      'Negrito': source.negrito,
    };
  }

  factory EstilosTexto.fromJson(Map<String, dynamic> json) {
    return EstilosTexto(
        fontFamily: json["Font"],
        fontSize: json["FontSize"],
        negrito: json["Negrito"]);
  }
}
