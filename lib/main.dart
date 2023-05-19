import 'package:document_app/extensions.dart';
import 'package:flutter/material.dart';

import 'data.dart';

void main() {
  runApp(const MyApp());
}

String dateFormat(DateTime dateTime) {
  final today = DateTime.now();
  final difference = dateTime.difference(today);

  final formatDate = switch (difference) {
    Duration(inDays: 0) => 'today',
    Duration(inDays: 1) => 'tomorrow',
    Duration(inDays: -1) => 'yesterday',
    Duration(inDays: final days) when days > 7 => '${days ~/ 7} weeks from now',
    Duration(inDays: final days) when days < -7 =>
      '${days.abs() / 7} weeks ago',
    Duration(inDays: final days, isNegative: true) => '${days.abs()} days ago',
    Duration(inDays: final days) => '$days days from now',
  };

  return formatDate;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: DocumentScreen(document: Document()),
    );
  }
}

class DocumentScreen extends StatelessWidget {
  final Document document;

  const DocumentScreen({
    required this.document,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final (title, :modified) = document.metadata;
    final formattedModifiedDate = dateFormat(modified);
    final blocks = document.getBlocks();

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        children: [
          Text('Last modified $formattedModifiedDate'),
          Expanded(
            child: ListView.builder(
                itemBuilder: ((context, index) {
                  return BlockWidget(block: blocks[index]);
                }),
                itemCount: blocks.length),
          )
        ],
      ),
    );
  }
}

class BlockWidget extends StatelessWidget {
  final Block block;
  const BlockWidget({super.key, required this.block});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // TextStyle? textStyle;
    // textStyle = switch (block.type) {
    //   'h1' => textTheme.displayMedium,
    //   'p' || 'checkbox' => context.textThemeExt.bodyMedium,
    //   _ => textTheme.bodySmall
    // };

    return Container(
        margin: const EdgeInsets.all(8.0),
        child: switch (block) {
          HeaderBlock(:final text) => Text(
              text,
              style: textTheme.titleMedium,
            ),
          ParagraphBlock(:final text) => Text(
              text,
              style: textTheme.bodyMedium,
            ),
          CheckboxBlock(:final text, :final isChecked) => Row(
              children: [
                Checkbox.adaptive(value: isChecked, onChanged: (onChanged) {}),
                Text(
                  text,
                  style: textTheme.bodySmall,
                )
              ],
            )
        });
  }
}
