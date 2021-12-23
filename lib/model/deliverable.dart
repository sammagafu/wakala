class Delivery {
  final String name;
  final String url;
  Delivery({this.name = "", this.url = ""});
}

List<Delivery> delivery = [
  Delivery(name: 'Food', url: "assets/images/delivery/food.png"),
  Delivery(name: 'Cooking Gas', url: "assets/images/delivery/gas.png"),
  Delivery(name: 'Grocery', url: "assets/images/delivery/grocery.png"),
  Delivery(name: 'Trucks', url: "assets/images/delivery/trucks.png"),
];
