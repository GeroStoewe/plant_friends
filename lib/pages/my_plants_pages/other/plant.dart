class Plant{
  String? key;
  PlantData? plantData;

  Plant({this.key,this.plantData});
}

class PlantData {
  String? name;
  String? scienceName;
  String? date;

  String? water;
  String? light;
  String? difficulty;
  String? type;
  String? imageUrl;
  String? userId; // to store the user information
  int? customWaterInterval;


  PlantData({this.name,this.scienceName, this.date, this.imageUrl, this.userId});

  PlantData.fromJSON(Map<dynamic,dynamic> json){
    name= json["name"];
    scienceName = json["science_name"];
    date = json["date"];

    water = json["water"];
    light = json["light"];
    difficulty = json["difficulty"];
    type = json["type"];
    imageUrl = json["image_url"];
    userId = json["user_id"];
    customWaterInterval = json["custom_water_interval"];
  }
}
