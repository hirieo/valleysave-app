import 'package:flutter_test/flutter_test.dart';
import 'package:xml/xml.dart';
import 'package:valleysave/core/services/stardew_coop_preferences.dart';

void main() {
  group('StardewCoopPreferences.enable', () {
    test('adds the multiplayer flag and preserves other preferences', () {
      const source =
          '<map><boolean name="sound" value="false"/>'
          '<int name="language" value="1"/></map>';

      final updated = StardewCoopPreferences.enable(source)!;
      final map = XmlDocument.parse(updated).rootElement;

      expect(map.children.whereType<XmlElement>().length, 3);
      expect(
        map.children
            .whereType<XmlElement>()
            .singleWhere((element) => element.getAttribute('name') == 'sound')
            .getAttribute('value'),
        'false',
      );
      expect(
        map.children
            .whereType<XmlElement>()
            .singleWhere(
              (element) =>
                  element.getAttribute('name') == 'unlocked_multiplayer',
            )
            .getAttribute('value'),
        'true',
      );
    });

    test('changes a false flag and reports an already enabled flag', () {
      expect(
        StardewCoopPreferences.enable(
          '<map><boolean name="unlocked_multiplayer" value="false"/></map>',
        ),
        contains('value="true"'),
      );
      expect(
        StardewCoopPreferences.enable(
          '<map><boolean name="unlocked_multiplayer" value="true"/></map>',
        ),
        isNull,
      );
    });

    test('rejects duplicate or incorrectly typed multiplayer keys', () {
      expect(
        () => StardewCoopPreferences.enable(
          '<map><boolean name="unlocked_multiplayer" value="false"/>'
          '<boolean name="unlocked_multiplayer" value="true"/></map>',
        ),
        throwsFormatException,
      );
      expect(
        () => StardewCoopPreferences.enable(
          '<map><string name="unlocked_multiplayer">true</string></map>',
        ),
        throwsFormatException,
      );
    });
  });
}
