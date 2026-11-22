import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:darimmo_flutter/features/messaging/chat_screen.dart';
import 'package:darimmo_flutter/features/messaging/messages_screen.dart';

void main() {
  testWidgets('opens a demo conversation from the inbox', (tester) async {
    final router = GoRouter(
      initialLocation: '/messages',
      routes: [
        GoRoute(
          path: '/messages',
          builder: (context, state) => const MessagesScreen(),
        ),
        GoRoute(
          path: '/chat/:id',
          builder: (context, state) =>
              ChatScreen(conversationId: state.pathParameters['id']!),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));

    expect(find.text('Ahmed Ben Ali'), findsOneWidget);
    expect(
      find.text('Est-ce que la villa est toujours disponible ?'),
      findsOneWidget,
    );

    await tester.tap(find.text('Ahmed Ben Ali'));
    await tester.pumpAndSettle();

    expect(find.text('Sami Ben Ali'), findsOneWidget);
    expect(find.text('Villa avec jardin et piscine'), findsOneWidget);
    expect(
      find.text('Bonjour, la villa est-elle toujours disponible ?'),
      findsOneWidget,
    );
  });
}
