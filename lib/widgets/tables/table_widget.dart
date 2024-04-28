import 'package:flutter/material.dart';
import 'package:excelmap/builder/table_builder.dart';

class TableWidget extends StatelessWidget {
  final Map<String, dynamic> data;

  const TableWidget(
      {Key? key, required this.data })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, String> readable_col_map = {
      "request_id": "Request Id",
      "input_data_file_name": "Data File Name",
      "input_data_file_rows": "Row Count",
      "input_data_file_columns": "Column Count",
      "input_data_file_size": "File Size (kb)",
      "input_filter_file_name": "Filter File Name",
      "input_filter_file_rows": "Row Count",
      "input_filter_file_columns": "Column Count",
      "input_filter_file_size": "File Size (kb)",
      "output_file_name": "Output File Name",
      "output_file_rows": "Row Count",
      "output_file_columns": "Column Count",
      "output_file_size": "File Size (kb)",
      "processing_time": "Processing Time (seconds)",
      "status": "Status"
    };
    TableBuilder tableBuilder = TableBuilder();

    return Table(
      border: TableBorder.all(),
      children: [
        TableRow(
          children: data.keys
              .map((key) => TableCell(
            verticalAlignment:
            TableCellVerticalAlignment.middle,
            child: SelectableText(
                readable_col_map.containsKey(key)
                    ? readable_col_map[key] ?? ""
                    : "",
                textAlign: TextAlign.center),
          ))
              .toList(),
        ),
        ...tableBuilder.generateTableRows(data),
      ],
    );
  }
}