import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/common/common.dart';
import 'package:twitter_clone/features/search/controller/search_controller.dart';
import 'package:twitter_clone/features/search/widgets/search_tile.dart';
import 'package:twitter_clone/theme/theme.dart';

class SearchView extends ConsumerStatefulWidget {
  const SearchView({super.key});

  @override
  ConsumerState<SearchView> createState() {
    return _SearchViewState();
  }
}

class _SearchViewState extends ConsumerState<SearchView> {
  final _searchController = TextEditingController();
  final appBarTextFieldBorder = OutlineInputBorder(
    borderSide: const BorderSide(width: 0),
    borderRadius: BorderRadius.circular(50),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          height: 50,
          child: TextField(
            controller: _searchController,
            onChanged: (value) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'Search',
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              fillColor: Pallete.searchBarColor,
              filled: true,
              border: appBarTextFieldBorder,
              enabledBorder: appBarTextFieldBorder,
              focusedBorder: appBarTextFieldBorder,
            ),
          ),
        ),
      ),
      body: ref.watch(searchUserProvider(_searchController.text)).when(
            data: (users) {
              if (users.isEmpty) {
                return const Center(
                  child: Text('No users has been found'),
                );
              }
              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (ctx, index) {
                  return SearchTile(user: users[index]);
                },
              );
            },
            error: (error, stackTrace) {
              return ErrorText(text: error.toString());
            },
            loading: () => const Loader(),
          ),
    );
  }
}
