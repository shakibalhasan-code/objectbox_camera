import 'package:crud_objtbx/modules/core/models/video_entity.dart';
import 'package:crud_objtbx/objectbox.g.dart';
import 'package:objectbox/objectbox.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ObjectBoxHelper {
  late final Store _store;

  late final Box<VideoEntity> videoBox;

  ObjectBoxHelper._create(this._store) {
    videoBox = _store.box<VideoEntity>();
  }

  static Future<ObjectBoxHelper> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final store = await openStore(
      directory: p.join(docsDir.path, "video_recordings_db"),
    );
    return ObjectBoxHelper._create(store);
  }

  int put<T>(T object) {
    return _store.box<T>().put(object);
  }

  T? get<T>(int id) {
    return _store.box<T>().get(id);
  }

  List<T> getAll<T>() {
    return _store.box<T>().getAll();
  }

  bool remove<T>(int id) {
    return _store.box<T>().remove(id);
  }

  Box<T> getBox<T>() {
    return _store.box<T>();
  }

  Stream<List<T>> getStream<T>() {
    return _store
        .box<T>()
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  /// Closes the store.
  void close() {
    _store.close();
  }
}
