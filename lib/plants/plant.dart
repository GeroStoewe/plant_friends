class Plant{
  String? key;
  PlantData? plantData;

  Plant({this.key,this.plantData});
}

class PlantData {
  String? name;
  String? scienceName;
  String? date;
  String? imageUrl;

  PlantData({this.name,this.scienceName, this.date, this.imageUrl});

  PlantData.fromJSON(Map<dynamic,dynamic> json){
    name= json["name"];
    scienceName = json["science_name"];
    date = json["date"];
    imageUrl = json["image_url"];
  }
}
