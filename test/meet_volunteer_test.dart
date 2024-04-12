import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sce_project/browse.dart';
import 'package:sce_project/meet_volunteer.dart';
import 'package:sce_project/profile.dart';
// student: Firas Abu Sada
void main(){
      group('home page vaildation ', () {
        testWidgets('profile button navigates to profile page', (WidgetTester tester) async {
          await tester.pumpWidget(MaterialApp(
            home: MeetVolunteer(),
            routes: {
              ProfilePage.id: (context) => ProfilePage(), // Define the route
            },
          ));
          await tester.pump();
          final profileButtonFinder = find.byIcon(Icons.person);
          expect(profileButtonFinder, findsOneWidget);

          await tester.tap(profileButtonFinder);
          await tester.pumpAndSettle();

          expect(find.text('Profile Page'), findsOneWidget);
        });
        testWidgets('search button navigates to search/browse page',
        (WidgetTester tester)async {
      await tester.pumpWidget(MaterialApp(
        home: MeetVolunteer(),
        routes: {
          BrowsePage.id: (context) =>BrowsePage(),
        },
      ));
      await tester.pump();

      final searchButtonFinder = find.byIcon(Icons.search);
      expect(searchButtonFinder, findsOneWidget);

      await tester.tap(searchButtonFinder);
      await tester.pumpAndSettle();
      expect(find.text('Browse Page'), findsOneWidget);
    });
  });
}
