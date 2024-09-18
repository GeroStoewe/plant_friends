class Plant{
  String? key;
  PlantData? plantData;

  Plant({this.key,this.plantData});

}

class PlantData {
  String? name;
  String? scienceName;
  String? date;


  PlantData({this.name,this.date,this.scienceName});

  PlantData.fromJSON(Map<dynamic,dynamic> json){
    name= json["name"];
    scienceName = json["science_name"];
    date = json["date"];
  }
}