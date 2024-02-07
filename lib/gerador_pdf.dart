library gerador_pdf;

import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:gerador_pdf/utils/extensions.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:gerador_pdf/models/models.dart';
import 'package:printing/printing.dart';

class PdfBase64 {
  final double fontSizeRowsTable = 8;
  final double fontSizeHeadersTable = 8;
  final double fontSizeTitle = 10;
  final double fontSizeSubtitle = 8;
  final fontPdfRegular = PdfGoogleFonts.robotoRegular();
  final fontPdfBold = PdfGoogleFonts.robotoBold();

  Future<String> obter(
      RelatorioDTO relatorio, List<ParametroRelatorioGerado> parametros) async {
    final pdf = pw.Document();
    final pageWidth =
        relatorio.orientacao ? PdfPageFormat.a4.height : PdfPageFormat.a4.width;
    final pageHeight =
        relatorio.orientacao ? PdfPageFormat.a4.width : PdfPageFormat.a4.height;
    final relatorioPdf = await _relatorioPdfWidget(relatorio, parametros);

    pdf.addPage(pw.MultiPage(
        margin: const pw.EdgeInsets.all(20),
        pageFormat: PdfPageFormat(pageWidth, pageHeight),
        maxPages: 999999,
        build: (context) => relatorioPdf));

    final pdfBytes = await pdf.save();
    return base64Encode(pdfBytes);
  }

  Future<List<pw.Widget>> _relatorioPdfWidget(
      RelatorioDTO relatorio, List<ParametroRelatorioGerado> parametros) async {
    final titulo = await _construirTituloPdf(relatorio.titulo);
    final subtitulo = relatorio.subTitulo != null
        ? await _construirSubTituloPdf(relatorio.subTitulo!, parametros)
        : pw.Container();
    if (relatorio.dados.dados.isNotEmpty) {
      final rows = await _construirDataTablePdf(relatorio);
      return List<pw.Widget>.generate(rows.keys.length, (index) {
        return pw.Column(children: [
          if (index == 0)
            pw.Header(
                level: 5,
                child: pw.Column(
                  children: [
                    titulo,
                    subtitulo,
                  ],
                )),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey200),
            children: rows[index]!,
          ),
        ]);
      });
    } else {
      return [
        pw.Column(children: [
          pw.Header(
              level: 5,
              child: pw.Column(
                children: [
                  titulo,
                  subtitulo,
                ],
              )),
          pw.Container(
            child: pw.Text(
              "Nenhum registro encontrado",
              style: pw.TextStyle(
                fontSize: 18,
                font: await fontPdfBold,
              ),
            ),
          )
        ])
      ];
    }
  }

  Future<pw.Widget> _construirTituloPdf(TituloRelatorio titulo) async {
    final estilosTitulo = titulo.estilos;

    return pw.Align(
      alignment: estilosTitulo.getAlinhamentoPdf(),
      child: pw.Text(
        titulo.texto,
        style: pw.TextStyle(
            fontSize: fontSizeTitle,
            fontStyle: estilosTitulo.getFontStylePdf(),
            font: estilosTitulo.negrito
                ? await fontPdfBold
                : await fontPdfRegular,
            decoration: estilosTitulo.getDecorationPdf()),
      ),
    );
  }

  Future<pw.Widget> _construirSubTituloPdf(SubtituloRelatorio subtitulo,
      List<ParametroRelatorioGerado> parametros) async {
    final estilos = subtitulo.estilos;

    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 10, bottom: 5),
      child: pw.Align(
        alignment: estilos.getAlinhamentoPdf(),
        child: pw.Text(
          _obterSubtituloFormatado(subtitulo, parametros),
          style: pw.TextStyle(
              fontSize: fontSizeSubtitle,
              fontStyle: estilos.getFontStylePdf(),
              font: estilos.negrito ? await fontPdfBold : await fontPdfRegular,
              decoration: estilos.getDecorationPdf()),
        ),
      ),
    );
  }

  Future<Map<int, List<pw.TableRow>>> _construirDataTablePdf(
      RelatorioDTO relatorio) async {
    final rowsTable = await _construirLinhasPdf(relatorio);
    final qtdRows = rowsTable.length;
    final pageSizeFirstPageLandscape =
        relatorio.subTitulo != null && relatorio.subTitulo!.texto.isNotEmpty
            ? 24
            : 25;
    final pageSizeOtherPagesLandscape =
        relatorio.estilosTabela.repetirCabecalho ? 27 : 28;
    final pageSizeFirstPagePortrait =
        relatorio.subTitulo != null && relatorio.subTitulo!.texto.isNotEmpty
            ? 37
            : 38;
    final pageSizeOtherPagesPortrait =
        relatorio.estilosTabela.repetirCabecalho ? 40 : 41;
    final pageSizeFirstPage = relatorio.orientacao
        ? pageSizeFirstPageLandscape
        : pageSizeFirstPagePortrait;
    final pageSizeOtherPages = relatorio.orientacao
        ? pageSizeOtherPagesLandscape
        : pageSizeOtherPagesPortrait;

    Map<int, List<pw.TableRow>> rows = {};
    int currentPage = 0;
    int currentIndex = 0;

    while (currentIndex < qtdRows) {
      rows[currentPage] = [];

      var pageSize =
          (currentPage == 0) ? pageSizeFirstPage : pageSizeOtherPages;

      for (var index = 0; index < pageSize; index++) {
        if (currentIndex < qtdRows) {
          if ((currentPage == 0 && index == 0) ||
              (index == 0 && relatorio.estilosTabela.repetirCabecalho)) {
            final columnsTable = await _construirColunasPdf(relatorio);
            rows[currentPage]!.add(columnsTable);
          }

          rows[currentPage]!.add(rowsTable[currentIndex]);
          currentIndex++;
        } else {
          break;
        }
      }

      currentPage++;
    }

    return rows;
  }

  Future<pw.TableRow> _construirColunasPdf(RelatorioDTO relatorio) async {
    List<pw.Padding> colunas = [];

    await relatorio.dados.dados.first.keys.forEach((key) async {
      colunas.add(
        pw.Padding(
          padding:
              const pw.EdgeInsets.only(top: 5, bottom: 5, left: 2, right: 2),
          child: pw.Text(
            key,
            style: pw.TextStyle(
              font: relatorio.estilosTabela.cabecalho.negrito
                  ? await fontPdfBold
                  : await fontPdfRegular,
              fontSize: fontSizeHeadersTable,
            ),
            maxLines: 1,
            overflow: pw.TextOverflow.clip,
            softWrap: false,
          ),
        ),
      );
    });

    return pw.TableRow(
        children: colunas, repeat: relatorio.estilosTabela.repetirCabecalho);
  }

  Future<List<pw.TableRow>> _construirLinhasPdf(
      RelatorioDTO relatorio) async {
    var tabela = relatorio.dados.dados;
    List<pw.TableRow> rows = [];

    for (var i = 0; i < tabela.length; i++) {
      var item = tabela[i];
      List<pw.Padding> dataCells = [];

      await item.values.forEach((value) async {
        dataCells.add(pw.Padding(
          padding:
              const pw.EdgeInsets.only(top: 5, bottom: 5, left: 2, right: 2),
          child: pw.Text(
            value,
            style: pw.TextStyle(
              color: PdfColors.black,
              font: relatorio.estilosTabela.linhas.negrito
                  ? await fontPdfBold
                  : await fontPdfRegular,
              fontSize: fontSizeRowsTable,
            ),
            maxLines: 1,
            overflow: pw.TextOverflow.clip,
            softWrap: false,
          ),
        ));
      });

      rows.add(pw.TableRow(
          children: dataCells,
          decoration: pw.BoxDecoration(
            color: relatorio.estilosTabela.ehListrada
                ? (i % 2 == 0 ? PdfColors.grey100 : PdfColors.white)
                : PdfColors.white,
          )));
    }

    if (relatorio.dados.totais.isNotEmpty) {
      var totais = relatorio.dados.totais;
      List<pw.Padding> dataCellsTotais = [];
      var item = tabela.first;

      await item.keys.forEach((value) async {
        var campoTotal = totais.firstWhereOrNull(
          (c) => c.campo.toLowerCase() == value.toString().toLowerCase(),
        );

        var textCampoTotal = campoTotal == null ? "" : campoTotal.total;
        dataCellsTotais.add(
          pw.Padding(
            padding:
                const pw.EdgeInsets.only(top: 5, bottom: 5, left: 2, right: 2),
            child: pw.Text(
              textCampoTotal,
              style: pw.TextStyle(
                color: PdfColors.black,
                font: await fontPdfBold,
                fontSize: fontSizeRowsTable,
              ),
              maxLines: 1,
              overflow: pw.TextOverflow.clip,
              softWrap: false,
            ),
          ),
        );
      });

      rows.add(
        pw.TableRow(
          children: dataCellsTotais,
          decoration: const pw.BoxDecoration(color: PdfColors.grey300),
        ),
      );
    }

    return rows;
  }

  String _obterSubtituloFormatado(
      SubtituloRelatorio subtitulo, List<ParametroRelatorioGerado> parametros) {
    final variaveis = subtitulo.texto.getVariables();
    var texto = [subtitulo.texto][0];

    for (var variavel in variaveis) {
      var parametro = parametros
          .firstWhereOrNull((item) => item.parametro == "\$$variavel");

      if (parametro != null &&
          parametro.valor != null &&
          parametro.valor.toString().isNotEmpty) {
        var valorParametro = "";
        final paramData = DateTime.tryParse(parametro.valor.toString());
        if (paramData != null) {
          valorParametro = DateFormat("dd/MM/yyyy").format(paramData);
        } else {
          valorParametro = parametro.valor.toString();
        }

        texto = texto.replaceAll("\${$variavel}", valorParametro);
      }
    }

    return texto;
  }
}
