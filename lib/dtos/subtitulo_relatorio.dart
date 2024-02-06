import 'package:gerador_pdf/dtos/estilos_titulo_subtitulo_relatorio.dart';

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
