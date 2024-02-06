import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:gerador_pdf/dtos/estilos_textos.dart';
import 'package:gerador_pdf/enums/aligment_enum.dart';
import 'package:gerador_pdf/enums/text_decoration_enum.dart';

class EstilosTituloSubTituloRelatorio extends EstilosTexto {
  AlignmentEnum alinhamento;
  FontStyle fontStyle;
  TextDecorationEnum textDecoration;

  EstilosTituloSubTituloRelatorio(
      {this.alinhamento = AlignmentEnum.center,
      this.fontStyle = FontStyle.normal,
      this.textDecoration = TextDecorationEnum.none,
      String font = "Arial",
      double size = 12,
      bool bold = false})
      : super(fontFamily: font, fontSize: size, negrito: bold);

  static Map<String, Object> toJsonString(
      EstilosTituloSubTituloRelatorio source) {
    return {
      'Font': source.fontFamily,
      'FontSize': source.fontSize,
      'Negrito': source.negrito,
      'Alinhamento': source.alinhamento.index,
      'FontStyle': source.fontStyle.index,
      'TextDecoration': source.textDecoration.index
    };
  }

  factory EstilosTituloSubTituloRelatorio.fromJsonString(
      Map<String, dynamic> json) {
    return EstilosTituloSubTituloRelatorio(
        font: json["Font"],
        size: json["FontSize"],
        bold: json["Negrito"],
        alinhamento: AlignmentEnum.values.firstWhere(
            (a) => a.index == json["Alinhamento"] as int,
            orElse: () => AlignmentEnum.center),
        fontStyle: FontStyle.values.firstWhere(
            (fs) => fs.index == json["FontStyle"] as int,
            orElse: () => FontStyle.normal),
        textDecoration: TextDecorationEnum.values.firstWhere(
            (td) => td.index == json["TextDecoration"] as int,
            orElse: () => TextDecorationEnum.none));
  }

  pw.Alignment getAlinhamentoPdf() {
    switch (alinhamento) {
      case AlignmentEnum.left:
        return pw.Alignment.topLeft;
      case AlignmentEnum.center:
        return pw.Alignment.center;
      case AlignmentEnum.right:
        return pw.Alignment.topRight;
      default:
        return pw.Alignment.center;
    }
  }

  pw.FontStyle getFontStylePdf() {
    switch (fontStyle) {
      case FontStyle.normal:
        return pw.FontStyle.normal;
      case FontStyle.italic:
        return pw.FontStyle.italic;
      default:
        return pw.FontStyle.normal;
    }
  }

  pw.TextDecoration getDecorationPdf() {
    switch (textDecoration) {
      case TextDecorationEnum.none:
        return pw.TextDecoration.none;
      case TextDecorationEnum.lineThrough:
        return pw.TextDecoration.lineThrough;
      case TextDecorationEnum.underline:
        return pw.TextDecoration.underline;
      case TextDecorationEnum.overline:
        return pw.TextDecoration.overline;
      default:
        return pw.TextDecoration.none;
    }
  }
}
