class User {
  int? id;
  String? name;
  String? qualification;
  int? phoneNumber;
  int?age;
  String? description;

  User(this.name,this.qualification,this.phoneNumber,this.age, this.description,);

  User.withId(this.id,this.name,this.qualification,this.phoneNumber,this.age, this.description,);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'name': name,
      'qualification':qualification,
     "phone": phoneNumber,
    "age":  age,
      'description': description,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  User.fromMapObject(Map<String, dynamic>map) {
    id = map['id'];
    name = map['name'];
    qualification=map['qualification'];
   phoneNumber=map ["phone"];
    age=map["age"];
    description = map['description'];
  }
}
