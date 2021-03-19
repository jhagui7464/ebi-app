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
    test('Should be at the loginscreen when opening app', () async {
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
      final appBar = find.byValueKey('welcome');

      await Future.delayed(const Duration(seconds: 1));
      driver.tap(userBox);
      await driver.enterText('MFOOD');
      await driver.waitFor(find.text('MFOOD'));
      await Future.delayed(const Duration(seconds: 1));
      driver.tap(passBox);
      await driver.enterText('1');
      await driver.waitFor(find.text('1'));
      driver.tap(loginButton);

      await Future.delayed(const Duration(seconds: 1));
      expect(await driver.getText(appBar), "Welcome, MFOOD");
    });

    /*
      Given when I am at the home screen
      and I press tracking
      Then I should see the operations screen
    */
    test('user should be able to go to the tracking operation search',
        () async {
      final tracking = find.byValueKey('tracking-button');
      final checkScreen = find.byValueKey('tracking-title');
      await Future.delayed(const Duration(seconds: 2));
      await driver.tap(tracking);
      expect(await driver.getText(checkScreen), "Tracking Operations");
    });

    test(
        'user should be able to go to the homescreen from the back button and the home button',
        () async {
      final bottomBar = find.byValueKey('bottom-bar');
      final tracking = find.byValueKey('tracking-button');
      final checkScreen = find.byValueKey('tracking-title');
      final appBar = find.byValueKey('welcome');

      await Future.delayed(const Duration(seconds: 2));
      await driver.waitFor(bottomBar);
      await Future.delayed(const Duration(seconds: 2));
      await driver.tap(find.text('Home'));
      expect(await driver.getText(appBar), "Welcome, MFOOD");
      await Future.delayed(const Duration(seconds: 2));
      await driver.tap(tracking);
      expect(await driver.getText(checkScreen), "Tracking Operations");
    });

    /*
      Given when I am at the settings screen
      and I press logout
      Then I should see the login screen
    */
    test('user should be able to log out from Settings', () async {
      final bottomBar = find.byValueKey('bottom-bar');
      final logoutButton = find.byValueKey('log-out');
      final loginscreenKey = find.byValueKey('login-text');
      await Future.delayed(const Duration(seconds: 2));
      await driver.waitFor(bottomBar);
      await Future.delayed(const Duration(seconds: 2));
      await driver.tap(find.text('Settings'));
      await driver.tap(logoutButton);
      expect(await driver.getText(loginscreenKey), 'Login');
    });
  });

  group('Sad Paths', () {
    /*
      Given when I am at the login screen
      and I enter a in username
      and I enter 1 in password
      Then I should see the login screen
    */
    test('entering wrong username or password should not let me enter',
        () async {
      final loginButton = find.byValueKey('login-button');
      final userBox = find.byValueKey('user-name');
      final passBox = find.byValueKey('pass-word');
      final loginscreenKey = find.byValueKey('login-text');
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

      expect(await driver.getText(loginscreenKey), 'Login');
    });
  });
}
