class Diary {
  int _id;
  String _name;
  String _catatanisi;

  Diary(this._name, this._catatanisi);

  Diary.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._name = map['name'];
    this._catatanisi = map['catatanisi'];
  }
  
  int get id => _id;
  // ignore: unnecessary_getters_setters
  String get name => _name;
  // ignore: unnecessary_getters_setters
  String get catatanisi => _catatanisi;

  // ignore: unnecessary_getters_setters
  set name(String value) {
    _name = value;
  }

  // ignore: unnecessary_getters_setters
  set catatanisi(String value) {
    _catatanisi = value;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['id'] = this._id;
    map['name'] = name;
    map['catatanisi'] = catatanisi;
    return map;
  }
}