import 'package:gerador_pdf/dtos/estilos_textos.dart';

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
