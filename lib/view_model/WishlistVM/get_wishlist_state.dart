import 'package:equatable/equatable.dart';

import '../../models/WishlistM/wishlist_model.dart';

abstract class GetWishlistState extends Equatable {
  const GetWishlistState();

  @override
  List<Object> get props => [];
}

class GetWishlistInitial extends GetWishlistState {}

class GetWishlistLoading extends GetWishlistState {}

class GetWishlistLoaded extends GetWishlistState {
  final List<WishlistItem> items;

  const GetWishlistLoaded(this.items);

  @override
  List<Object> get props => [items];
}

class GetWishlistError extends GetWishlistState {
  final String message;

  const GetWishlistError(this.message);

  @override
  List<Object> get props => [message];
}