class SaveDataClass {
  String MESSAGE;
  bool ERROR_STATUS;
  bool RECORDS;
  String ORIGINAL_ERROR;
  String Data;

  SaveDataClass(
      {this.MESSAGE,
      this.ERROR_STATUS,
      this.RECORDS,
      this.ORIGINAL_ERROR,
      this.Data});

  factory SaveDataClass.fromJson(Map<String, dynamic> json) {
    return SaveDataClass(
        MESSAGE: json['MESSAGE'] as String,
        ERROR_STATUS: json['ERROR_STATUS'] as bool,
        RECORDS: json['RECORDS'] as bool,
        ORIGINAL_ERROR: json['ORIGINAL_ERROR'] as String,
        Data: json['Data'] as String);
  }
}

class Visitorclass {
  int id;
  String name;
  String mobileNumber;
  String company;
  String category;
  String email;
  String type;

  Visitorclass(this.id, this.name, this.mobileNumber, this.company,
      this.category, this.email, this.type);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'name': name,
      'mobileNumber': mobileNumber,
      'company': company,
      'category': category,
      'email': email,
      'type': type,
    };
    return map;
  }

  Visitorclass.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    mobileNumber = map['mobileNumber'];
    company = map['company'];
    category = map['category'];
    email = map['email'];
    type = map['type'];
  }
}

class categoryClassData {
  String MESSAGE;
  bool ERROR_STATUS;
  bool RECORDS;
  String ORIGINAL_ERROR;
  List<categoryClass> Data;

  categoryClassData({
    this.MESSAGE,
    this.ERROR_STATUS,
    this.RECORDS,
    this.ORIGINAL_ERROR,
    this.Data,
  });

  factory categoryClassData.fromJson(Map<String, dynamic> json) {
    return categoryClassData(
        MESSAGE: json['MESSAGE'] as String,
        ERROR_STATUS: json['ERROR_STATUS'] as bool,
        RECORDS: json['RECORDS'] as bool,
        ORIGINAL_ERROR: json['ORIGINAL_ERROR'] as String,
        Data: json['Data']
            .map<categoryClass>((json) => categoryClass.fromJson(json))
            .toList());
  }
}

class categoryClass {
  String Id;
  String CategoryName;

  categoryClass({this.Id, this.CategoryName});

  factory categoryClass.fromJson(Map<String, dynamic> json) {
    return categoryClass(
        Id: json['Id'].toString() as String,
        CategoryName: json['CategoryName'] as String);
  }
}

class bniCategoryClassData {
  String MESSAGE;
  bool ERROR_STATUS;
  bool RECORDS;
  String ORIGINAL_ERROR;
  List<bniCategoryClass> Data;

  bniCategoryClassData({
    this.MESSAGE,
    this.ERROR_STATUS,
    this.RECORDS,
    this.ORIGINAL_ERROR,
    this.Data,
  });

  factory bniCategoryClassData.fromJson(Map<String, dynamic> json) {
    return bniCategoryClassData(
        MESSAGE: json['MESSAGE'] as String,
        ERROR_STATUS: json['ERROR_STATUS'] as bool,
        RECORDS: json['RECORDS'] as bool,
        ORIGINAL_ERROR: json['ORIGINAL_ERROR'] as String,
        Data: json['Data']
            .map<bniCategoryClass>((json) => bniCategoryClass.fromJson(json))
            .toList());
  }
}

class bniCategoryClass {
  String Id;
  String Name;

  bniCategoryClass({this.Id, this.Name});

  factory bniCategoryClass.fromJson(Map<String, dynamic> json) {
    return bniCategoryClass(
        Id: json['Id'].toString() as String, Name: json['Name'] as String);
  }
}

class MemberClassData {
  String MESSAGE;
  String ORIGINAL_ERROR;
  bool ERROR_STATUS;
  bool RECORDS;
  List<MemberClass> Data;

  MemberClassData({
    this.MESSAGE,
    this.ORIGINAL_ERROR,
    this.ERROR_STATUS,
    this.RECORDS,
    this.Data,
  });

  factory MemberClassData.fromJson(Map<String, dynamic> json) {
    return MemberClassData(
        MESSAGE: json['MESSAGE'] as String,
        ORIGINAL_ERROR: json['ORIGINAL_ERROR'] as String,
        ERROR_STATUS: json['ERROR_STATUS'] as bool,
        RECORDS: json['RECORDS'] as bool,
        Data: json['Data']
            .map<MemberClass>((json) => MemberClass.fromJson(json))
            .toList());
  }
}

class MemberClass {
  String memberId;
  String memberName;

  MemberClass({this.memberId, this.memberName});

  factory MemberClass.fromJson(Map<String, dynamic> json) {
    return MemberClass(
        memberId: json['groupcode'] as String,
        memberName: json['groupname'] as String);
  }
}

class ChapterClassData {
  String MESSAGE;
  String ORIGINAL_ERROR;
  bool ERROR_STATUS;
  bool RECORDS;
  List<ChapterClass> Data;

  ChapterClassData({
    this.MESSAGE,
    this.ORIGINAL_ERROR,
    this.ERROR_STATUS,
    this.RECORDS,
    this.Data,
  });

  factory ChapterClassData.fromJson(Map<String, dynamic> json) {
    return ChapterClassData(
        MESSAGE: json['MESSAGE'] as String,
        ORIGINAL_ERROR: json['ORIGINAL_ERROR'] as String,
        ERROR_STATUS: json['ERROR_STATUS'] as bool,
        RECORDS: json['RECORDS'] as bool,
        Data: json['Data']
            .map<ChapterClass>((json) => ChapterClass.fromJson(json))
            .toList());
  }
}

class ChapterClass {
  String chapterid;
  String name;

  ChapterClass({this.chapterid, this.name});

  factory ChapterClass.fromJson(Map<String, dynamic> json) {
    return ChapterClass(
        chapterid: json['chapterid'] as String, name: json['name'] as String);
  }
}

class PaymentOrderIdClass {
  String MESSAGE;
  String ORIGINAL_ERROR;
  bool ERROR_STATUS;
  bool RECORDS;
  String Data;

  PaymentOrderIdClass(
      {this.MESSAGE,
      this.ORIGINAL_ERROR,
      this.ERROR_STATUS,
      this.RECORDS,
      this.Data});

  factory PaymentOrderIdClass.fromJson(Map<String, dynamic> json) {
    return PaymentOrderIdClass(
        MESSAGE: json['MESSAGE'] as String,
        ORIGINAL_ERROR: json['ORIGINAL_ERROR'] as String,
        ERROR_STATUS: json['ERROR_STATUS'] as bool,
        RECORDS: json['RECORDS'] as bool,
        Data: json['Data'] as String);
  }
}
