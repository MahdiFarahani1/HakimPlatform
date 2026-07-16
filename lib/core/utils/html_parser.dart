import 'package:html/parser.dart' as html_parser;

String htmlToText(String html) {
  final document = html_parser.parse(html);
  return document.body?.text ?? '';
}
