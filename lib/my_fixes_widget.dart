import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:old_bugs/rest_client.dart';
import 'package:provider/provider.dart';

import 'event_bus.dart';
import 'http_client.dart';
import 'updated_event.dart';

class MyFixesWidget extends StatelessWidget {
  const MyFixesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("My fixes"),
          ),
          Expanded(
            child: ChangeNotifierProvider(
              create: (_) => MyFixesViewModel()..initialize(),
              child: Consumer<MyFixesViewModel>(
                builder: (context, vm, child) {
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      final item = vm.fixes[index];

                      return ListTile(
                        leading: Text(
                          DateFormat("dd.MM, HH:mm").format(item.fixedAt!),
                        ),
                        title: Text(item.link!),
                        trailing: TextButton(
                          onPressed: () {
                            vm.delete(item);
                          },
                          child: const Icon(Icons.clear),
                        ),
                      );
                    },
                    itemCount: vm.fixes.length,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyFixesViewModel extends ChangeNotifier {
  List<FixEntity> fixes = <FixEntity>[];

  StreamSubscription? _streamSubscription;

  @override
  void dispose() {
    _streamSubscription?.cancel();

    super.dispose();
  }

  void initialize() {
    _loadData();

    _streamSubscription = eventBus.on<UpdatedEvent>().listen(
      (_) {
        _loadData();
      },
    );
  }

  Future<void> _loadData() async {
    try {
      fixes = await HttpClient.getMyFixes();
      notifyListeners();
    } catch (e) {
      //
    }
  }

  Future<void> delete(FixEntity item) async {
    await HttpClient.delete(item.id!);
    eventBus.fire(UpdatedEvent());
  }
}
