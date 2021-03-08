import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  FlutterDriver driver;

  // Connect to the Flutter driver before running any tests.
  setUpAll(() async {
    driver = await FlutterDriver.connect();
  });

  // Close the connection to the driver after the tests have completed.
  tearDownAll(() async {
    if (driver != null) {
      driver.close();
    }
  });

  group('Happy Paths', () {
    test('Should be at the homescreen when opening app', () async {
      await Future.delayed(const Duration(seconds: 4));
      final loginscreenKey = find.byValueKey('login-text');
      expect(await driver.getText(loginscreenKey), 'Login');
    });
    /*
      Given when I am at the login screen
      and I press username
      and I input MFOOD
      and I press password
      and I input 1
      Then I should see the main screen
    */
    test('should be able to login with test user', () async {
      final loginButton = find.byValueKey('login-button');
      final userBox = find.byValueKey('user-name');
      final passBox = find.byValueKey('pass-word');

      await Future.delayed(const Duration(seconds: 2));
      driver.tap(userBox);
      await driver.enterText('MFOOD');
      await driver.waitFor(find.text('MFOOD'));
      await Future.delayed(const Duration(seconds: 2));
      driver.tap(passBox);
      await driver.enterText('1');
      await driver.waitFor(find.text('1'));
      driver.tap(loginButton);
    });
  });

  group('Sad Paths', () {
    test('entering wrong username or password should give an error message',
        () async {
      final loginButton = find.byValueKey('login-button');
      final userBox = find.byValueKey('user-name');
      final passBox = find.byValueKey('pass-word');
      final notifKey = find.byValueKey('notification');

      await Future.delayed(const Duration(seconds: 2));
      driver.tap(userBox);
      await driver.enterText('a');
      await driver.waitFor(find.text('a'));
      await Future.delayed(const Duration(seconds: 2));
      driver.tap(passBox);
      await driver.enterText('1');
      await driver.waitFor(find.text('1'));
      await Future.delayed(const Duration(seconds: 2));
      driver.tap(loginButton);
      driver.tap(loginButton);
      driver.tap(loginButton);

      expect(
          await driver.getText(notifKey), 'Username or Password are Invalid');
    });
  });
}
