import 'dart:convert';

extension ExtensionsJson on Map<String, dynamic> {
  dynamic decode(String nameProp) {
    return this[nameProp] == null ? null : jsonDecode(this[nameProp]);
  }
}

extension ExtensionsString on String {
  List<String> getVariables() {
    List<String> variaveis = [];
    final exp = RegExp(r'\$\{(.*?)\}');
    Iterable<RegExpMatch> matches = exp.allMatches(this);

    for (RegExpMatch match in matches) {
      var variavel = match.group(1);
      if (variavel != null) {
        variaveis.add(variavel);
      }
    }

    return variaveis;
  }
}
