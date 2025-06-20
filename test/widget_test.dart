import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:noesis/main.dart';
import 'package:noesis/viewmodels/login_viewmodel.dart';
import 'package:noesis/viewmodels/signup_viewmodel.dart';
import 'package:noesis/viewmodels/profile_viewmodel.dart';

void main() {
  testWidgets('MyApp loads and displays welcome screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LoginViewModel()),
          ChangeNotifierProvider(create: (_) => SignupViewModel()),
          ChangeNotifierProvider(create: (_) => ProfileViewModel()),
        ],
        child: MyApp(),
      ),
    );

    // Verify that our app loads correctly
    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(MyHomePage), findsOneWidget);

    // Verify that the Log in button is present
    expect(find.text('Log in'), findsOneWidget);

    // Verify that the Sign Up text is present
    expect(find.text('Sign Up'), findsOneWidget);
    expect(find.text("Don't have an account? "), findsOneWidget);
  });

  testWidgets('Navigation to login screen works', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LoginViewModel()),
          ChangeNotifierProvider(create: (_) => SignupViewModel()),
          ChangeNotifierProvider(create: (_) => ProfileViewModel()),
        ],
        child: MyApp(),
      ),
    );

    // Find and tap the Log in button
    await tester.tap(find.text('Log in'));
    await tester.pumpAndSettle(); // Wait for navigation animation

    // Verify that we navigated to login screen
    // You can add more specific checks here based on your LoginScreen content
    expect(find.byType(MyHomePage), findsNothing);
  });

  testWidgets('Navigation to signup screen works', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LoginViewModel()),
          ChangeNotifierProvider(create: (_) => SignupViewModel()),
          ChangeNotifierProvider(create: (_) => ProfileViewModel()),
        ],
        child: MyApp(),
      ),
    );

    // Find and tap the Sign Up text
    await tester.tap(find.text('Sign Up'));
    await tester.pumpAndSettle(); // Wait for navigation animation

    // Verify that we navigated away from home page
    expect(find.byType(MyHomePage), findsNothing);
  });

  testWidgets('App theme is applied correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LoginViewModel()),
          ChangeNotifierProvider(create: (_) => SignupViewModel()),
          ChangeNotifierProvider(create: (_) => ProfileViewModel()),
        ],
        child: MyApp(),
      ),
    );

    // Find the MaterialApp widget
    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));

    // Verify theme properties
    expect(materialApp.debugShowCheckedModeBanner, false);
    expect(materialApp.title, 'Mi Aplicación');

    // Verify that the app uses Material 3
    expect(materialApp.theme?.useMaterial3, true);
  });
}