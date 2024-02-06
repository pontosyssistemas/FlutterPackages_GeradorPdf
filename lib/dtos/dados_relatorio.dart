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
