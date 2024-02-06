import 'package:gerador_pdf/dtos/dados_relatorio.dart';
import 'package:gerador_pdf/dtos/estilos_tabela.dart';
import 'package:gerador_pdf/dtos/estilos_textos.dart';
import 'package:gerador_pdf/dtos/estilos_titulo_subtitulo_relatorio.dart';
import 'package:gerador_pdf/dtos/subtitulo_relatorio.dart';
import 'package:gerador_pdf/dtos/tipo_parametro.dart';
import 'package:gerador_pdf/dtos/titulo_relatorio.dart';
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