class Plant{
  String? key;
  PlantData? plantData;

  Plant({this.key,this.plantData});

}

class PlantData {
  String? name;
  String? science_name;
  String? date;
  String? image_url;


  PlantData({this.name,this.date,this.science_name, this.image_url});

  PlantData.fromJSON(Map<dynamic,dynamic> json){
    name= json["name"];
    science_name = json["science_name"];
    date = json["date"];
    image_url =json["image_url"];
  }
}