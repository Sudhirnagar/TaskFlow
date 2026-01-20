// lib/features/tasks/data/datasources/task_remote_datasource.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/task_model.dart';

// Interface defining the contract for remote data operations using Firestore
abstract class TaskRemoteDataSource {
  Future<List<TaskModel>> getTasks(String userId);
  Future<TaskModel> createTask(TaskModel task);
  Future<TaskModel> updateTask(TaskModel task);
  Future<void> deleteTask(String taskId);
  Stream<List<TaskModel>> watchTasks(String userId);
}

// Implementation of the remote data source using Cloud Firestore
class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final FirebaseFirestore firestore;

  TaskRemoteDataSourceImpl({required this.firestore});

  // Fetches a one-time list of tasks for a specific user, ordered by due date
  @override
  Future<List<TaskModel>> getTasks(String userId) async {
    try {
      final querySnapshot = await firestore
          .collection('tasks')
          .where('userId', isEqualTo: userId)
          .orderBy('dueDate', descending: false)
          .get();

      return querySnapshot.docs
          .map((doc) => TaskModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw ServerException('Failed to fetch tasks');
    }
  }

  // Adds a new task document to Firestore and returns the created model
  @override
  Future<TaskModel> createTask(TaskModel task) async {
    try {
      final docRef = await firestore.collection('tasks').add(task.toFirestore());
      final doc = await docRef.get();
      return TaskModel.fromFirestore(doc);
    } catch (e) {
      throw ServerException('Failed to create task');
    }
  }

  // Updates an existing task document and retrieves the latest data
  @override
  Future<TaskModel> updateTask(TaskModel task) async {
    try {
      await firestore
          .collection('tasks')
          .doc(task.id)
          .update(task.toFirestore());
      
      final doc = await firestore.collection('tasks').doc(task.id).get();
      return TaskModel.fromFirestore(doc);
    } catch (e) {
      throw ServerException('Failed to update task');
    }
  }

  // Permanently removes a task document from Firestore based on its ID
  @override
  Future<void> deleteTask(String taskId) async {
    try {
      await firestore.collection('tasks').doc(taskId).delete();
    } catch (e) {
      throw ServerException('Failed to delete task');
    }
  }

  // Provides a real-time stream of task updates for the specified user
  @override
  Stream<List<TaskModel>> watchTasks(String userId) {
    return firestore
        .collection('tasks')
        .where('userId', isEqualTo: userId)
        .orderBy('dueDate', descending: false)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => TaskModel.fromFirestore(doc)).toList());
  }
}