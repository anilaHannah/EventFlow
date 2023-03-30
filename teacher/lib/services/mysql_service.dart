import 'dart:async';

import 'package:mysql1/mysql1.dart';

import '../models/event.dart';
import '../models/student.dart';
import '../models/teacher.dart';
import '../models/interest.dart';

class MySqlService {

  Future<MySqlConnection> getConnection() async {
    var settings = ConnectionSettings(
      host: 'db4free.net',
      port: 3306,
      user: 'eventflowstudent',
      password: 'eventflow',
      db: 'eventflow',
    );
    return await MySqlConnection.connect(settings);
  }

  Future<int> addTeacher(Teacher teacherData, Interest interestData) async {
    var con = await getConnection();
    var result = await con.query(
        'insert into interest (intid,cs,law,statistics,commerce,humanities,science) values (?, ?, ?, ?, ?, ?, ?)',
        [
          interestData.intId,
          interestData.cs,
          interestData.law,
          interestData.statistics,
          interestData.commerce,
          interestData.humanities,
          interestData.science
        ]);
    if (result.affectedRows == 1) {
      result = await con.query(
          'insert into teacher (tid,intid,name,email,phone,dept) values (?,?,?,?,?,?)',
          [
            teacherData.tid,
            teacherData.intId,
            teacherData.name,
            teacherData.email,
            teacherData.phone,
            teacherData.department,
          ]);
    }
    else{
      print("Some error");
    }
    con.close();
    return result.affectedRows!;
  }

  Future<Teacher> getTeacher(String email) async {
    var con = await getConnection();
    Results result =
        await con.query('select * from teacher where email = ?', [email]);
    List<Teacher> t = [];
    for (var row in result) {
      Teacher stud = Teacher(
        tid: row['tid'],
        intId: row['intid'],
        name: row['name'],
        phone: row['phone'],
        email: row['email'],
        department: row['dept'],
      );
      t.add(stud);
    }
    con.close();
    return t[0];
  }

Future<int> addStudent(Student studentData, Interest interestData) async {
  var con = await getConnection();
  var result = await con.query(
      'insert into interest (intid,cs,law,statistics,commerce,humanities,science) values (?, ?, ?, ?, ?, ?, ?)',
      [
        interestData.intId,
        interestData.cs,
        interestData.law,
        interestData.statistics,
        interestData.commerce,
        interestData.humanities,
        interestData.science
      ]);
  if (result.affectedRows == 1) {
    result = await con.query(
        'insert into student (sid,intid,name,email,phone,dept,course) values (?,?,?,?,?,?,?)',
        [
          studentData.sid,
          studentData.intId,
          studentData.name,
          studentData.email,
          studentData.phone,
          studentData.department,
          studentData.course
        ]);
  }
  con.close();
  return result.affectedRows!;
}

Future<Student> getStudent(String email) async {
  var con = await getConnection();
  Results result =
  await con.query('select * from student where email = ?', [email]);
  con.close();
  return Student.fromJson(result.elementAt(0).fields);
}

Future<Interest> getInterest(String intid) async {
  var con = await getConnection();
  Results result =
  await con.query('select * from interest where intid = ?', [intid]);
  con.close();
  return Interest.fromJson(result.elementAt(0).fields);
}

Future<List<Event>> getAllEvents() async {
  List<Event> events = [];
  var con = await getConnection();
  Results result = await con.query('select * from event');
  con.close();
  for (var r in result) {
    events.add(Event.fromJson(r.fields));
  }
  return events;
}

Future<List<Event>> getOngoingEvents() async {
  List<Event> events = [];
  var con = await getConnection();
  Results result =
  await con.query('select * from event where status = "ONGOING"');
  con.close();
  for (var r in result) {
    events.add(Event.fromJson(r.fields));
  }
  return events;
}

Future<List<Event>> getPendingEvents() async {
  List<Event> events = [];
  var con = await getConnection();
  Results result =
  await con.query('select * from event where status = "PENDING"');
  con.close();
  for (var r in result) {
    events.add(Event.fromJson(r.fields));
  }
  return events;
}

Future<List<Event>> getCompletedEvents() async {
  List<Event> events = [];
  var con = await getConnection();
  Results result =
  await con.query('select * from event where status = "COMPLETED"');
  con.close();
  for (var r in result) {
    events.add(Event.fromJson(r.fields));
  }
  return events;
}

Future<Event?> isHosting(String sid) async {
  var con = await getConnection();
  Event? e;
  Results result = await con.query(
      'select * from event where sid = ? AND status <> "COMPLETED"', [sid]);
  con.close();
  if (result.isNotEmpty) {
    e = Event.fromJson(result.elementAt(0).fields);
  }
  return e;
}
  Future<int> updateTeacherIdEvent(Event event,String? tid) async {
    var con = await getConnection();
    print("1");
    var result = await con.query(
        'update event set tid=?,status="ongoing" where eid=?',
        [
          tid,
          event.eid
        ]);
    print("2");
    con.close();
    print("3");
    print(result.affectedRows);
    return result.affectedRows!;
  }
  Future<int> getApprovalsList(String tid) async{
    var con=await getConnection();
    var result= await con.query(
        'SELECT * FROM approval a JOIN event e ON a.eid = e.eid WHERE e.tid =?',
        [tid]);
    return -1;

  }
Future<int> requestEvent(Event event) async {
  var con = await getConnection();
  var result = await con.query(
      'insert into event (eid,sid,tid,name,interest,start,end,description,status) values (?, ?, ?, ?, ?, ?, ?, ?, ?)',
      [
        event.eid,
        event.sid,
        event.tid,
        event.name,
        event.interest,
        event.start,
        event.end,
        event.description,
        event.status,
      ]);
  con.close();
  return result.affectedRows!;
}
}


