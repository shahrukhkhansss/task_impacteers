import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:impacteers_task/api/api_service.dart';


// Define Events
abstract class UserEvent {}

class FetchUsers extends UserEvent {
  final int page;
  FetchUsers(this.page);
}

class FetchUserDetails extends UserEvent {
  final int userId;
  FetchUserDetails(this.userId);
}

// Define States
abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final List<dynamic> users;
  UserLoaded(this.users);
}

class UserDetailLoaded extends UserState {
  final Map<String, dynamic> userDetails;
  UserDetailLoaded(this.userDetails);
}

class UserError extends UserState {
  final String error;
  UserError(this.error);
}

// BLoC Implementation
class UserBloc extends Bloc<UserEvent, UserState> {
  final ApiService apiService;

  UserBloc(this.apiService) : super(UserInitial()) {
    on<FetchUsers>((event, emit) async {
      emit(UserLoading());
      try {
        final users = await apiService.fetchUsers(event.page);
        emit(UserLoaded(users['data']));
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });

    on<FetchUserDetails>((event, emit) async {
      emit(UserLoading());
      try {
        final userDetails = await apiService.fetchUserDetails(event.userId);
        emit(UserDetailLoaded(userDetails));
      } catch (e) {
        emit(UserError(e.toString()));
      }
    });
  }
}