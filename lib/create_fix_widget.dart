import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:old_bugs/event_bus.dart';
import 'package:old_bugs/server_error.dart';
import 'package:provider/provider.dart';

import 'http_client.dart';
import 'rest_client.dart';
import 'updated_event.dart';

class CreateFixWidget extends StatefulWidget {
  const CreateFixWidget({Key? key}) : super(key: key);

  @override
  State<CreateFixWidget> createState() {
    return CreateFixWidgetState();
  }
}

class CreateFixWidgetState extends State<CreateFixWidget> {
  final _textEditingController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CreateFixViewModel(),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: Colors.black12),
        ),
        child: Consumer<CreateFixViewModel>(
          builder: (context, vm, child) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Submit yor ticket"),
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              hintText: "Jira ticket link...",
                              suffix: TextButton(
                                onPressed: () async {
                                  final date = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime.now(),
                                  );

                                  if (date == null) {
                                    return;
                                  }

                                  vm.dateTime = date;
                                },
                                child: Text(
                                  vm.dateTime == null
                                      ? "Created Date"
                                      : DateFormat("dd.MM.yyyy")
                                          .format(vm.dateTime!),
                                ),
                              ),
                            ),
                            controller: _textEditingController,
                          ),
                          Visibility(
                            visible: vm.errorText != null,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.error,
                                    color: Colors.red,
                                  ),
                                  const SizedBox(width: 4.0),
                                  Text(
                                    vm.errorText ?? "",
                                    style: const TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          ElevatedButton(
                            onPressed: () {
                              _addFix(vm, _textEditingController.text);
                            },
                            child: const Text("Submit"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _addFix(CreateFixViewModel vm, String link) async {
    final result = await vm.submit(link);

    if (result) {
      _textEditingController.clear();
    }
  }
}

class CreateFixViewModel extends ChangeNotifier {
  String? _errorText;
  DateTime? _dateTime;

  String? get errorText => _errorText;

  DateTime? get dateTime => _dateTime;

  set dateTime(DateTime? value) {
    _dateTime = value;
    notifyListeners();
  }

  Future<bool> submit(String link) async {
    if (link.isEmpty) {
      _errorText = "Please add jira ticket link";
      notifyListeners();
      return false;
    }

    if (dateTime == null) {
      _errorText = "Please enter jira ticket created date";
      notifyListeners();
      return false;
    }

    final dateString = dateTime!.toUtc().toIso8601String();

    try {
      await HttpClient.addFix(
        Fix(
          link: link,
          createdAt: dateString,
        ),
      );
    } on ServerError catch (e) {
      _errorText = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      return false;
    }

    _errorText = null;
    _dateTime = null;
    notifyListeners();
    eventBus.fire(UpdatedEvent());

    return true;
  }
}
