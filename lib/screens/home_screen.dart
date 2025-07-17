import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/screens/task_screen.dart';
import 'package:to_do_app/models/task_model.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_state.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {

  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';
  List<TaskModel> taskList = [];
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text(
          'Tasks',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TaskLoaded) {
            final allTasks = state.tasks;

            final filteredTasks = allTasks
                .where((task) =>
                task.title.toLowerCase().contains(searchQuery.toLowerCase()))
                .toList();

            final TaskModel? nearestTask = filteredTasks.isEmpty
                ? null
                : filteredTasks.reduce(
                  (a, b) => a.date.isBefore(b.date) ? a : b,
            );

            if (allTasks.isEmpty) {
              return _buildEmptyHome();
            }

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search for your task...',
                      hintStyle: const TextStyle(color: Colors.white54),
                      prefixIcon:
                      const Icon(Icons.search, color: Colors.white54),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white24),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  )),
          if (filteredTasks.isNotEmpty)
          Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
          onTap: () {
          showDialog(
          context: context,
          builder: (_) => AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text("Clear All Tasks?", style: TextStyle(color: Colors.white)),
          content: const Text("Are you sure you want to delete all tasks?", style: TextStyle(color: Colors.white70)),
          actions: [
          TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel", style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
          onPressed: () {
          context.read<TaskBloc>().add(ClearAllTasksEvent());
          Navigator.pop(context);
          },
          child: const Text("Clear All", style: TextStyle(color: Colors.redAccent)),
          ),
          ],
          ),
          );
          },
          child: const Text(
          "Clear All",
          style: TextStyle(color: Color(0xFF8687E7), fontSize: 14, fontWeight: FontWeight.w500),
          ),),),),
                if (filteredTasks.isEmpty && searchQuery.isNotEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 80),
                    child: Center(
                      child: Text(
                        'No matching task found',
                        style: TextStyle(color: Colors.white54, fontSize: 16),
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredTasks.length,
                      itemBuilder: (context, index) {
                        final task = filteredTasks[index];
                        return _buildTaskCard(task, nearestTask);
                      },
                    ),
                  ),
              ],
            );
          } else {
            return const Center(
              child: Text(
                'Something went wrong',
                style: TextStyle(color: Color(0xFF8687E7)),
              ),
            );
          }
        },
      ),
    floatingActionButton: Padding(
    padding: const EdgeInsets.only(bottom: 18.0, right: 10.0), // adjust as needed
    child:  SizedBox(
      width: 70,
      height: 70,
    child: FloatingActionButton(
      onPressed: () {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AddTaskScreen()),
    );
    },
    backgroundColor: const Color(0xFF8687E7),
    shape: const CircleBorder(),
    child: const Icon(
    Icons.add,
    color: Colors.white,  // ✅ White color for plus icon
    size: 35,             // ✅ Bigger icon size
    ),
    ),
    )));
  }

  Widget _buildTaskCard(TaskModel task, TaskModel? nearestTask)
  {
    bool isNearest = (task == nearestTask);
    bool isPriorityOne = task.priority.toLowerCase() == 'p 1';

      return GestureDetector(
          onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AddTaskScreen(task: task),
          ),
        );
      },
          onLongPress: () {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                backgroundColor: Colors.grey[900],
                title: const Text("Delete Task?", style: TextStyle(color: Colors.white)),
                content: const Text("Are you sure you want to delete this task?", style: TextStyle(color: Colors.white70)),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel", style: TextStyle(color: Colors.white54)),
                  ),
                  TextButton(
                    onPressed: () {
                      context.read<TaskBloc>().add(DeleteTaskEvent(task.id!));
                      Navigator.pop(context);
                    },
                    child: const Text("Delete", style: TextStyle(color: Colors.redAccent)),
                  ),
                ],
              ),
            );
          },
    child: Container(

      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              context.read<TaskBloc>().add(ToggleTaskCompletionEvent(task));
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 18),
              child: Icon(
                Icons.circle,
                size: 24,
                color: task.completed ? Colors.green : Colors.white54,
              ),
            ),
          ),

          const SizedBox(width: 12),


          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  task.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      '${task.date.day}-${task.date.month}-${task.date.year}',
                      style: const TextStyle(color: Colors.white54, fontSize: 13),
                    ),
                    const Spacer(),

                    // Category badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _categoryColor(task.category),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        task.category,
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                    const SizedBox(width: 8),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(6),
                        border: task.priority == 'P1'
                            ? Border.all(color: Colors.red, width: 1.5)
                            : null,
                      ),
                      child: Text(
                        task.priority,
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    ));
  }
  Color _categoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'grocery':
        return Colors.greenAccent;
      case 'work':
        return Colors.deepPurple;
      case 'sport':
        return Colors.cyanAccent;
      case 'home':
        return Colors.lightBlue;
      case 'university':
        return Colors.blueAccent;
      case 'social':
        return Colors.pinkAccent;
      case 'music':
        return Colors.purpleAccent;
      case 'health':
        return Colors.lightGreenAccent;
      case 'movie':
        return Colors.lightBlueAccent;
      default:
        return Colors.white24;
    }
  }
  Widget _buildEmptyHome() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/todo.png', width: 200, height: 200),
          const SizedBox(height: 10),
          const Text(
            'What do you want to do today?',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 5),
          const Text(
            'Tap + to add your tasks',
            style: TextStyle(color: Colors.white54, fontSize: 14),
          ),
        ],
      ),
    );
  }

}
