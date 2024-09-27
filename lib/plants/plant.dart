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
  String? image;



  PlantData({this.name,this.date,this.scienceName});

  PlantData.fromJSON(Map<dynamic,dynamic> json){
    name= json["name"];
    scienceName = json["science_name"];
    date = json["date"];
    water = json["water"];
    light = json["light"];
    difficulty = json["difficulty"];
    type = json["type"];
    image = json["image"];
  }
}