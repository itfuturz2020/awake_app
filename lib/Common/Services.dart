import 'dart:convert';

import 'package:awake_app/Common/ClassList.dart';
import 'package:awake_app/Common/Constants.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

Dio dio = new Dio();

class Services {
  static Future<List> ConclaveLogin(String mobileNo) async {
    String url = API_URL + 'MemberEventLogin?Mobile_Number=$mobileNo';
    print("MemberEventLogin URL: " + url);
    try {
      //dio.options.contentType
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("MemberEventLogin Response: " + response.data.toString());
        var memberDataClass = jsonDecode(response.data);
        if (memberDataClass["ERROR_STATUS"] == false &&
            memberDataClass["Data"].length > 0) {
          print(memberDataClass["Data"]);
          list = memberDataClass["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("MemberEventLogin Error : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<List> getSpeakerDetails(String speakerId) async {
    String url = API_URL +
        'GetSpeakerDetail?type=speakerReview&speakerId=${speakerId}&eventId=1';
    print("GetSpeakerDetail URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("GetSpeakerDetail URL: " + response.data.toString());
        var visitorDataClass = jsonDecode(response.data);
        if (visitorDataClass["ERROR_STATUS"] == false &&
            visitorDataClass["Data"].length > 0) {
          list = visitorDataClass["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("GetSpeakerDetail URL : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<SaveDataClass> sendSpeakerReview(
      speakerId, String feedback, int rating, String memberId) async {
    String url = API_URL +
        'AddSpeakerReview?type=speakerReviewData&speakerId=${speakerId}&Feedback=${feedback}&Rating=${rating}&MemberId=${memberId}';
    print("AddSpeakerReview url : " + url);
    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        SaveDataClass saveData = new SaveDataClass(
            MESSAGE: 'No Data',
            ERROR_STATUS: true,
            RECORDS: false,
            ORIGINAL_ERROR: '');

        print("AddSpeakerReview Response: " + response.data.toString());
        var AddOneToOne = jsonDecode(response.data);

        saveData.MESSAGE = AddOneToOne["MESSAGE"];
        saveData.ORIGINAL_ERROR = AddOneToOne["ORIGINAL_ERROR"];
        saveData.ERROR_STATUS = AddOneToOne["ERROR_STATUS"];
        saveData.RECORDS = AddOneToOne["RECORDS"];

        return saveData;
      } else {
        print("Error ");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error  ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<SaveDataClass> sendVisitorData(
      String id,
      String memberName,
      String memberMobile,
      String memberCompany,
      String memberCategory,
      String memberEmail,
      String type,
      String BarcodeMobileNo) async {
    DateTime now = DateTime.now();
    String date = DateFormat('yyyy-MM-dd').format(now);
    String time = DateFormat('H:m:s').format(now);

    print("Name: ${memberName}");
    print("Mobile: ${memberMobile}");
    print("Comapny: ${memberCompany}");
    print("Category: ${memberCategory}");
    print("Email: ${memberEmail}");
    print("Date: ${date}");
    print("Time: ${time}");
    //Date and Time
    String url = API_URL +
        'StallVistedNew?Id=${id}&Name=${memberName}&Mobile=${memberMobile}&Company=${memberCompany}&Category=${memberCategory}&Email=${memberEmail}&Date=${date}&Time=${time}&Type=${type}&barcodeMobileNo=${BarcodeMobileNo}';
    print("InsertEventTrainingAttendance url : " + url);
    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        SaveDataClass saveData = new SaveDataClass(
            MESSAGE: 'No Data',
            ERROR_STATUS: true,
            RECORDS: false,
            ORIGINAL_ERROR: '');

        print(" Response: " + response.data.toString());
        var AddOneToOne = jsonDecode(response.data);

        saveData.MESSAGE = AddOneToOne["MESSAGE"];
        saveData.ORIGINAL_ERROR = AddOneToOne["ORIGINAL_ERROR"];
        saveData.ERROR_STATUS = AddOneToOne["ERROR_STATUS"];
        saveData.RECORDS = AddOneToOne["RECORDS"];

        return saveData;
      } else {
        print("Error ");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error  ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<String> getViewCardId(String memberMobile) async {
    String url = API_URL +
        'CheckDigitalCardMember?type=digitalcard&mobile=${memberMobile}';
    print("CheckDigitalCardMember URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        String responceData;
        print("CheckDigitalCardMember URL: " + response.data.toString());
        var viewDataCardClass = jsonDecode(response.data);
        if (viewDataCardClass["ERROR_STATUS"] == false &&
            viewDataCardClass["Data"].length > 0) {
          responceData = viewDataCardClass["Data"];
        } else {
          responceData = "";
        }
        return responceData;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("CheckDigitalCardMember URL : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<List> GetCategoryDataById(
      String categoryId, String memberId) async {
    String url = API_URL +
        'GetMemberListByCategoryId?categoryId=$categoryId&memberId=$memberId';
    print("GetMemberListByCategoryId URL: " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        List list = [];
        print(
            "GetMemberListByCategoryId Response: " + response.data.toString());
        var chapterData = jsonDecode(response.data);
        if (chapterData["ERROR_STATUS"] == false &&
            chapterData["Data"].length > 0) {
          list = chapterData["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("GetMemberListByCategoryId Error : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<List> GetSubCategoryData(String categoryId) async {
    String url =
        API_URL + 'GetSubCategoryByConclaveCategoryId?categoryId=$categoryId';
    print("GetSubCategoryByConclaveCategoryId URL: " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        List list = [];
        print("GetSubCategoryByConclaveCategoryId Response: " +
            response.data.toString());
        var chapterData = jsonDecode(response.data);
        if (chapterData["ERROR_STATUS"] == false &&
            chapterData["Data"].length > 0) {
          list = chapterData["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("GetSubCategoryByConclaveCategoryId Error : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<SaveDataClass> AddOneTwoOneRequest(String senderId,
      String receiverId, String MeetingType, String ZoomLink) async {
    String url = API_URL +
        'AddOneTwoOneRequest?SenderId=$senderId&ReceiverId=$receiverId&MeetingType=$MeetingType&ZoomLink=$ZoomLink';
    print("AddOneTwoOneRequest URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        SaveDataClass saveData = new SaveDataClass(
            MESSAGE: 'No Data',
            ERROR_STATUS: false,
            RECORDS: false,
            ORIGINAL_ERROR: "");
        print("AddOneTwoOneRequest Response: " + response.data.toString());
        var memberDataClass = jsonDecode(response.data);
        saveData.MESSAGE = memberDataClass["MESSAGE"];
        saveData.ORIGINAL_ERROR = memberDataClass["ORIGINAL_ERROR"];
        saveData.ERROR_STATUS = memberDataClass["ERROR_STATUS"];
        saveData.RECORDS = memberDataClass["RECORDS"];

        return saveData;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("AddOneTwoOneRequest Error : " + e.toString());
      throw Exception(e);
    }
  }

  static Future<SaveDataClass> updateOneTwoOneStatus(
      String Id, String Status, String type) async {
    String url =
        API_URL + 'UpdateOneTwoOneStatus?Status=$Status&Id=$Id&Type=$type';
    print("UpdateOneTwoOneStatus URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        SaveDataClass saveData = new SaveDataClass(
            MESSAGE: 'No Data',
            ERROR_STATUS: false,
            RECORDS: false,
            ORIGINAL_ERROR: "");
        print("UpdateOneTwoOneStatus Response: " + response.data.toString());
        var memberDataClass = jsonDecode(response.data);
        saveData.MESSAGE = memberDataClass["MESSAGE"];
        saveData.ORIGINAL_ERROR = memberDataClass["ORIGINAL_ERROR"];
        saveData.ERROR_STATUS = memberDataClass["ERROR_STATUS"];
        saveData.RECORDS = memberDataClass["RECORDS"];

        return saveData;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("UpdateOneTwoOneStatus Error : " + e.toString());
      throw Exception(e);
    }
  }

  static Future<List> GetCategoryData() async {
    String url = API_URL + 'GetConclaveCategory';
    print("GetConclaveCategory URL: " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        List list = [];
        print("GetConclaveCategory Response: " + response.data.toString());
        var chapterData = jsonDecode(response.data);
        if (chapterData["ERROR_STATUS"] == false &&
            chapterData["Data"].length > 0) {
          list = chapterData["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("GetConclaveCategory Error : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<List> getEventDetails(String eventId) async {
    String url = API_URL + 'GetEventDetail?type=eventdetail&eventId=${eventId}';
    print("GetEventDetail URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("GetEventDetail URL: " + response.data.toString());
        var visitorDataClass = jsonDecode(response.data);
        if (visitorDataClass["ERROR_STATUS"] == false &&
            visitorDataClass["Data"].length > 0) {
          list = visitorDataClass["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("GetEventDetail URL : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<List> getSpeakerList() async {
    String url = API_URL + 'GetSpeaker?type=speaker';
    print("GetSpeaker URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("GetSpeaker URL: " + response.data.toString());
        var speakersData = jsonDecode(response.data);
        if (speakersData["ERROR_STATUS"] == false &&
            speakersData["Data"] != null) {
          list = speakersData["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("GetSpeaker Error : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<List> getStallList() async {
    String url = API_URL + 'GetEventStallList';
    print("GetEventStallList URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("GetEventStallList URL: " + response.data.toString());
        var visitorDataClass = jsonDecode(response.data);
        if (visitorDataClass["ERROR_STATUS"] == false &&
            visitorDataClass["Data"].length > 0) {
          list = visitorDataClass["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("GetEventStallList URL : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<SaveDataClass> GetStallDataCheckByMobile(String mobile) async {
    String url = API_URL + 'GetStallDataCheckByMobile?Mobile=${mobile}';
    print("GetStallDataCheckByMobile URL: " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        SaveDataClass saveData = new SaveDataClass(
            MESSAGE: 'No Data',
            ERROR_STATUS: true,
            RECORDS: false,
            ORIGINAL_ERROR: '',
            Data: '');
        print(
            "GetStallDataCheckByMobile Response: " + response.data.toString());
        var memberDataClass = jsonDecode(response.data);

        saveData.MESSAGE = memberDataClass["MESSAGE"];
        saveData.ORIGINAL_ERROR = memberDataClass["ORIGINAL_ERROR"];
        saveData.ERROR_STATUS = memberDataClass["ERROR_STATUS"];
        saveData.RECORDS = memberDataClass["RECORDS"];
        saveData.Data = memberDataClass["Data"].toString();

        return saveData;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
      /*if (response.statusCode == 200) {
        bool list;
        print("GetStallDataCheckByMobile URL: " + response.data.toString());
        var stallCheckByMobile = jsonDecode(response.data);
        if (stallCheckByMobile["ERROR_STATUS"] == false &&
            stallCheckByMobile["Data"].length > 0) {
          list = stallCheckByMobile["Data"];
        } else {
          list = false;
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }*/
    } catch (e) {
      print("GetStallDataCheckByMobile URL : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<List> getConclavePartner() async {
    String url = API_URL + 'GetBarterPartner';
    print("GetBarterPartner    URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("GetBarterPartner    URL: " + response.data.toString());
        var offerDataClass = jsonDecode(response.data);
        if (offerDataClass["ERROR_STATUS"] == false &&
            offerDataClass["Data"].length > 0) {
          list = offerDataClass["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("GetBarterPartner URL : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<List> getConclaveCommittee() async {
    String url = API_URL + 'GetCommittee';
    print("GetCommittee  URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("GetCommittee  URL: " + response.data.toString());
        var offerDataClass = jsonDecode(response.data);
        if (offerDataClass["ERROR_STATUS"] == false &&
            offerDataClass["Data"].length > 0) {
          list = offerDataClass["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("GetCommittee  URL : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<List> getCorporateEmpanellmentList() async {
    String url = API_URL + 'GetCorporateDetails';
    print("GetCorporateDetails URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("GetCorporateDetails Response: " + response.data.toString());
        var data = jsonDecode(response.data);
        if (data["ERROR_STATUS"] == false) {
          list = data["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("GetCorporateDetails Error : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<List> getStallVisitor(String memberMobile) async {
    String url = API_URL + 'GetStall?Mobile=$memberMobile';
    print("GetStall URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("GetStall URL: " + response.data.toString());
        var visitorDataClass = jsonDecode(response.data);
        if (visitorDataClass["ERROR_STATUS"] == false &&
            visitorDataClass["Data"].length > 0) {
          list.add(visitorDataClass["Data"]["vstall"]);
          list.add(visitorDataClass["Data"]["vvisitor"]);
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("GetStall URL : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<List> GetChapterData() async {
    String url = API_URL + 'ViewChapter?type=chapter';
    print("GetChapterData URL: " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        List list = [];
        print("GetChapterData Response: " + response.data.toString());
        var chapterData = jsonDecode(response.data);
        if (chapterData["ERROR_STATUS"] == false &&
            chapterData["Data"].length > 0) {
          list = chapterData["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("GetChapterData Error : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<List<ChapterClass>> GetLucknowChapter() async {
    String url = API_URL + 'ViewChapter?type=chapter';
    print("GetChapter URL: " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        List<ChapterClass> chapter = [];
        print("GetChapter Response" + response.data);

        final jsonResponse = json.decode(response.data);
        ChapterClassData chapterData =
            new ChapterClassData.fromJson(jsonResponse);

        chapter = chapterData.Data;

        return chapter;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("GetChapter Error : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<List> SearchMember(String search) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String MemberId = prefs.getString(Session.MemberId);
    String url = API_URL +
        'ViewSearchDirectory?type=searchdirectory&search=$search&memberId=$MemberId';
    print("SearchMember URL: " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        List list = [];
        print("SearchMember Response: " + response.data.toString());
        var searchData = jsonDecode(response.data);
        if (searchData["ERROR_STATUS"] == false) {
          list = searchData["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("SearchMember Error : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<List> getConclaveFoodStall() async {
    String url = API_URL + 'GetFoodStall';
    print("GetFoodStall URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("GetFoodStall URL: " + response.data.toString());
        var offerDataClass = jsonDecode(response.data);
        if (offerDataClass["ERROR_STATUS"] == false &&
            offerDataClass["Data"].length > 0) {
          list = offerDataClass["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("GetFoodStall URL : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<List> GetSendOneTowOneData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String MemberId = prefs.getString(Session.MemberId);
    String url = API_URL + 'GetOneTwoOneRequestSend?senderId=$MemberId';
    print("GetOneTwoOneRequestSend URL: " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        List list = [];
        print("GetOneTwoOneRequestSend Response: " + response.data.toString());
        var chapterData = jsonDecode(response.data);
        if (chapterData["ERROR_STATUS"] == false &&
            chapterData["Data"].length > 0) {
          list = chapterData["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("GetOneTwoOneRequestSend Error : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<List> GetReceivedOneTowOneData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String MemberId = prefs.getString(Session.MemberId);
    String url = API_URL + 'GetOneTwoOneRequestRecevied?ReceiverId=$MemberId';
    print("GetOneTwoOneRequestRecevied URL: " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        List list = [];
        print("GetOneTwoOneRequestRecevied Response: " +
            response.data.toString());
        var chapterData = jsonDecode(response.data);
        if (chapterData["ERROR_STATUS"] == false &&
            chapterData["Data"].length > 0) {
          list = chapterData["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("GetOneTwoOneRequestRecevied Error : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<SaveDataClass> ConclaveCodeVerification(String MembrId) async {
    String url = API_URL + 'MemberVerification?MemberId=$MembrId';
    print("UpdateVerificationStatus URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        SaveDataClass saveData = new SaveDataClass(
            MESSAGE: 'No Data',
            ERROR_STATUS: false,
            RECORDS: false,
            ORIGINAL_ERROR: "");
        print("UpdateVerificationStatus Response: " + response.data.toString());
        var memberDataClass = jsonDecode(response.data);
        saveData.MESSAGE = memberDataClass["MESSAGE"];
        saveData.ORIGINAL_ERROR = memberDataClass["ORIGINAL_ERROR"];
        saveData.ERROR_STATUS = memberDataClass["ERROR_STATUS"];
        saveData.RECORDS = memberDataClass["RECORDS"];

        return saveData;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("UpdateVerificationStatus Check Login Error : " + e.toString());
      throw Exception(e);
    }
  }

  static Future<SaveDataClass> SendOtp(String mobileno, String code) async {
    String url = API_URL + 'SendOtp?Mobileno=$mobileno&Code=$code';
    print("Conclave SendOtp URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        SaveDataClass saveData = new SaveDataClass(
            MESSAGE: 'No Data',
            ERROR_STATUS: false,
            RECORDS: false,
            ORIGINAL_ERROR: "");
        print("Conclave SendOtp Response: " + response.data.toString());
        var memberDataClass = jsonDecode(response.data);
        saveData.MESSAGE = memberDataClass["MESSAGE"];
        saveData.ORIGINAL_ERROR = memberDataClass["ORIGINAL_ERROR"];
        saveData.ERROR_STATUS = memberDataClass["ERROR_STATUS"];
        saveData.RECORDS = memberDataClass["RECORDS"];

        return saveData;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("Conclave SendOtp Error : " + e.toString());
      throw Exception(e);
    }
  }

  static Future<List<categoryClass>> GetCategory() async {
    String url = API_URL + 'GetConclaveCategory';
    print("GetConclaveCategory URL: " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        List<categoryClass> category = [];
        print("GetConclaveCategory Response" + response.data);

        final jsonResponse = json.decode(response.data);
        categoryClassData categoryData =
            new categoryClassData.fromJson(jsonResponse);

        category = categoryData.Data;

        return category;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("GetConclaveCategory Error : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<SaveDataClass> updateConclaveUserPhoto(data) async {
    String url = API_URL + 'UpdateMemberPhoto';
    print("User Profile URL: " + url);
    try {
      final response = await http.post(url, body: data);

      if (response.statusCode == 200) {
        SaveDataClass saveData = new SaveDataClass(
            MESSAGE: 'No Data',
            ERROR_STATUS: true,
            RECORDS: false,
            ORIGINAL_ERROR: '');
        print("AddAsk Response: " + response.body);
        var memberDataClass = jsonDecode(response.body);

        saveData.MESSAGE = memberDataClass["MESSAGE"];
        saveData.ORIGINAL_ERROR = memberDataClass["ORIGINAL_ERROR"];
        saveData.ERROR_STATUS = memberDataClass["ERROR_STATUS"];
        saveData.RECORDS = memberDataClass["RECORDS"];
        saveData.Data = memberDataClass["Data"];
        print("save: ${saveData}");
        return saveData;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("Check User Profile Error : " + e.toString());
      throw Exception(e);
    }
    /*String url = API_URL + 'UpdateMemberPhoto';
    print("UpdateMemberPhoto URL: " + url);
    try {
      final response = await http.post(url, body: data);

      if (response.statusCode == 200) {
        SaveDataClass saveData = new SaveDataClass(
            MESSAGE: 'No Data',
            ERROR_STATUS: true,
            RECORDS: false,
            ORIGINAL_ERROR: '');
        print("UpdateMemberPhoto Response: " + response.body);
        var memberDataClass = jsonDecode(response.body);

        saveData.MESSAGE = memberDataClass["MESSAGE"];
        saveData.ORIGINAL_ERROR = memberDataClass["ORIGINAL_ERROR"];
        saveData.ERROR_STATUS = memberDataClass["ERROR_STATUS"];
        saveData.RECORDS = memberDataClass["RECORDS"];
        saveData.Data = memberDataClass["Data"];

        return saveData;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("Check User Profile Error : " + e.toString());
      throw Exception(e);
    }*/
  }

  static Future<SaveDataClass> updateConclaveAdvertismentPhoto(data) async {
    String url = API_URL + 'UpdateAdvertisementPhoto';
    print("UpdateAdvertisementPhoto URL: " + url);
    try {
      final response = await http.post(url, body: data);

      if (response.statusCode == 200) {
        SaveDataClass saveData = new SaveDataClass(
            MESSAGE: 'No Data',
            ERROR_STATUS: true,
            RECORDS: false,
            ORIGINAL_ERROR: '');
        print("AddAsk Response: " + response.body);
        var memberDataClass = jsonDecode(response.body);

        saveData.MESSAGE = memberDataClass["MESSAGE"];
        saveData.ORIGINAL_ERROR = memberDataClass["ORIGINAL_ERROR"];
        saveData.ERROR_STATUS = memberDataClass["ERROR_STATUS"];
        saveData.RECORDS = memberDataClass["RECORDS"];
        saveData.Data = memberDataClass["Data"];

        return saveData;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("UpdateAdvertisementPhoto Error : " + e.toString());
      throw Exception(e);
    }
  }

  static Future<List> GetConclaveMemberData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String memberId = preferences.getString(Session.MemberId);
    String url = API_URL + 'GetProfileData?MemberId=$memberId';
    print("GetProfileData URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("GetProfileData Response: " + response.data.toString());
        var memberDataClass = jsonDecode(response.data);
        if (memberDataClass["ERROR_STATUS"] == false &&
            memberDataClass["Data"].length > 0) {
          list = memberDataClass["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("GetProfileData Error : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<SaveDataClass> ConclaveUpdateData(
      String Id,
      String Name,
      String MobileNo,
      String Email,
      String Type,
      String ChapterName,
      String Company,
      String BusinessCategory,
      String City,
      String Category,
      String GSTNo,
      bool IsPrivate,
      int price) async {
    String url = API_URL +
        'UpdateProfileData?MemberId=$Id&Name=$Name&Mobile=$MobileNo&Email=$Email&Type=$Type&ChapterName=$ChapterName&CompanyName=$Company&BusinessCategory=$BusinessCategory&City=$City&CategoryId=$Category&GSTNo=$GSTNo&IsPrivate=$IsPrivate&Price=$price';
    print("UpdateProfileData URL: " + url);
    try {
      //dio.options.contentType
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        SaveDataClass saveData = new SaveDataClass(
            MESSAGE: 'No Data',
            ERROR_STATUS: true,
            RECORDS: false,
            ORIGINAL_ERROR: '',
            Data: '');

        print("UpdateProfileData Response: " + response.data.toString());
        var UpdateProfileData = jsonDecode(response.data);

        saveData.MESSAGE = UpdateProfileData["MESSAGE"];
        saveData.ORIGINAL_ERROR = UpdateProfileData["ORIGINAL_ERROR"];
        saveData.ERROR_STATUS = UpdateProfileData["ERROR_STATUS"];
        saveData.RECORDS = UpdateProfileData["RECORDS"];
        saveData.Data = UpdateProfileData["Data"];

        return saveData;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("UpdateProfileData Error : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<SaveDataClass> conclaveSignUp(
      String Name,
      String MobileNo,
      String Email,
      String Type,
      String ChapterName,
      String Company,
      String City,
      String Category,
      String GST,
      String price) async {
    DateTime now = DateTime.now();
    String date = DateFormat('yyyy-MM-dd').format(now);
    String url = API_URL +
        'EventRegister?Name=$Name&Mobile=$MobileNo&Email=$Email&Type=$Type&ChapterName=$ChapterName&Company=$Company&City=$City&Category=$Category&Date=$date&GST=$GST&Payment=$price&transactionId=';
    print("EventRegister URL: " + url);
    try {
      //dio.options.contentType
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        SaveDataClass saveData = new SaveDataClass(
            MESSAGE: 'No Data',
            ERROR_STATUS: true,
            RECORDS: false,
            ORIGINAL_ERROR: '');
        print("EventRegister Response: " + response.data.toString());
        var memberDataClass = jsonDecode(response.data);

        saveData.MESSAGE = memberDataClass["MESSAGE"];
        saveData.ORIGINAL_ERROR = memberDataClass["ORIGINAL_ERROR"];
        saveData.ERROR_STATUS = memberDataClass["ERROR_STATUS"];
        saveData.RECORDS = memberDataClass["RECORDS"];

        return saveData;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("EventRegister Erorr : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<List> getConclaveSponsor() async {
    String url = API_URL + 'GetSponsorType';
    print("GetSponsorType    URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("GetSponsorType    URL: " + response.data.toString());
        var offerDataClass = jsonDecode(response.data);
        if (offerDataClass["ERROR_STATUS"] == false &&
            offerDataClass["Data"].length > 0) {
          list = offerDataClass["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("GetSponsorType URL : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<List> getConclaveFoodStallItem(String stallId) async {
    String url = API_URL + 'GetFoodMenuStallbyId?FoodStallId=$stallId';
    print("GetFoodMenuStallbyId URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("GetFoodMenuStallbyId URL: " + response.data.toString());
        var offerDataClass = jsonDecode(response.data);
        if (offerDataClass["ERROR_STATUS"] == false &&
            offerDataClass["Data"].length > 0) {
          list = offerDataClass["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("GetFoodMenuStallbyId URL : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<List> GetForumMemberList(String type) async {
    //String url = API_URL + 'ViewChapterMemberByType?type=chapter&bnitype=$type';
    String url =
        API_URL + 'GetChapterMemberByType?type=directory&bnitype=$type';
    print("GetChapterMembers URL: " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        List list = [];
        print("GetChapterMembers Response: " + response.data.toString());
        var chapterMemeberData = jsonDecode(response.data);
        if (chapterMemeberData["ERROR_STATUS"] == false) {
          list = chapterMemeberData["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("GetChapterMembers Error : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<List> getMyVisitorsList(
      String mobile, String type, String memberId) async {
    String url = API_URL +
        'GetVisitedMemberAtStallByMobileA?Mobile=$mobile&Type=$type&Id=$memberId';
    print("GetVisitedMemberAtStallByMobileA URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("GetVisitedMemberAtStallByMobileA Response: " +
            response.data.toString());
        var StallVisitorDataClass = jsonDecode(response.data);
        if (StallVisitorDataClass["ERROR_STATUS"] == false &&
            StallVisitorDataClass["Data"].length > 0) {
          list = StallVisitorDataClass["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("GetVisitedMemberAtStallByMobileA Error : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<List> GetChapterMembers(
      String chapterid, String bnitype) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String MemberId = prefs.getString(Session.MemberId);
    String url = API_URL +
        'ViewChapterdetailType?type=chapter&chapterid=$chapterid&bnitype=$bnitype&memberId=$MemberId';
    print("ViewChapterdetailType URL: " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        List list = [];
        print("ViewChapterdetailType Response: " + response.data.toString());
        var chapterMemeberData = jsonDecode(response.data);
        if (chapterMemeberData["ERROR_STATUS"] == false) {
          list = chapterMemeberData["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("ViewChapterdetailType Error : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<SaveDataClass> SaveShare(data) async {
    String url = 'http://digitalcard.co.in/DigitalCardService.asmx/AddShare';
    print("AddShare URL: " + url);
    final response = await http.post(url, body: data);
    try {
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        SaveDataClass saveDataClass = new SaveDataClass.fromJson(jsonResponse);
        return saveDataClass;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("SaveTA Error : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<SaveDataClass> ConclaveFeedback(
      String rating, String Description, String memberId) async {
    String url = API_URL +
        'SendFeedback?Rating=${rating}&Description=${Description}&MemberId=${memberId}';
    print("AddSpeakerReview url : " + url);
    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        SaveDataClass saveData = new SaveDataClass(
            MESSAGE: 'No Data',
            ERROR_STATUS: true,
            RECORDS: false,
            ORIGINAL_ERROR: '',
            Data: '');

        print("SendFeedback Response: " + response.data.toString());
        var AddOneToOne = jsonDecode(response.data);

        saveData.MESSAGE = AddOneToOne["MESSAGE"];
        saveData.ORIGINAL_ERROR = AddOneToOne["ORIGINAL_ERROR"];
        saveData.ERROR_STATUS = AddOneToOne["ERROR_STATUS"];
        saveData.RECORDS = AddOneToOne["RECORDS"];
        saveData.Data = AddOneToOne["Data"];

        return saveData;
      } else {
        print("Error ");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error  ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<List> ConclaveSearchMember(String search) async {
    String url = API_URL + 'SearchMember?SearchText=$search';
    print("SearchMember URL: " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        List list = [];
        print("SearchMember Response: " + response.data.toString());
        var searchData = jsonDecode(response.data);
        if (searchData["ERROR_STATUS"] == false) {
          list = searchData["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("SearchMember Error : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<List> GetBanners() async {
    String url = API_URL + 'GetBannerImage';
    print("GetBannerImage    URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("GetBannerImage    URL: " + response.data.toString());
        var offerDataClass = jsonDecode(response.data);
        if (offerDataClass["ERROR_STATUS"] == false &&
            offerDataClass["Data"].length > 0) {
          list = offerDataClass["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("GetBannerImage URL : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<List> GetReginalTeam() async {
    String url = API_URL + 'ViewRegionalTeam?Type=regionalTeam';
    print("ViewRegionalTeam URL: " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        List list = [];
        print("ViewRegionalTeam Response: " + response.data.toString());
        var regionalData = jsonDecode(response.data);
        if (regionalData["ERROR_STATUS"] == false &&
            regionalData["Data"].length > 0) {
          list = regionalData["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("ViewRegionalTeam Error : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<List> GetFeaturePresentation() async {
    String url = API_URL + 'ViewFeaturePresentation?Type=FeaturePresentation';
    print("ViewFeaturePresentation URL: " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        List list = [];
        print("ViewFeaturePresentation Response: " + response.data.toString());
        var regionalData = jsonDecode(response.data);
        if (regionalData["ERROR_STATUS"] == false &&
            regionalData["Data"].length > 0) {
          list = regionalData["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("ViewFeaturePresentation Error : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<List> GetSuccessStories() async {
    String url = API_URL + 'ViewMemberSuccessStories?Type=MemberSuccessStories';
    print("ViewMemberSuccessStories URL: " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        List list = [];
        print("ViewMemberSuccessStories Response: " + response.data.toString());
        var regionalData = jsonDecode(response.data);
        if (regionalData["ERROR_STATUS"] == false &&
            regionalData["Data"].length > 0) {
          list = regionalData["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("ViewMemberSuccessStories Error : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<List> GetEdDetails() async {
    String url = API_URL + 'ViewEDDetails?Type=EDDetails';
    print("ViewEDDetails URL: " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        List list = [];
        print("ViewEDDetails Response: " + response.data.toString());
        var regionalData = jsonDecode(response.data);
        if (regionalData["ERROR_STATUS"] == false &&
            regionalData["Data"].length > 0) {
          list = regionalData["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("ViewEDDetails Error : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<SaveDataClass> SaveOneTwoOneWithEd(
      String Subject, String Date, String Time) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String MemberId = prefs.getString(Session.MemberId);
    String url = API_URL +
        'Send121EDRequest?MemberId=$MemberId&Date=$Date&Time=$Time&Topic=$Subject';
    print("Send121EDRequest URL: " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        SaveDataClass saveData = new SaveDataClass(
            MESSAGE: 'No Data',
            ERROR_STATUS: true,
            RECORDS: false,
            ORIGINAL_ERROR: '',
            Data: '');

        print("Send121EDRequest Response: " + response.data.toString());
        var AddOneToOne = jsonDecode(response.data);

        saveData.MESSAGE = AddOneToOne["MESSAGE"];
        saveData.ORIGINAL_ERROR = AddOneToOne["ORIGINAL_ERROR"];
        saveData.ERROR_STATUS = AddOneToOne["ERROR_STATUS"];
        saveData.RECORDS = AddOneToOne["RECORDS"];
        saveData.Data = AddOneToOne["Data"];

        return saveData;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("Send121EDRequest Error : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<List> GetEventData(String sdate, edate) async {
    String url =
        API_URL + 'GetEventDetailByDate?fromDate=${sdate}&toDate=${edate}';
    print("GetEventDetailByDate URL: " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        List list = [];
        print("GetEventDetailByDate Response: " + response.data.toString());
        var regionalData = jsonDecode(response.data);
        if (regionalData["ERROR_STATUS"] == false &&
            regionalData["Data"].length > 0) {
          list = regionalData["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("GetEventDetailByDate Error : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<List> GetTrainings() async {
    String url = API_URL + 'ViewTraining?Type=training';
    print("ViewTraining URL: " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        List list = [];
        print("ViewTraining Response: " + response.data.toString());
        var regionalData = jsonDecode(response.data);
        if (regionalData["ERROR_STATUS"] == false &&
            regionalData["Data"].length > 0) {
          list = regionalData["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("ViewTraining Error : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<List> getOfferList() async {
    String url = API_URL + 'GetOffer';
    print("Getoffer URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("Getoffer URL: " + response.data.toString());
        var offerDataClass = jsonDecode(response.data);
        if (offerDataClass["ERROR_STATUS"] == false &&
            offerDataClass["Data"].length > 0) {
          list = offerDataClass["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("Getoffer URL : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<List> getOfferDetails(String offerId) async {
    String url = API_URL + 'GetofferDetail?Id=$offerId';
    print("getOfferDetails URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("getOfferDetails URL: " + response.data.toString());
        var offerDataClass = jsonDecode(response.data);
        if (offerDataClass["ERROR_STATUS"] == false &&
            offerDataClass["Data"].length > 0) {
          list = offerDataClass["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("getOfferDetails URL : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<List> getPackageDetails() async {
    String url = API_URL + 'Package';
    print("Package URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("Package URL: " + response.data.toString());
        var offerDataClass = jsonDecode(response.data);
        if (offerDataClass["ERROR_STATUS"] == false &&
            offerDataClass["Data"].length > 0) {
          list = offerDataClass["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("Package URL : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<SaveDataClass> addOffer(data) async {
    String url = API_URL + 'AddOffers';
    print("Addoffer URL: " + url);
    try {
      final response = await http.post(url, body: data);

      if (response.statusCode == 200) {
        SaveDataClass saveData = new SaveDataClass(
            MESSAGE: 'No Data',
            ERROR_STATUS: true,
            RECORDS: false,
            ORIGINAL_ERROR: '');
        var memberDataClass = jsonDecode(response.body);

        saveData.MESSAGE = memberDataClass["MESSAGE"];
        saveData.ORIGINAL_ERROR = memberDataClass["ORIGINAL_ERROR"];
        saveData.ERROR_STATUS = memberDataClass["ERROR_STATUS"];
        saveData.RECORDS = memberDataClass["RECORDS"];

        return saveData;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("Check Addoffer Error : " + e.toString());
      throw Exception(e);
    }
  }

  static Future<List> GetGoldCrorepatiMemebers() async {
    String url = API_URL + 'ViewAchievementData';
    print("ViewAchievementData URL: " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        List list = [];
        print("ViewAchievementData Response: " + response.data.toString());
        var regionalData = jsonDecode(response.data);
        if (regionalData["ERROR_STATUS"] == false &&
            regionalData["Data"].length > 0) {
          list = regionalData["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("ViewAchievementData Error : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<PaymentOrderIdClass> GetOrderIDForPayment(
      int amount, String receiptNo) async {
    String url = API_URL_RazorPay_Order +
        'GetBIBEvolvePaymentOrderID?amount=$amount&receiptNo=$receiptNo';
    print("GetOrderIDForPayment URL: " + url);
    final response = await http.get(url);
    try {
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        PaymentOrderIdClass paymentOrderIdClass =
            new PaymentOrderIdClass.fromJson(jsonResponse);
        print("Response " + jsonResponse.toString());

        return paymentOrderIdClass;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("GetOrderIDForPayment Erorr : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }

  static Future<SaveDataClass> GetRazorPayKey() async {
    String url = API_URL + 'GetBIBEvolveRazorPayKey';
    print("GetBIBEvolveRazorPayKey url : " + url);
    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        SaveDataClass saveData = new SaveDataClass(
            MESSAGE: 'No Data',
            ERROR_STATUS: true,
            RECORDS: false,
            ORIGINAL_ERROR: '',
            Data: '');

        print("GetBIBEvolveRazorPayKey Response: " + response.data.toString());
        var RazoPayKey = jsonDecode(response.data);

        saveData.MESSAGE = RazoPayKey["MESSAGE"];
        saveData.ORIGINAL_ERROR = RazoPayKey["ORIGINAL_ERROR"];
        saveData.ERROR_STATUS = RazoPayKey["ERROR_STATUS"];
        saveData.RECORDS = RazoPayKey["RECORDS"];
        saveData.Data = RazoPayKey["Data"];

        return saveData;
      } else {
        print("Error ");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error  ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<List> SendTokanToServer(String fcmToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String memberId = prefs.getString(Session.MemberId);

    String url =
        API_URL + 'UpdateMemberFcmToken?FcmToken=$fcmToken&Id=$memberId';
    print("UpdateMemberFcmToken: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("UpdateMemberFcmToken URL: " + response.data.toString());
        var memberDataClass = response.data;
        if (memberDataClass["IsSuccess"] == true &&
            memberDataClass["IsRecord"] == true) {
          print(memberDataClass["Data"]);
          list = memberDataClass["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception("Something went wrong");
      }
    } catch (e) {
      print("UpdateMemberFcmToken URL : " + e.toString());
      throw Exception("Something went wrong");
    }
  }

  /*static Future<List> GetVendorService() async {
    String url =
        "http://smartsociety.itfuturz.com/api/AppAPI/GetServicePackage?vendorid=66";
    print("GetServicePackage URL: " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        List list = [];
        print("GetServicePackage Response: " + response.data.toString());
        var regionalData = jsonDecode(response.data);
        if (regionalData["IsSuccess"] == true &&
            regionalData["Data"].length > 0) {
          list = regionalData["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("GetServicePackage Error : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }*/

  static Future<List> GetVendorService() async {
    String url =
        "http://smartsociety.itfuturz.com/api/AppAPI/GetServicePackage?vendorid=66";
    print("Login URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("Login Response: " + response.data.toString());
        var responseData = response.data;
        if (responseData["IsSuccess"] == true) {
          list = responseData["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception("Something Went Wrong");
      }
    } catch (e) {
      print("Login Erorr : " + e.toString());
      throw Exception(e);
    }
  }

  static Future<List> GetFeaturedMember(String MemberId) async {
    String url = API_URL + 'GetFeaturePresentationMember?MemberId=$MemberId';
    print("ViewMemberSuccessStories URL: " + url);
    try {
      Response response = await dio.get(url);
      if (response.statusCode == 200) {
        List list = [];
        print("ViewMemberSuccessStories Response: " + response.data.toString());
        var regionalData = jsonDecode(response.data);
        if (regionalData["ERROR_STATUS"] == false &&
            regionalData["Data"].length > 0) {
          list = regionalData["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception(MESSAGES.INTERNET_ERROR);
      }
    } catch (e) {
      print("ViewMemberSuccessStories Error : " + e.toString());
      throw Exception(MESSAGES.INTERNET_ERROR);
    }
  }
}
