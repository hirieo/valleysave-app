import 'package:xml/xml.dart' as xml;

/// Edits only Stardew's hidden multiplayer preference while retaining the rest
/// of Android's preferences document.
class StardewCoopPreferences {
  /// Returns null when the setting is already enabled.
  static String? enable(String source) {
    final document = xml.XmlDocument.parse(source);
    final map = document.rootElement;
    if (map.name.local != 'map') {
      throw const FormatException('Expected a preferences map.');
    }
    final matches = map.children
        .whereType<xml.XmlElement>()
        .where(
          (element) => element.getAttribute('name') == 'unlocked_multiplayer',
        )
        .toList();
    if (matches.length > 1 ||
        (matches.isNotEmpty && matches.single.name.local != 'boolean')) {
      throw const FormatException('Ambiguous multiplayer preference.');
    }
    if (matches.length == 1 && matches.single.getAttribute('value') == 'true') {
      return null;
    }
    if (matches.isEmpty) {
      map.children.add(
        xml.XmlElement(xml.XmlName('boolean'), [
          xml.XmlAttribute(xml.XmlName('name'), 'unlocked_multiplayer'),
          xml.XmlAttribute(xml.XmlName('value'), 'true'),
        ]),
      );
    } else {
      matches.single.setAttribute('value', 'true');
    }
    return document.toXmlString(pretty: false);
  }
}
