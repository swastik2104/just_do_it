class Task{
  late final String name;
  late bool isDone;

  Task({required this.name,required this.isDone});
  void toggleDone(){
    isDone =! isDone;
  }
  Task.fromMap(Map map) :
        name = map['name'],
        isDone = map['isDone'];

  Map toMap(){
    return {
      'name': name,
      'isDone': isDone,
    };
  }
}