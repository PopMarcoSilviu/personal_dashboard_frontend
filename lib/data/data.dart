class Note {

 String title;
 String msg;
 String date_added;

  Note(
      {
        required this.title,
        required this.msg,
        required this.date_added,

      });

  factory Note.fromDatabaseJson(Map<String, dynamic> data) => Note(

    title: data['title'],
    msg: data['msg'],
    date_added: data['date_added'],
  );

  Map<String, dynamic> toDatabaseJson() => {
    'title': title,
    'msg': msg,
    'date_added': date_added,
  };
}