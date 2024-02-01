import 'custom_ext.dart';

extension StrExt on String {
  ImageView get toImage {
    return ImageView(name: this);
  }

  TextView get toText {
    return TextView(data: this);
  }

  LottieView get toLottie {
    return LottieView(name: this);
  }
}