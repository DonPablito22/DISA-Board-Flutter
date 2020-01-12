import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;

Future<PostRequest> fetchPost() async{
  final response = await http.get('http://35.184.87.160/task');

  if(response.statusCode == 200){
    return PostRequest.fromJson(json.decode(response.body));
  } else{
    throw Exception('Failed to load post request');
  }
}

Future<PostReply> sendPost(String title) async{
  return http.post('http://35.184.87.160/task', body: json.encode({"title":title}), headers:{ HttpHeaders.contentTypeHeader: 'application/json'}).then((http.Response response){
    if(response.statusCode == 201){
      return PostReply.fromJson(json.decode(response.body));
    }else{
      throw Exception('Failed to load post response');
    }
  });
}

class PostRequest {
  final int taskId;
  final String title;
  final int stateId;

  PostRequest({this.taskId, this.title, this.stateId});

  factory PostRequest.fromJson(Map<String, dynamic> json) {
    return PostRequest(
      taskId: json['taskId'],
      title: json['title'],
      stateId: json['stateId'],
    );
  }
}

class PostReply{
  final String test;

  PostReply({this.test});

  factory PostReply.fromJson(Map<String, dynamic> json) {
    return PostReply(
      test: json['status'],
    );
  }  
}