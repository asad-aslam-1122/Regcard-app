  class Option{
    List<String>? title;
    bool? selectedItem;
    int? selectedIndex;

    Option({required this.title, this.selectedItem,this.selectedIndex});
  }

class Category{
  String? title;
  bool selected;

  Category({required this.title, required this.selected});
}

