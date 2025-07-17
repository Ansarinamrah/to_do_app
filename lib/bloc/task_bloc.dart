import 'package:flutter_bloc/flutter_bloc.dart';
import '../db/db_service.dart';
import '../models/task_model.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final DatabaseHelper dbHelper;

  TaskBloc(this.dbHelper) : super(TaskInitial()) {
    on<LoadTasks>((event, emit) async {
      emit(TaskLoading());
      try {
        final tasks = await dbHelper.getAllTasks();
        emit(TaskLoaded(tasks));
      } catch (e) {
        emit(TaskError('Failed to load tasks'));
      }
    });

    on<AddTask>((event, emit) async {
      try {
        await dbHelper.insertTask(
          title: event.task.title,
          date: event.task.date.toIso8601String(),
          category: event.task.category,
          priority: event.task.priority,
        );
        final tasks = await dbHelper.getAllTasks();
        emit(TaskLoaded(tasks));
      } catch (e) {
        emit(TaskError('Failed to add task'));
      }
    });

    on<ToggleTaskCompletionEvent>((event, emit) async {
      if (state is TaskLoaded) {
        final updatedTask = TaskModel(
          id: event.task.id,
          title: event.task.title,
          date: event.task.date,
          category: event.task.category,
          priority: event.task.priority,
          completed: !event.task.completed,
        );

        await dbHelper.updateTask(updatedTask);

        final tasks = await dbHelper.getAllTasks();
        emit(TaskLoaded(tasks));
      }
    });
    on<UpdateTaskEvent>((event, emit) async {
      if (state is TaskLoaded) {
        await dbHelper.updateTask(event.updatedTask);
        final tasks = await dbHelper.getAllTasks();
        emit(TaskLoaded(tasks));
      }
    });
    on<DeleteTaskEvent>((event, emit) async {
      await dbHelper.deleteTask(event.id);
      final tasks = await dbHelper.getAllTasks();
      emit(TaskLoaded(tasks));
    });

    on<ClearAllTasksEvent>((event, emit) async {
      await dbHelper.clearAllTasks();
      emit(TaskLoaded([]));
    });

  }
}