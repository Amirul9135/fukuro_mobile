class Notification {
  int id = 0;
  String title = "";
  String body = "";
  String data = "";

  getParsedData() {
    print("parse data $data");
  }

  Notification.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    title = json["title"];
    body = json["body"];
    data = json["data"];
  }
}
