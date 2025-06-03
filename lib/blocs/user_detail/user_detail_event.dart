import 'package:equatable/equatable.dart';

abstract class UserDetailEvent extends Equatable {
  const UserDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchUserDetails extends UserDetailEvent {
  final int userId;

  const FetchUserDetails(this.userId);

  @override
  List<Object> get props => [userId];
}
