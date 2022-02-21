import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as developer;

import 'create_fix_widget.dart';
import 'leaderboard_widget.dart';
import 'my_fixes_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        return HomeViewModel()..initialize();
      },
      child: Consumer<HomeViewModel>(
        builder: (context, vm, child) {
          if (vm.isLoggedIn) {
            return Scaffold(
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            FirebaseAuth.instance.signOut();
                          },
                          child: const Text("Sign Out"),
                        ),
                        const SizedBox(width: 8.0),
                        Text(vm.userName),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        const Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: LeaderboardWidget(),
                          ),
                          flex: 6,
                        ),
                        Expanded(
                          flex: 4,
                          child: Column(
                            children: const [
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: CreateFixWidget(),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: MyFixesWidget(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return Center(
            child: ElevatedButton(
              onPressed: vm.signInWithGoogle,
              child: const Text("Sign in with Google"),
            ),
          );
        },
      ),
    );
  }
}

class HomeViewModel extends ChangeNotifier {
  StreamSubscription? _subscription;
  User? _user;

  bool get isLoggedIn => _user != null;

  String get userName => _user?.displayName ?? "";

  void initialize() {
    _user = FirebaseAuth.instance.currentUser;
    _subscription ??=
        FirebaseAuth.instance.authStateChanges().listen(onUserChanged);
  }

  Future<void> signInWithGoogle() async {
    try {
      await FirebaseAuth.instance.signInWithPopup(GoogleAuthProvider());
    } catch (e) {
      //TODO
    }
  }

  void onUserChanged(User? user) {
    _user = user;
    notifyListeners();
    _getToken(user);
  }

  Future<void> _getToken(User? user) async {
    if (user == null) {
      return;
    }

    final token = await user.getIdToken();
    developer.log(token);
  }
}
