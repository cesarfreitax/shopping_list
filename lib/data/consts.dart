class Consts {
  final getItemsUrl = Uri.https('shopping-list-cfdev-default-rtdb.firebaseio.com',
      'shopping-list.json');

  Uri getDeleteByIdUrl(String id) {
    return Uri.https('shopping-list-cfdev-default-rtdb.firebaseio.com',
        'shopping-list/$id.json');
  }
}