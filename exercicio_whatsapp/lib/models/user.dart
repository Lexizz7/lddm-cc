class User {
  final String name;
  final String phone;
  final String avatarUrl;
  final List<String> messages = [];

  User({required this.name, required this.phone, required this.avatarUrl});

  void addMessage(String message) {
    messages.add(message);
  }
}
