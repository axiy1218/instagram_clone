import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:instagram_clone/models/post_model.dart';
import 'package:instagram_clone/models/user_model.dart';
import 'package:instagram_clone/pages/search/search_provider.dart';
import 'package:instagram_clone/services/fire/fire_src.dart';
import 'package:instagram_clone/utils/app_utils_export.dart';
import 'package:provider/provider.dart';

class SearchView extends StatefulWidget {
  static Widget get show => ChangeNotifierProvider(
        create: (_) => SearchViewProvider(),
        child: const SearchView(),
      );
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final List<UserModel> _wordsList = [
    const UserModel(
        username: 'sarvar',
        photoAvatarUrl:
            'https://static.vecteezy.com/system/resources/thumbnails/002/002/403/small/man-with-beard-avatar-character-isolated-icon-free-vector.jpg'),
    const UserModel(
        username: 'sarvar1',
        photoAvatarUrl:
            'https://static.vecteezy.com/system/resources/thumbnails/002/002/403/small/man-with-beard-avatar-character-isolated-icon-free-vector.jpg'),
    const UserModel(
        username: 'sardor',
        photoAvatarUrl:
            'https://static.vecteezy.com/system/resources/thumbnails/002/002/403/small/man-with-beard-avatar-character-isolated-icon-free-vector.jpg'),
    const UserModel(
        username: 'sarvar1',
        photoAvatarUrl:
            'https://static.vecteezy.com/system/resources/thumbnails/002/002/403/small/man-with-beard-avatar-character-isolated-icon-free-vector.jpg'),
    const UserModel(
        username: 'gitler',
        photoAvatarUrl:
            'https://static.vecteezy.com/system/resources/thumbnails/002/002/403/small/man-with-beard-avatar-character-isolated-icon-free-vector.jpg'),
    const UserModel(
        username: 'sarvar',
        photoAvatarUrl:
            'https://static.vecteezy.com/system/resources/thumbnails/002/002/403/small/man-with-beard-avatar-character-isolated-icon-free-vector.jpg'),
    const UserModel(
        username: 'sarvar',
        photoAvatarUrl:
            'https://static.vecteezy.com/system/resources/thumbnails/002/002/403/small/man-with-beard-avatar-character-isolated-icon-free-vector.jpg'),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<SearchViewProvider>(
            builder: (context, searchViewProvider, _) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0.w),
                  child: GestureDetector(
                    onTap: () {
                      if (kDebugMode) {
                        Navigator.of(context).pushNamed(AppRoutes.searchPage);
                      }
                    },
                    child: AbsorbPointer(
                      absorbing: true,
                      child: CupertinoTextField(
                        // controller: textEditingController,
                        // focusNode: focusNode,
                        // onSubmitted: (value) => onFieldSubmitted,
                        style: Theme.of(context).textTheme.displaySmall,
                        prefix: Padding(
                          padding: EdgeInsets.only(left: 11.w),
                          child: Icon(
                            CupertinoIcons.search,
                            size: 18.w,
                            color: Theme.of(context)
                                .copyWith(focusColor: const Color(0xFF8E8E93))
                                .focusColor,
                          ),
                        ),
                        placeholder: "Search",
                        placeholderStyle: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(
                                color: const Color(0xFF8E8E93),
                                fontSize: 16.sp),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.w),
                            color: Theme.of(context)
                                .cupertinoOverrideTheme!
                                .barBackgroundColor),
                      ),
                    ),
                    //? Avtocomplate widget
                    // child: Autocomplete<UserModel>(
                    //   optionsViewBuilder: (context, onSelected, options) =>
                    //       ListView.builder(
                    //           shrinkWrap: true,
                    //           itemCount: options.length,
                    //           itemBuilder: (context, index) => UserWidget(
                    //                 user: options.toList()[index],
                    //               )),
                    //   fieldViewBuilder: (context, textEditingController, focusNode,
                    //           onFieldSubmitted) =>
                    //       CupertinoTextField(
                    //     controller: textEditingController,
                    //     focusNode: focusNode,
                    //     onSubmitted: (value) => onFieldSubmitted,
                    //     style: Theme.of(context).textTheme.displaySmall,
                    //     prefix: Padding(
                    //       padding: EdgeInsets.only(left: 11.w),
                    //       child: Icon(
                    //         CupertinoIcons.search,
                    //         size: 18.w,
                    //         color: Theme.of(context)
                    //             .copyWith(focusColor: const Color(0xFF8E8E93))
                    //             .focusColor,
                    //       ),
                    //     ),
                    //     placeholder: "Search",
                    //     placeholderStyle: Theme.of(context)
                    //         .textTheme
                    //         .displaySmall!
                    //         .copyWith(
                    //             color: const Color(0xFF8E8E93), fontSize: 16.sp),
                    //     decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(10.w),
                    //         color: Theme.of(context)
                    //             .cupertinoOverrideTheme!
                    //             .barBackgroundColor),
                    //   ),

                    //   optionsBuilder: (textEditingValue) {
                    //     if (textEditingValue.text.isEmpty) {
                    //       return const Iterable<UserModel>.empty();
                    //     }
                    //     return _wordsList.where((element) =>
                    //         element.username!.contains(textEditingValue.text));
                    //   },
                    //   onSelected: (option) {
                    //     log(option.toString());
                    //   },
                    // ),
                  ),
                ),

                // final user = snapshot.docs[index].data();
                FirestoreQueryBuilder(
                    query: FireSrc.firebaseFirestore
                        .collection('posts')
                        .orderBy('datePublished', descending: true),
                    pageSize: 15,
                    builder: (context, snapshot, _) {
                      // if we reached the end of the currently obtained items, we try to
                      // obtain more item

                      return GridView.custom(
                          shrinkWrap: true,
                          primary: false,
                          gridDelegate: SliverQuiltedGridDelegate(
                            crossAxisCount: 3,
                            mainAxisSpacing: 4,
                            crossAxisSpacing: 4,
                            repeatPattern: QuiltedGridRepeatPattern.inverted,
                            pattern: [
                              const QuiltedGridTile(2, 1),
                              const QuiltedGridTile(1, 1),
                              const QuiltedGridTile(1, 1),
                              const QuiltedGridTile(1, 1),
                              const QuiltedGridTile(1, 1),
                            ],
                          ),
                          childrenDelegate: SliverChildBuilderDelegate(
                            childCount: snapshot.docs.length,
                            (context, index) {
                              if (snapshot.hasMore &&
                                  index + 1 == snapshot.docs.length) {
                                // Tell FirestoreQueryBuilder to try to obtain more items.
                                // It is safe to call this function from within the build method.
                                snapshot.fetchMore();
                              }

                              final post = PostModel.fromJson(
                                  snapshot.docs[index].data());
                              return Card(
                                child: CachedNetworkImage(
                                  imageUrl: post.imageUrl ?? '',
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, error) =>
                                      const SizedBox.shrink(),
                                  placeholder: (context, url) =>
                                      const SizedBox.shrink(),
                                ),
                              );
                            },
                          ));
                    }),
              ],
            ),
          );
        }),
      ),
    );
  }
}
