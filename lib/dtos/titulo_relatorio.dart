import 'package:gerador_pdf/dtos/estilos_titulo_subtitulo_relatorio.dart';

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
