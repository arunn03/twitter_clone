import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stack_trace/stack_trace.dart';

import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone/features/home/view/home_view.dart';
import 'package:twitter_clone/theme/theme.dart';
import 'package:twitter_clone/features/auth/view/login_view.dart';

void main() {
  runApp(const ProviderScope(child: App()));
  FlutterError.demangleStackTrace = (StackTrace stack) {
    if (stack is Trace) return stack.vmTrace;
    if (stack is Chain) return stack.toTrace().vmTrace;
    return stack;
  };
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    return MaterialApp(
      darkTheme: AppTheme.theme,
      home: FutureBuilder(
        future: user,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen();
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return ErrorScreen(text: snapshot.error.toString());
            }
            if (snapshot.hasData) {
              return const HomeView();
            } else {
              return const LoginView();
            }
          }
          return ErrorScreen(text: snapshot.error.toString());
        },
      ),
      // home: user != null ? const HomeView() : const LoginView(),
      // .when(
      //   data: (data) {
      //     if (data != null) {
      //       return const HomeView();
      //     } else {
      //       return const LoginView();
      //     }
      //   },
      //   error: (error, stackTrace) {
      //     return ErrorScreen(text: error.toString());
      //   },
      //   loading: () {
      //     return const LoadingScreen();
      //   },
      // ),
    );
  }
}
