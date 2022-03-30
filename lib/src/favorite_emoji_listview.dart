import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../flutter_openim_widget.dart';

class FavoriteEmojiListView extends StatelessWidget {
  const FavoriteEmojiListView({
    Key? key,
    required this.emojiList,
    this.selectedEmojiList = const [],
    this.onAddFavoriteEmoji,
    this.onChangedSelectedStatus,
    this.enabled = false,
  }) : super(key: key);

  final List<String> emojiList;
  final List<String> selectedEmojiList;
  final Function(String url, bool selected)? onChangedSelectedStatus;
  final Function()? onAddFavoriteEmoji;
  final bool enabled;

  bool _isChecked(url) => selectedEmojiList.contains(url);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      itemCount: emojiList.length + 1,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1,
        mainAxisSpacing: 20.h,
        crossAxisSpacing: 37.w,
      ),
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return GestureDetector(
            onTap: onAddFavoriteEmoji,
            child: Center(
              child: ImageUtil.assetImage('ic_add_emoji'),
            ),
          );
        }
        var url = emojiList.elementAt(index - 1);
        return _buildItemView(url: url);
      },
    );
  }

  Widget _buildItemView({required String url}) => GestureDetector(
        onTap: enabled
            ? () => onChangedSelectedStatus?.call(url, !_isChecked(url))
            : null,
        child: Container(
          child: Stack(
            children: [
              Center(
                child: ImageUtil.lowMemoryNetworkImage(
                  url: url,
                  width: 60.w,
                  cacheWidth: 60.w.toInt(),
                  fit: BoxFit.cover,
                ),
              ),
              if (enabled)
                Positioned(
                  top: 4.h,
                  left: 4.w,
                  child: ImageUtil.assetImage(
                    _isChecked(url)
                        ? 'ic_favorite_emoji_sel'
                        : 'ic_favorite_emoji_nor',
                    width: 18.w,
                  ),
                ),
            ],
          ),
        ),
      );
}
