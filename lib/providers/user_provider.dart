// A simple class to store user data globally
class UserProvider {
  static Map<String, dynamic>? _userData;

  static void setUserData(Map<String, dynamic> userData) {
    _userData = userData;
  }

  static Map<String, dynamic>? getUserData() {
    return _userData;
  }

  static void clearUserData() {
    _userData = null;
  }
  
  // Add a method to get the username
  static String getCurrentUsername() {
    return _userData?['username'] ?? 'guest';
  }
}