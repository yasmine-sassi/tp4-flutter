// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Quote _$QuoteFromJson(Map<String, dynamic> json) =>
    Quote(text: json['q'] as String, author: json['a'] as String);

Map<String, dynamic> _$QuoteToJson(Quote instance) => <String, dynamic>{
  'q': instance.text,
  'a': instance.author,
};
