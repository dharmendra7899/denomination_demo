import 'package:denomination/constants/assets/const_images.dart';
import 'package:denomination/constants/context_extension.dart';
import 'package:denomination/constants/texts.dart';
import 'package:denomination/database/denomination_data_model.dart';
import 'package:denomination/database/denomination_database.dart';
import 'package:denomination/routes/routes_names.dart';
import 'package:denomination/theme/colors.dart';
import 'package:denomination/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:number_to_words/number_to_words.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<TextEditingController> _controllers = [];
  final List<int> noteValues = [2000, 500, 200, 100, 50, 20, 10];
  double total = 0;
  bool showTitle = true;

  @override
  void initState() {
    super.initState();
    _controllers.addAll(
      List.generate(noteValues.length, (_) => TextEditingController()),
    );
    for (var controller in _controllers) {
      controller.addListener(_recalculateTotal);
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _recalculateTotal() {
    double sum = 0;
    for (int i = 0; i < _controllers.length; i++) {
      final qty = int.tryParse(_controllers[i].text) ?? 0;
      sum += noteValues[i] * qty;
    }
    setState(() {
      total = sum;
    });
  }

  void _clearAllEntries() {
    for (var controller in _controllers) {
      controller.clear();
    }
    _recalculateTotal();
  }

  String _convertToWords(int amount) {
    if (amount == 0) return "zero rupees";
    String words = NumberToWord().convert('en-in', amount);
    return "${words[0].toUpperCase()}${words.substring(1)} rupees";
  }

  void _clearRow(int index) {
    setState(() {
      showTitle = true;
      _controllers[index].clear();
      _recalculateTotal();
    });
  }

  saveData(String fileName) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 12),
          backgroundColor: appColors.appWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text("Enter File Name", style: context.textTheme.bodyLarge),
          content: TextField(
            onChanged: (val) => fileName = val,
            decoration: InputDecoration(hintText: "file name"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                if (fileName.trim().isEmpty) return;
                final record = DenominationDataModel(
                  totalAmount: total,
                  fileName: fileName.trim(),
                  timestamp: DateTime.now().toString(),
                );
                await DenominationDatabaseHelper.insertRecord(
                  record,
                ).then((value) => _clearAllEntries());
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Data saved as $fileName")),
                  );
                }
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.appWhite,
      floatingActionButton: PopupMenuButton<String>(
        onSelected: (value) {
          if (value == 'save') {
            String fileName = '';
            saveData(fileName);
          } else if (value == 'clear') {
            _clearAllEntries();
          }
        },
        itemBuilder:
            (context) => [
              PopupMenuItem(value: 'save', child: Text('Save')),
              PopupMenuItem(value: 'clear', child: Text('Clear Values')),
            ],
        child: FloatingActionButton(
          backgroundColor: appColors.primary,
          onPressed: null,
          child: Icon(Icons.menu, color: appColors.appWhite),
        ),
      ),

      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height * 0.165,
            collapsedHeight: 60,
            centerTitle: false,
            pinned: true,
            floating: true,
            backgroundColor: Colors.transparent,
            actions: [
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert,
                  size: 30,
                  color: appColors.appWhite,
                ),
                onSelected: (value) {
                  if (value == 'history') {
                    Navigator.pushNamed(context, RouteNames.historyScreen);
                  }
                },
                itemBuilder:
                    (context) => [
                      PopupMenuItem(
                        value: 'history',
                        child: Text(texts.history),
                      ),
                    ],
              ),

              SizedBox(width: 6),
            ],
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(ConstantImage.currencyBanner),
                      fit: BoxFit.fill,
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(4),
                      bottomRight: Radius.circular(4),
                    ),
                  ),
                  child: FlexibleSpaceBar(
                    centerTitle: true,
                    background: _buildExpandedContent(context),
                  ),
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: ListView.separated(
                padding: EdgeInsets.symmetric(vertical: 16),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: noteValues.length,
                separatorBuilder: (_, __) => SizedBox(height: 16),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 100,
                          child: Text(
                            Utils.formatCurrency(noteValues[index]),
                            style: context.textTheme.bodyMedium,
                          ),
                        ),
                        Text("x", style: context.textTheme.bodyMedium),
                        SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(6),
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            maxLines: 1,
                            controller: _controllers[index],
                            keyboardType: TextInputType.number,
                            style: context.textTheme.bodyMedium,
                            onChanged: (value) {
                              setState(() {
                                showTitle = false;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: "Qty",
                              hintStyle: context.textTheme.bodyMedium?.copyWith(
                                color: appColors.editTextColor,
                              ),

                              suffixIcon:
                                  _controllers[index].text.isNotEmpty
                                      ? IconButton(
                                        icon: Icon(
                                          Icons.clear,
                                          size: 18,
                                          color: Colors.grey,
                                        ),
                                        onPressed: () => _clearRow(index),
                                      )
                                      : null,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: appColors.editTextColor,
                                  width: 2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 2,
                                  color: appColors.primary,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Text("=", style: context.textTheme.bodyMedium),
                        SizedBox(width: 12),
                        Text(
                          Utils.formatCurrency(
                            (int.tryParse(_controllers[index].text) ?? 0) *
                                noteValues[index],
                          ),
                          style: context.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          showTitle == true
              ? Padding(
                padding: const EdgeInsets.only(top: 80.0),
                child: Text(
                  texts.appName,
                  style: context.textTheme.headlineLarge?.copyWith(
                    color: appColors.appWhite,
                  ),
                ),
              )
              : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 30),
                  Text(
                    texts.totalAmount,
                    style: context.textTheme.titleLarge?.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: appColors.appWhite,
                    ),
                    maxLines: 2,
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    Utils.formatCurrency(total),
                    style: context.textTheme.titleLarge?.copyWith(
                      color: appColors.appWhite,
                    ),
                    maxLines: 1,
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    _convertToWords(total.toInt()),
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: appColors.appWhite,
                    ),
                    maxLines: 2,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
        ],
      ),
    );
  }
}
