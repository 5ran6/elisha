/*
Elisha iOS & Android App
Copyright (C) 2021 Elisha

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
 any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

import 'dart:convert';

class Translation {
  int? id;
  String? name;
  String abbreviation;
  String? downloadUrl;
  String? language;

  Translation({
    this.id,
    this.name,
    required this.abbreviation,
    this.downloadUrl,
    this.language,
  });

  Translation copyWith({
    int? id,
    String? name,
    required String abbreviation,
    String? downloadUrl,
    String? language,
  }) {
    return Translation(
      id: id ?? this.id,
      name: name ?? this.name,
      abbreviation: abbreviation,
      downloadUrl: downloadUrl ?? this.downloadUrl,
      language: language ?? this.language,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'abbreviation': abbreviation,
      'downloadUrl': downloadUrl,
      'language': language,
    };
  }

  factory Translation.fromMap(Map<String, dynamic> map) {
    return Translation(
      id: map['id'],
      name: map['translationName'],
      abbreviation: map['translationKey'],
      downloadUrl: map['downloadUrl'],
      language: map['language'] ?? "English",
    );
  }

  String toJson() => json.encode(toMap());

  factory Translation.fromJson(String source) =>
      Translation.fromMap(json.decode(source));


  @override
  String toString() {
    return 'Translation{id: $id, name: $name, abbreviation: $abbreviation, downloadUrl: $downloadUrl, language: $language}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Translation &&
        other.id == id &&
        other.name == name &&
        other.abbreviation == abbreviation &&
        other.language == language;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        abbreviation.hashCode ^
        language.hashCode;
  }
}
