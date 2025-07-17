import '../models/task_model.dart';

abstract class TaskEvent {}

class LoadTasks extends TaskEvent {}

class AddTask extends TaskEvent {
  final TaskModel task;

  AddTask(this.task);
}

class ToggleTaskCompletionEvent extends TaskEvent {
  final TaskModel task;

  ToggleTaskCompletionEvent(this.task);
}

class UpdateTaskEvent extends TaskEvent {
  final TaskModel updatedTask;
  UpdateTaskEvent(this.updatedTask);
}

class DeleteTaskEvent extends TaskEvent {
  final int id;
  DeleteTaskEvent(this.id);
}

class ClearAllTasksEvent extends TaskEvent {}

