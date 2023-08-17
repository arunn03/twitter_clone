import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/user_api.dart';
import 'package:twitter_clone/models/models.dart';

class SearchController extends StateNotifier<bool> {
  SearchController({required UserAPI userAPI})
      : _userAPI = userAPI,
        super(false);

  final UserAPI _userAPI;

  Future<List<UserModel>> searchUser(String name) async {
    final documents = await _userAPI.searchUserByName(name);
    final users = documents
        .map(
          (document) => UserModel.fromMap(document.data),
        )
        .toList();
    return users;
  }
}

final searchControllerProvider =
    StateNotifierProvider<SearchController, bool>((ref) {
  final userAPI = ref.watch(userAPIProvider);
  return SearchController(userAPI: userAPI);
});

final searchUserProvider = FutureProvider.family((ref, String name) {
  final searchController = ref.watch(searchControllerProvider.notifier);
  return searchController.searchUser(name);
});
