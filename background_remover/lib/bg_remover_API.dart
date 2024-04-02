import 'package:http/http.dart' as http;

class Api {
  static const key = "dSKnVGvmTAAjdaAiGsEUFqWG";
  static var baseURL = Uri.parse("https://api.remove.bg/v1.0/removebg");

  static removeBG(String imgPath) async {
    var request = http.MultipartRequest('POST', baseURL);

    request.headers.addAll({"X-API-Key": key});
    request.files.add(await http.MultipartFile.fromPath("image_file", imgPath));
    final res = await request.send();

    if (res.statusCode == 200) {
      http.Response img = await http.Response.fromStream(res);
      return img.bodyBytes;
    } else {
      print("Error in fetching Data");
      return null;
    }
  }
}
