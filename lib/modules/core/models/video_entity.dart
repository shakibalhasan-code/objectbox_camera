import 'package:objectbox/objectbox.dart';

@Entity()
class VideoEntity {
  @Id()
  int id = 0;

  String title;
  String path;

  int durationInMs;

  @Property(type: PropertyType.date)
  DateTime createdAt;

  VideoEntity({
    this.id = 0,
    required this.title,
    required this.path,
    required this.durationInMs,
    required this.createdAt,
  });

  Duration get duration => Duration(milliseconds: durationInMs);
}
