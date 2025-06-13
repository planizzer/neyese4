// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_suggestion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RecipeSuggestionImpl _$$RecipeSuggestionImplFromJson(
        Map<String, dynamic> json) =>
    _$RecipeSuggestionImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      image: json['image'] as String,
    );

Map<String, dynamic> _$$RecipeSuggestionImplToJson(
        _$RecipeSuggestionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'image': instance.image,
    };
