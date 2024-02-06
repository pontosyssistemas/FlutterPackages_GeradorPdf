class TipoParametro {
  String id;
  String nome;

  TipoParametro({required this.id, required this.nome});

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Nome": nome,
      };
}
