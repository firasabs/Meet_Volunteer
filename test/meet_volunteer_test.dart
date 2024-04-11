import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sce_project/interface/meet_volunteer.dart';
import 'package:sce_project/interface/browse.dart';
import 'package:sce_project/interface/yourprofile.dart';

import 'package:sce_project/interface/settings.dart';


void main() {

  Firebase.initializeApp();

  testWidgets('MeetVolunteer displays the correct tabs',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: MeetVolunteer()));

    expect(find.byType(ProfilePage), findsOneWidget);
    expect(find.byType(BrowsePage), findsOneWidget);
    expect(find.byType(SettingsPage), findsOneWidget);
  });

  testWidgets('MeetVolunteer displays the correct bottom navigation bar items',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: MeetVolunteer()));

    expect(find.byType(BottomNavigationBar), findsOneWidget);
    expect(find.byIcon(Icons.person), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
    expect(find.byIcon(Icons.settings), findsOneWidget);
  });

  testWidgets(
      'MeetVolunteer changes the current index when the bottom navigation bar item is tapped',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: MeetVolunteer()));

    expect(find.byIcon(Icons.person), findsOneWidget);
    await tester.tap(find.byIcon(Icons.search));
    await tester.pump();

    expect(find.byIcon(Icons.search), findsOneWidget);
  });

  testWidgets(
      'MeetVolunteer shows the correct tab when the bottom navigation bar item is tapped',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: MeetVolunteer()));

    expect(find.byType(ProfilePage), findsOneWidget);
    await tester.tap(find.byIcon(Icons.search));
    await tester.pump();

    expect(find.byType(BrowsePage), findsOneWidget);
  });

  testWidgets('MeetVolunteer displays the correct app bar title',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: MeetVolunteer()));

    expect(find.text('MeetVolunteer'), findsOneWidget);
  });

  testWidgets(
      'MeetVolunteer displays the correct number of action icons in the app bar',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: MeetVolunteer()));

    expect(find.byType(IconButton), findsNWidgets(3));
  });

  testWidgets('MeetVolunteer displays the correct icons in the app bar',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: MeetVolunteer()));

    expect(find.byIcon(Icons.people), findsOneWidget);
    expect(find.byIcon(Icons.notifications), findsOneWidget);
    expect(find.byIcon(Icons.logout), findsOneWidget);
  });
}
