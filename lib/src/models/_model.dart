///
///
abstract class Model {
  ///
  ///
  final int id;

  Model(this.id);

  static resolveInt(data) {
    if (data == null) {
      return 0;
    }
    try {
      return int.parse(data.toString());
    } catch (ex) {
      return 0;
    }
  }
}
