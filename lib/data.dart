import 'dart:convert';

class Document {
  final Map<String, Object?> _json;
  Document() : _json = jsonDecode(documentJson);

  (String, {DateTime modified}) get metadata {
    // if (_json.containsKey("metadata")) {
    //   final metadataJson = _json['metadata'];
    //   if (metadataJson is Map) {
    //     final title = metadataJson['title'] as String;
    //     final localModified = DateTime.parse(metadataJson['modified'] as String);

    //     return (title, modified: localModified);
    //   }
    // }
    if (_json
        case {
          'metadata': {'title': String title, 'modified': String localModified}
        }) {
      return (title, modified: DateTime.parse(localModified));
    } else {
      throw const FormatException("Unexpected Json");
    }
  }

  List<Block> getBlocks() {
    if (_json case {'blocks': List blocksJson}) {
      return [for (final blockJson in blocksJson) Block.fromJson(blockJson)];
    } else {
      throw const FormatException("Unexpected Json format");
    }
  }
}

const documentJson = '''
{
  "metadata": {
    "title": "My Document",
    "modified": "2023-06-10"
  },
  "blocks": [
    {
      "type": "h1",
      "text": "Chapter 1"
    },
    {
      "type": "p",
      "text": "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
    },
    {
      "type": "checkbox",
      "checked": true,
      "text": "Learn Dart 3"
    }
  ]
}
''';

sealed class Block {
  // final String type;
  // final String text;

  Block(); //this.type, this.text

  factory Block.fromJson(Map<String, Object?> json) {
    // if (json case {'type': final type, 'text': final text}) {
    //   return Block(type, text);
    // } else {
    //   throw const FormatException("Unexpected Json format");
    // }
    return switch (json) {
      {'type': 'h1', 'text': String text} => HeaderBlock(text),
      {'type': 'p', 'text': String text} => ParagraphBlock(text),
      {'type': 'checkbox', 'text': String text, 'checked': bool isChecked} =>
        CheckboxBlock(text, isChecked),
      _ => throw const FormatException("Unexpected Json Format")
    };
  }
}

class HeaderBlock extends Block {
  final String text;
  HeaderBlock(this.text);
}

class ParagraphBlock extends Block {
  final String text;
  ParagraphBlock(this.text);
}

class CheckboxBlock extends Block {
  final String text;
  final bool isChecked;
  CheckboxBlock(this.text, this.isChecked);
}
