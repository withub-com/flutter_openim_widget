import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const emojiFaces = <String, String>{
  '[微笑]': 'icon_001',
  '[撇嘴]': 'icon_002',
  '[色]': 'icon_003',
  '[发呆]': 'icon_004',
  '[得意]': 'icon_005',
  '[流泪]': 'icon_006',
  '[害羞]': 'icon_007',
  '[皱眉]': 'icon_008',
  '[睡]': 'icon_009',
  '[大哭]': 'icon_010',
  '[尴尬]': 'icon_011',
  '[发怒]': 'icon_012',
  '[调皮]': 'icon_013',
  '[呲牙]': 'icon_014',
  '[惊讶]': 'icon_015',
  '[难过]': 'icon_016',
  '[囧]': 'icon_017',
  '[抓狂]': 'icon_018',
  '[吐]': 'icon_019',
  '[偷笑]': 'icon_020',
  '[愉快]': 'icon_021',
  '[白眼]': 'icon_022',
  '[傲慢]': 'icon_023',
  '[困]': 'icon_024',
  '[惊恐]': 'icon_025',
  '[憨笑]': 'icon_026',
  '[悠闲]': 'icon_027',
  '[咒骂]': 'icon_028',
  '[疑问]': 'icon_029',
  '[嘘]': 'icon_030',
  '[晕]': 'icon_031',
  '[衰]': 'icon_032',
  '[骷髅]': 'icon_033',
  '[敲打]': 'icon_034',
  '[再见]': 'icon_035',
  '[擦汗]': 'icon_036',
  '[抠鼻]': 'icon_037',
  '[鼓掌]': 'icon_038',
  '[坏笑]': 'icon_039',
  '[左哼哼]': 'icon_040',
  '[鄙视]': 'icon_041',
  '[委屈]': 'icon_042',
  '[快哭了]': 'icon_043',
  '[阴险]': 'icon_044',
  '[亲亲]': 'icon_045',
  '[可怜]': 'icon_046',
  '[嘿哈]': 'icon_047',
  '[捂脸]': 'icon_048',
  '[奸笑]': 'icon_049',
  '[机智]': 'icon_050',
  '[耶]': 'icon_051',
  '[吃瓜]': 'icon_052',
  '[加油]': 'icon_053',
  '[汗]': 'icon_054',
  '[天啊]': 'icon_055',
  '[Emm]': 'icon_056',
  '[社会社会]': 'icon_057',
  '[旺财]': 'icon_058',
  '[好的]': 'icon_059',
  '[打脸]': 'icon_060',
  '[哇]': 'icon_061',
  '[嘴唇]': 'icon_062',
  '[爱心]': 'icon_063',
  '[心碎]': 'icon_064',
  '[拥抱]': 'icon_065',
  '[强]': 'icon_066',
  '[弱]': 'icon_067',
  '[握手]': 'icon_068',
  '[胜利]': 'icon_069',
  '[抱拳]': 'icon_070',
  '[勾引]': 'icon_071',
  '[拳头]': 'icon_072',
  '[OK]': 'icon_073',
  '[啤酒]': 'icon_074',
  '[咖啡]': 'icon_075',
  '[蛋糕]': 'icon_076',
  '[玫瑰]': 'icon_077',
  '[凋谢]': 'icon_078',
  '[菜刀]': 'icon_079',
  '[炸弹]': 'icon_080',
  '[便便]': 'icon_081',
  '[月亮]': 'icon_082',
  '[太阳]': 'icon_083',
  '[礼物]': 'icon_084',
  '[红包]': 'icon_085',
  '[发]': 'icon_086',
  '[福]': 'icon_087',
  '[猪头]': 'icon_088',
  '[跳跳]': 'icon_089',
  '[发抖]': 'icon_090',

};

class ChatEmojiView extends StatefulWidget {
  const ChatEmojiView({
    Key? key,
    this.onAddEmoji,
    this.onDeleteEmoji,
    this.favoriteList = const [],
    this.onAddFavorite,
    this.onSelectedFavorite,
  }) : super(key: key);
  final Function()? onDeleteEmoji;
  final Function(String emoji)? onAddEmoji;
  final List<String> favoriteList;
  final Function()? onAddFavorite;
  final Function(int index, String url)? onSelectedFavorite;

  @override
  _ChatEmojiViewState createState() => _ChatEmojiViewState();
}

class _ChatEmojiViewState extends State<ChatEmojiView> {
  var _index = 0;

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: Duration(milliseconds: 200),
      child: Container(
        // height: 190.h,
        color: Colors.white,
        child: Column(
          children: [
            Stack(
              children: [
                if (_index == 0) _buildEmojiLayout(),
                if (_index == 1) _buildFavoriteLayout(),
              ],
            ),
            _buildTabView(),
          ],
        ),
      ),
    );
  }

  Widget _buildTabView() => Container(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 9.w),
        decoration: BoxDecoration(
          border: BorderDirectional(
            top: BorderSide(
              color: const Color(0xFFEAEAEA),
              width: 1.h,
            ),
          ),
        ),
        child: Row(
          children: [
            _buildTabSelectedBgView(selected: _index == 0, index: 0),
            //_buildTabSelectedBgView(selected: _index == 1, index: 1),
            Spacer(),
            if (_index == 0) _buildFaceDelBtn(),
          ],
        ),
      );

  Widget _buildFaceDelBtn() => GestureDetector(
        onTap: widget.onDeleteEmoji,
        child: Container(
          // width: 25.w,
          // height: 25.h,
          padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 13.w),
          child: Center(
            child: ImageUtil.assetImage(
              'ic_del_face',
              width: 18.w,
              height: 16.h,
            ),
          ),
        ),
      );

  Widget _buildTabSelectedBgView({
    bool selected = false,
    int index = 0,
  }) =>
      GestureDetector(
        onTap: () {
          setState(() {
            _index = index;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 13.w),
          decoration: BoxDecoration(
            color: selected ? Color(0xFF000000).withOpacity(0.06) : null,
            borderRadius: BorderRadius.circular(6),
          ),
          child: ImageUtil.assetImage(
              index == 0
                  ? (selected ? 'ic_face_sel' : 'ic_face_nor')
                  : (selected ? 'ic_favorite_sel' : 'ic_favorite_nor'),
              width: 19,
              height: 19),
        ),
      );

  Widget _buildEmojiLayout() => Container(
        // color: Colors.white,
        height: 190.h,
        child: GridView.builder(
          padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 10.h),
          itemCount: emojiFaces.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 8,
            childAspectRatio: 1,
            mainAxisSpacing: 1.w,
            crossAxisSpacing: 10.w,
          ),
          itemBuilder: (BuildContext context, int index) {
            return Material(
              color: Colors.transparent,
              child: Ink(
                child: InkWell(
                  onTap: () =>
                      widget.onAddEmoji?.call(emojiFaces.keys.elementAt(index)),
                  child: Center(
                    child: ImageUtil.assetImage(
                      emojiFaces.values.elementAt(index),
                      width: 30.h,
                      height: 30.h,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );

  Widget _buildFavoriteLayout() => Container(
        // color: Colors.white,
        height: 190.h,
        child: GridView.builder(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          itemCount: widget.favoriteList.length + 1,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 1,
            mainAxisSpacing: 20.h,
            crossAxisSpacing: 37.w,
          ),
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return GestureDetector(
                onTap: widget.onAddFavorite,
                child: Center(
                  child: ImageUtil.assetImage('ic_add_emoji'),
                ),
              );
            }
            var url = widget.favoriteList.elementAt(index - 1);
            return GestureDetector(
              onTap: () => widget.onSelectedFavorite?.call(index - 1, url),
              child: Center(
                child: ImageUtil.lowMemoryNetworkImage(
                  url: url,
                  width: 60.w,
                  cacheWidth: 60.w.toInt(),
                ),
              ),
            );
          },
        ),
      );
}
