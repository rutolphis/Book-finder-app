class Book{
  late String title;
  late String isbn13;
  late String subtitle;
  late String price;
  late String image;
  late String url;

  Book({required this.title,required this.isbn13,required this.subtitle,required this.price,required this.image ,required this.url});

  factory Book.fromJson(dynamic json) {
    return Book(
        title: json['title'] as String,
        isbn13: json['isbn13'] as String,
        subtitle: json['subtitle'] as String,
        price: json['price'] as String,
        image: json['image'] as String,
        url: json['url'] as String,
    );

  }

  static List<Book> recipesFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return Book.fromJson(data);
    }).toList();
  }

}