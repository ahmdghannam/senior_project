import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  Api.getChatReply(
      'شو اهم المهارات يلي لازم اركز عليها في السي في لهندسة الحاسوب'
  );
}

class Api {
  // static const String apiUrl = 'http://127.0.0.1:5000/search';
  static const String apiUrl = 'http://192.168.1.2:5000/search';

  static Future<String> getChatReply(String query) async {
    var url = Uri.parse(apiUrl);
    print("The query is " + query);
    var headers = {'Content-Type': 'application/json'};

    // Define the body of the request
    var body = jsonEncode({'query': query});
    print('The body is ' + body);

    try {
      // Send the POST request
      var response = await http.post(url, headers: headers, body: body);

      print("Status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        print("The json is " + json.toString());
        final reply = json['document'];
        print("The reply is " + reply);
        return reply;
      } else {
        throw Exception('Failed to load chat data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load chat data');
    }
  }
}

