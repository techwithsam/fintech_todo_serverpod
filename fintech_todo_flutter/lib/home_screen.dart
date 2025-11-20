import 'package:fintech_todo_client/fintech_todo_client.dart';
import 'package:fintech_todo_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  final _dateFmt = DateFormat('yyyy-MM-dd');
  List<Task> tasks = [];
  bool isLoading = false;
  String? errorMessage;
  VoidCallback? _statusListener;

  @override
  void initState() {
    super.initState();
    _loadTasks();
    _initRealtime();
    _statusListener = () {
      if (mounted) setState(() {});
    };
    client.addStreamingConnectionStatusListener(_statusListener!);
    sessionManager.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    if (_statusListener != null) {
      client.removeStreamingConnectionStatusListener(_statusListener!);
    }
    super.dispose();
  }

  Future<void> _initRealtime() async {
    try {
      await client.openStreamingConnection();
      client.task.stream.listen((message) {
        if (message is TaskEvent) {
          setState(() {
            switch (message.type) {
              case 'created':
                final exists = tasks.any((t) => t.id == message.task.id);
                if (!exists) tasks.insert(0, message.task);
                break;
              case 'updated':
                final i = tasks.indexWhere((t) => t.id == message.task.id);
                if (i != -1) tasks[i] = message.task;
                break;
              case 'deleted':
                tasks.removeWhere((t) => t.id == message.id);
                break;
            }
          });
        }
      });
    } catch (_) {}
  }

  Future<void> _loadTasks() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      final fetchedTasks = await client.task.getTasks();
      setState(() {
        tasks = fetchedTasks;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load tasks: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _createTask({
    required String title,
    required String description,
    required double amount,
    required DateTime dueDate,
  }) async {
    try {
      final created = await client.task.createTask(
        Task(
          title: title,
          description: description,
          dueDate: dueDate,
          amount: amount,
          userId: sessionManager.signedInUser!.id!,
        ),
      );
      setState(() {
        final exists = tasks.any((t) => t.id == created.id);
        if (!exists) tasks.insert(0, created);
      });
    } catch (e) {
      _showSnack("Create failed: $e");
    }
  }

  Future<void> _updateTask(Task original,
      {required String title,
      required String description,
      required double amount,
      required DateTime dueDate}) async {
    try {
      final updated = await client.task.updateTask(
        original.copyWith(
          title: title,
          description: description,
          amount: amount,
          dueDate: dueDate,
        ),
      );
      setState(() {
        final i = tasks.indexWhere((t) => t.id == updated.id);
        if (i != -1) tasks[i] = updated;
      });
    } catch (e) {
      _showSnack("Update failed: $e");
    }
  }

  Future<void> _deleteTask(Task task) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Delete Task"),
        content: Text("Delete '${task.title}'"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text("Delete"),
          ),
        ],
      ),
    );

    if (confirm != true) return;
    try {
      setState(() {
        tasks.removeWhere((t) => t.id == task.id);
      });
      await client.task.deleteTask(task.id!);
    } catch (e) {
      _showSnack("Delete failed: $e");
      _loadTasks();
    }
  }

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _openTaskForm({Task? task}) async {
    final isEdit = task != null;
    final titleCtrl = TextEditingController(text: task?.title ?? '');
    final descCtrl = TextEditingController(text: task?.description ?? '');
    final amountCtrl = TextEditingController(
      text: task != null ? task.amount.toStringAsFixed(2) : '',
    );
    DateTime? dueDate = task?.dueDate ?? DateTime.now();

    final result = await showModalBottomSheet<_TaskFormResult>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: StatefulBuilder(
            builder: (ctx, setSheetState) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(isEdit ? 'Edit Task' : 'New Task',
                        style: Theme.of(ctx).textTheme.titleLarge),
                    const SizedBox(height: 12),
                    TextField(
                      controller: titleCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: descCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: amountCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Amount',
                        prefixText: '\$ ',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: ctx,
                          initialDate: dueDate ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          setSheetState(() => dueDate = picked);
                        }
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Due Date',
                          border: OutlineInputBorder(),
                        ),
                        child: Text(dueDate != null
                            ? _dateFmt.format(dueDate!)
                            : 'Select date'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              final title = titleCtrl.text.trim();
                              final desc = descCtrl.text.trim();
                              final amtStr = amountCtrl.text.trim();
                              final amt = double.tryParse(amtStr);
                              if (title.isEmpty ||
                                  desc.isEmpty ||
                                  amt == null ||
                                  amt <= 0 ||
                                  dueDate == null) {
                                _showSnack('Please fill all fields correctly');
                                return;
                              }
                              Navigator.pop(
                                ctx,
                                _TaskFormResult(
                                  title: title,
                                  description: desc,
                                  amount: amt,
                                  dueDate: dueDate!,
                                ),
                              );
                            },
                            child: Text(isEdit ? 'Save' : 'Create'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              );
            },
          ),
        );
      },
    );

    if (result == null) return;

    if (isEdit) {
      await _updateTask(
        task,
        title: result.title,
        description: result.description,
        amount: result.amount,
        dueDate: result.dueDate,
      );
    } else {
      await _createTask(
        title: result.title,
        description: result.description,
        amount: result.amount,
        dueDate: result.dueDate,
      );
    }
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.playlist_add, size: 72, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'No trades yet—add one!',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () => _openTaskForm(),
            icon: const Icon(Icons.add),
            label: const Text('Add Trade'),
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    return RefreshIndicator(
      onRefresh: _loadTasks,
      child: ListView.separated(
        padding: const EdgeInsets.only(bottom: 100, top: 8),
        itemCount: tasks.length,
        separatorBuilder: (_, __) => const Divider(height: 0),
        itemBuilder: (ctx, i) {
          final t = tasks[i];
          return ListTile(
            onTap: () => _openTaskForm(task: t),
            title: Text(t.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if ((t.description).isNotEmpty) Text(t.description),
                Text('Amount: \$${t.amount.toStringAsFixed(2)}'),
                Text('Due: ${_dateFmt.format(t.dueDate!)}'),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _deleteTask(t),
              tooltip: 'Delete',
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = sessionManager.signedInUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('FinTech Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadTasks,
            tooltip: 'Refresh',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await sessionManager.signOutDevice();
              if (!context.mounted) return;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (c) => const SignInUp(),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openTaskForm(),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          if (user?.imageUrl != null && user!.imageUrl!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(user.imageUrl!),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Welcome ${user?.email ?? ''}',
              style: const TextStyle(fontSize: 16),
            ),
          ),
          if (errorMessage != null)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.red),
                  const SizedBox(width: 8),
                  Expanded(child: Text(errorMessage!)),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => setState(() => errorMessage = null),
                  ),
                ],
              ),
            ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : tasks.isEmpty
                    ? _buildEmpty()
                    : _buildList(),
          ),
        ],
      ),
    );
  }
}

class _TaskFormResult {
  final String title;
  final String description;
  final double amount;
  final DateTime dueDate;
  _TaskFormResult({
    required this.title,
    required this.description,
    required this.amount,
    required this.dueDate,
  });
}
