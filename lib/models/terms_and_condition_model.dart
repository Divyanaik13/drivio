class TermsAndConditionsModel{

  late final String title;
  late final String content;

  TermsAndConditionsModel({required this.title, required this.content});

factory TermsAndConditionsModel.fromJson(Map<String,dynamic> json){
  return TermsAndConditionsModel(
    title: json['title'].toString() ?? "NA",
    content: json['content'].toString() ?? 'content not available'
  );

}
}