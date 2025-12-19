import 'package:equatable/equatable.dart';

abstract class GetWishlistEvent extends Equatable {
  const GetWishlistEvent();

  @override
  List<Object> get props => [];
}

class FetchWishlist extends GetWishlistEvent {
  final int userId;

  const FetchWishlist(this.userId);

  @override
  List<Object> get props => [userId];
}

