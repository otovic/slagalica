import 'dart:io';
import 'package:image/image.dart' as img;

class ImageService {
  static Future<String> resizeImage(final String path) async {
    try {
      final file = File(path);
      final image = img.decodeImage(file.readAsBytesSync());
      final resizedImage = img.copyResize(image!, width: 250);
      final directory = file.parent;

      final resizedFile =
          File('${directory.path}/resized_${file.path.split('/').last}');

      await resizedFile.writeAsBytes(img.encodeJpg(resizedImage));

      return resizedFile.path;
    } catch (e) {
      throw Exception("Došlo je do greške");
    }
  }
}
