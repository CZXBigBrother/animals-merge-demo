class Animals {
  int id;
  String name;
  String coins;
  int level;
  String produce;

  // int shopNum;

  Animals({this.id, this.name, this.coins, this.level, this.produce});

  Animals.fromJson(Map<String, dynamic> json) {
    // print(json['id']);
    this.id = json['id'];
    name = json['animal_name'];
    coins = json['animal_coins'];
    level = json['animal_level'];
    produce = json['animal_produce'];
    // shopNum = json['shop_num'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['animal_name'] = this.name;
    data['animal_coins'] = this.coins;
    data['animal_level'] = this.level;
    data['animal_produce'] = this.produce;
    // data['shop_num'] = this.shopNum;
    return data;
  }
}
