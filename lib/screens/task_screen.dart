import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/task_event.dart';
import '../bloc/task_bloc.dart';
import '../models/task_model.dart';
import 'home_screen.dart';

class AddTaskScreen extends StatefulWidget {
  final TaskModel? task;

  const AddTaskScreen({super.key, this.task});


  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      selectedDate = widget.task!.date;
      selectedCategory = widget.task!.category;
      selectedPriority = widget.task!.priority;
    }
  }
  String selectedPriority = 'P1';
  DateTime selectedDate = DateTime.now();
  String selectedCategory = 'Select';
  final TextEditingController _titleController = TextEditingController();

  final List<Map<String, dynamic>> _defaultCategories = [
    {'name': 'Grocery', 'color': Colors.greenAccent, 'icon': Icons.local_grocery_store},
    {'name': 'Work', 'color': Colors.deepPurple, 'icon': Icons.work},
    {'name': 'Sport', 'color': Colors.cyanAccent, 'icon': Icons.fitness_center},
    {'name': 'Home', 'color': Colors.lightBlue, 'icon': Icons.home},
    {'name': 'University', 'color': Colors.blueAccent, 'icon': Icons.school},
    {'name': 'Social', 'color': Colors.pinkAccent, 'icon': Icons.campaign},
    {'name': 'Music', 'color': Colors.purpleAccent, 'icon': Icons.music_note},
    {'name': 'Health', 'color': Colors.lightGreenAccent, 'icon': Icons.favorite},
    {'name': 'Movie', 'color': Colors.lightBlueAccent, 'icon': Icons.movie},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
                  (route) => false,
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                "Title",
                style: TextStyle(color: Colors.white, fontSize: 20,fontWeight: FontWeight.w400),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Enter Task Title",
                hintStyle: const TextStyle(color: Colors.white54),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white24),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Task Date Picker
            GestureDetector(
              onTap: _selectDate,
              child: Row(
                children: [
                  const Icon(Icons.access_time, color: Colors.white54),
                  const SizedBox(width: 10),
                  const Text("Task Date :", style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w400)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color:  Colors.white54,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      "${selectedDate.day} - ${_monthName(selectedDate.month)} - ${selectedDate.year}",
                      style: const TextStyle(color: Colors.white70),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 30),


            GestureDetector(
              onTap: _selectCategory,
              child: Row(
                children: [
                  const Icon(Icons.category, color: Colors.white54),
                  const SizedBox(width: 10),
                  const Text("Task Category :", style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w400)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color:  Colors.white54,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      selectedCategory,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                const Icon(Icons.flag, color: Colors.white54),
                const SizedBox(width: 10),
                const Text(
                  "Task Priority :",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedPriority,
                      dropdownColor: Colors.grey[900],
                      borderRadius: BorderRadius.circular(5),
                      style: const TextStyle(color: Colors.white),
                      icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                      items: ['P1', 'P2', 'P3'].map((priority) {
                        return DropdownMenuItem<String>(
                          value: priority,
                          child: Text(
                            priority,
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedPriority = value!;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF8687E7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () async {
                  final title = _titleController.text.trim();
                  if (title.isEmpty || selectedCategory.isEmpty || selectedPriority.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please fill all the fields'),
                        backgroundColor: Color(0xFF8687E7),
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(seconds: 2),
                      ),
                    );
                    return;
                  }


                  final updatedTask = TaskModel(
                    id: widget.task?.id,
                    title: _titleController.text,
                    date: selectedDate,
                    category: selectedCategory,
                    priority: selectedPriority,
                    completed: widget.task?.completed ?? false);

                  if (widget.task != null) {
                    context.read<TaskBloc>().add(UpdateTaskEvent(updatedTask));
                  } else {
                    context.read<TaskBloc>().add(AddTask(updatedTask));
                  }

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                        (route) => false,
                  );
                },
                  child: Text(widget.task != null ? 'Update Task' : 'Add Task',style:TextStyle(fontSize: 16,fontWeight:FontWeight.w400,color:Colors.white)),
              ),

            ),
            const SizedBox(height: 30)
          ],
        ),
      ),
    );
  }

  void _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.deepPurpleAccent,
              onPrimary: Colors.white,
              surface: Colors.black,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  void _selectCategory() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: Color(0xFF363636),
          title: Column(
            children: const [
              Center(
                child: Text(
                  'Choose Category',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 8),
              Divider(color: Colors.white30, thickness: 1),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Grid of default categories
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 3,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  children: _defaultCategories.map((category) {
                    return GestureDetector(
                      onTap: () {
                        setState(() => selectedCategory = category['name']!);
                        Navigator.pop(context);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 49,
                            height: 49,
                            decoration: BoxDecoration(
                              color: category['color'],
                            ),
                            child: Icon(category['icon'], color: Colors.white, size: 22),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            category['name'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF8687E7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      _showAddCustomCategoryDialog();
                    },
                    child: const Text("Add Category" ,style:TextStyle(fontSize: 16,fontWeight:FontWeight.w400,color:Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  void _showAddCustomCategoryDialog() {
    TextEditingController _customController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text('Add New Category', style: TextStyle(color: Colors.white)),
          content: TextField(
            controller: _customController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Enter category name',
              hintStyle: TextStyle(color: Colors.white54),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white24),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color:Color(0xFF8687E7)),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
            ),
            TextButton(
              onPressed: () {
                final newCat = _customController.text.trim();
                if (newCat.isNotEmpty) {
                  setState(() => selectedCategory = newCat);
                  Navigator.pop(context);
                }
              },
              child: const Text('Add', style: TextStyle(color: Color(0xFF8687E7))),
            ),
          ],
        );
      },
    );
  }

  String _monthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}
