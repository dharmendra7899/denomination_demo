import 'package:denomination/constants/context_extension.dart';
import 'package:denomination/constants/texts.dart';
import 'package:denomination/database/denomination_data_model.dart';
import 'package:denomination/database/denomination_database.dart';
import 'package:denomination/theme/colors.dart';
import 'package:denomination/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

class DenominationHistory extends StatefulWidget {
  const DenominationHistory({super.key});

  @override
  State<DenominationHistory> createState() => _DenominationHistoryState();
}

class _DenominationHistoryState extends State<DenominationHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(texts.history)),
      body: FutureBuilder<List<DenominationDataModel>>(
        future: DenominationDatabaseHelper.getRecords(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final records = snapshot.data!;
          if (records.isEmpty) return Center(child: Text("No saved records"));
          return ListView.separated(
            itemCount: records.length,
            itemBuilder: (context, index) {
              final record = records[index];
              final dateTime = DateTime.parse(record.timestamp);
              final formattedDate = DateFormat("MMM dd yyyy").format(dateTime);
              final formattedTime =
                  DateFormat("hh:mma").format(dateTime).toLowerCase();

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(width: 2, color: appColors.editTextColor),
                  ),

                  visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                  subtitle: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              texts.general,
                              style: context.textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              Utils.formatCurrency(record.totalAmount),
                              style: context.textTheme.bodyLarge,
                            ),
                            Text(
                              record.fileName,
                              style: context.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              formattedDate,
                              style: context.textTheme.bodySmall,
                            ),
                            Text(
                              formattedTime,
                              style: context.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  trailing: SizedBox(
                    width: 30,
                    child: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') {
                          Navigator.pushNamed(
                            context,
                            '/edit',
                            arguments: record,
                          );
                        } else if (value == 'delete') {
                          _confirmDelete(record.id!);
                        } else if (value == 'share') {
                          _shareRecord(record);
                        }
                      },
                      itemBuilder:
                          (context) => [
                            PopupMenuItem(
                              value: 'edit',
                              child: Text(texts.edit),
                            ),
                            PopupMenuItem(
                              value: 'share',
                              child: Text(texts.share),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Text(texts.delete),
                            ),
                          ],
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(height: 12);
            },
          );
        },
      ),
    );
  }

  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Delete Record"),
            content: Text("Are you sure you want to delete this record?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () async {
                  await DenominationDatabaseHelper.deleteRecord(id);
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                  setState(() {});
                },
                child: Text("Delete"),
              ),
            ],
          ),
    );
  }

  void _shareRecord(DenominationDataModel record) {
    final dateTime = DateTime.parse(record.timestamp);
    final formattedDate = DateFormat("MMM dd yyyy").format(dateTime);
    final formattedTime = DateFormat("hh:mma").format(dateTime).toLowerCase();

    final message = '''
💰 *File Name*: ${record.fileName}
📅 *Date*: $formattedDate
🕒 *Time*: $formattedTime
📊 *Total Amount*: ₹${record.totalAmount}
''';

    Share.share(message);
  }
}
