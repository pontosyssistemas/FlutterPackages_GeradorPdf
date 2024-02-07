import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:gerador_pdf/enums/enums.dart';
import 'package:gerador_pdf/utils/extensions.dart';

class RelatorioDTO {
  TituloRelatorio titulo;
  SubtituloRelatorio? subTitulo;
  EstilosTabela estilosTabela;
  DadosRelatorioDTO dados;
  bool orientacao;

  RelatorioDTO({
    required this.titulo,
    this.subTitulo,
    required this.dados,
    required this.estilosTabela,
    required this.orientacao,
  });

  factory RelatorioDTO.getInstance() {
    return RelatorioDTO(
        titulo: TituloRelatorio(
            texto: "", estilos: EstilosTituloSubTituloRelatorio()),
        subTitulo: null,
        dados: DadosRelatorioDTO.getInstance(),
        estilosTabela:
            EstilosTabela(cabecalho: EstilosTexto(), linhas: EstilosTexto()),
        orientacao: false);
  }

  Map<String, dynamic> toJson() => {
        'Titulo': TituloRelatorio.toJson(titulo),
        'Subtitulo': subTitulo ?? SubtituloRelatorio.toJson(subTitulo!),
        'EstilosTabela': EstilosTabela.toJsonString(estilosTabela),
        'Orientacao': orientacao,
      };

  RelatorioDTO fromJson(Map<String, dynamic> json) {
    return RelatorioDTO(
      titulo: TituloRelatorio.fromJsonString(json.decode("Titulo")),
      subTitulo: SubtituloRelatorio.fromJsonString(json.decode("Subtitulo")),
      dados: DadosRelatorioDTO.fromJson(json["Dados"]),
      estilosTabela: EstilosTabela.fromJsonString(json.decode("EstilosTabela")),
      orientacao: json["Orientacao"],
    );
  }

  List<RelatorioDTO> fromJsonToList(Iterable list) {
    return List<RelatorioDTO>.from(
      list.map((model) => fromJson(model)),
    );
  }
}

class ParametroRelatorioGerado {
  final String? parametro;
  final Object? valor;
  final TipoParametro? tipo;

  ParametroRelatorioGerado({this.parametro, this.valor, required this.tipo});

  Map<String, dynamic> toJson() => {
        "Parametro": parametro,
        "Valor": valor,
        "TipoParametro": tipo?.toJson(),
      };
}

class DadosRelatorioDTO {
  List<dynamic> dados;
  List<TotalCampo> totais;

  DadosRelatorioDTO({required this.dados, required this.totais});

  factory DadosRelatorioDTO.getInstance() {
    return DadosRelatorioDTO(dados: [], totais: []);
  }

  static DadosRelatorioDTO fromJson(Map<String, dynamic> json) {
    return DadosRelatorioDTO(
      dados: json["Dados"],
      totais: TotalCampo.fromJsonToList(json["Totais"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "Dados": dados,
        "Totais": totais,
      };
}

class TotalCampo {
  String campo;
  String total;

  TotalCampo({required this.campo, required this.total}) {
    total = total;
  }

  static fromJsonString(Map<String, dynamic> json) {
    return TotalCampo(campo: json["Campo"], total: json["Total"]);
  }

  static List<TotalCampo> fromJsonToList(Iterable list) {
    return List<TotalCampo>.from(
        list.map((model) => TotalCampo.fromJsonString(model)));
  }

  Map<String, dynamic> toJson() => {'Campo': campo, 'Total': total};
}

class EstilosTabela {
  EstilosTexto cabecalho;
  EstilosTexto linhas;
  bool ehListrada;
  bool repetirCabecalho;

  EstilosTabela({
    required this.cabecalho,
    required this.linhas,
    this.ehListrada = true,
    this.repetirCabecalho = true,
  });

  static Map<String, dynamic> toJsonString(EstilosTabela source) {
    return {
      'Cabecalho': EstilosTexto.toJson(source.cabecalho),
      'Linhas': EstilosTexto.toJson(source.linhas),
      'EhListrada': source.ehListrada,
      'RepetirCabecalhoNasPaginas': source.repetirCabecalho,
    };
  }

  factory EstilosTabela.fromJsonString(Map<String, dynamic> json) {
    return EstilosTabela(
        cabecalho: EstilosTexto.fromJson(json["Cabecalho"]),
        linhas: EstilosTexto.fromJson(json["Linhas"]),
        ehListrada: json["EhListrada"],
        repetirCabecalho: json["RepetirCabecalho"]);
  }
}

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

class SubtituloRelatorio {
  String texto;
  EstilosTituloSubTituloRelatorio estilos;

  SubtituloRelatorio({required this.estilos, required this.texto});

  static Map<String, dynamic> toJson(SubtituloRelatorio source) {
    return {
      'Texto': source.texto,
      'EstilosSubtitulo':
          EstilosTituloSubTituloRelatorio.toJsonString(source.estilos),
    };
  }

  static SubtituloRelatorio? fromJsonString(Map<String, dynamic>? json) {
    if (json == null) return null;
    return SubtituloRelatorio(
      texto: json["Texto"],
      estilos: EstilosTituloSubTituloRelatorio.fromJsonString(json["Estilos"]),
    );
  }
}

class TipoParametro {
  String id;
  String nome;

  TipoParametro({required this.id, required this.nome});

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Nome": nome,
      };
}

class TituloRelatorio {
  String texto;
  EstilosTituloSubTituloRelatorio estilos;

  TituloRelatorio({required this.texto, required this.estilos});

  static Map<String, dynamic> toJson(TituloRelatorio source) {
    return {
      'Texto': source.texto,
      'EstilosTitulo':
          EstilosTituloSubTituloRelatorio.toJsonString(source.estilos)
    };
  }

  factory TituloRelatorio.fromJsonString(Map<String, dynamic> json) {
    return TituloRelatorio(
        texto: json["Texto"],
        estilos:
            EstilosTituloSubTituloRelatorio.fromJsonString(json["Estilos"]));
  }
}