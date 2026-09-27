class JobModel {
  String title;
  String description;
  String location;
  String company;
  String type;
  String fromDate;
  String toDate;
  String id;

  JobModel({
    required this.title,
    required this.description,
    required this.location,
    required this.company,
    required this.type,
    required this.fromDate,
    required this.toDate,
    required this.id,
  });

  // factory JobModel.fromJson(Map<String, dynamic> json){
  //   return JobModel(
  //     title: json['title'],
  //     description: json['description'],
  //     location: json['location'],
  //     salary: json['salary'],
  //     company: json['company'],
  //     logo: json['logo'],
  //     type: json['type'],
  //     category: json['category'],
  //     date: json['date'],
  //     id: json['id']
  //   );
  // }
}
