import 'package:flutter/material.dart';

class TableBuilder {
// generate table display upload response on UI
  List<TableRow> generateTableRows(final Map<String, dynamic> data) {
    final List<TableRow> rows = [];
    // final List<String> keys = data.keys.toList();
    final List<dynamic> values = data.values.toList();
    final List<TableCell> cells = [];
    for (int i = 0; i < values.length; i++) {
      cells.add(TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child:
        SelectableText(values[i].toString(), textAlign: TextAlign.center),
      ));
    }
    rows.add(TableRow(children: cells));

    return rows;
  }
}