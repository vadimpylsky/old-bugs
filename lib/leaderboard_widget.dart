import 'dart:async';

import "package:collection/collection.dart";
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'event_bus.dart';
import 'http_client.dart';
import 'rest_client.dart';
import 'updated_event.dart';

class LeaderboardWidget extends StatelessWidget {
  const LeaderboardWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LeaderboardViewModel()..initialize(),
      child: Consumer<LeaderboardViewModel>(
        builder: (context, vm, child) {
          if (vm.fixes.isEmpty) {
            return Container();
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text("Fixes feed"),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              final model = vm.fixes[index];

                              return ListTile(
                                leading: Text(model.name!),
                                title: Text(model.issue!),
                                trailing: Text(model.points!.toString()),
                              );
                            },
                            itemCount: vm.fixes.length,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 188,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.black12),
                  ),
                  margin: const EdgeInsets.only(top: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text("Top fixers of the week"),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            var item = vm.top[index];
                            return ListTile(
                              leading: Text(item.name),
                              title: Text(item.points.toString()),
                              trailing:
                                  index == 0 ? const Icon(Icons.star) : null,
                            );
                          },
                          itemCount: vm.top.length,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

class LeaderboardViewModel extends ChangeNotifier {
  List<FixInfo> fixes = <FixInfo>[];
  StreamSubscription? _streamSubscription;

  List<TopItem> get top {
    if (fixes.isEmpty) {
      return <TopItem>[];
    }

    final group = groupBy<FixInfo, String?>(fixes, (x) => x.name);

    final topList = group.entries.map((x) {
      return TopItem(
        x.key!,
        x.value.map((y) => y.points!).reduce((item1, item2) => item1 + item2),
      );
    }).toList();

    topList.sort((a, b) => -a.points.compareTo(b.points));

    return topList;
  }

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
      fixes = await HttpClient.getFixes();
      notifyListeners();
    } catch (e) {
      //
    }
  }
}

class TopItem {
  final String name;
  final int points;

  TopItem(this.name, this.points);
}
