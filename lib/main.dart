import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ball Catcher Game',
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        scaffoldBackgroundColor: Color(0xFF0A0E27),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF1A1F3A),
          elevation: 0,
          centerTitle: true,
        ),
        colorScheme: ColorScheme.dark(
          primary: Color(0xFF6366F1),
          secondary: Color(0xFF8B5CF6),
          tertiary: Color(0xFFEC4899),
          surface: Color(0xFF1A1F3A),
          surfaceVariant: Color(0xFF2D3250),
          error: Color(0xFFFF6B6B),
        ),
        textTheme: TextTheme(
          displayLarge: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
          displayMedium: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          bodyMedium: TextStyle(
            color: Color(0xFFCDD5F4),
            fontSize: 14,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFF2D3250),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          labelStyle: TextStyle(color: Color(0xFF9CA3AF)),
          hintStyle: TextStyle(color: Color(0xFF6B7280)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF6366F1),
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
          ),
        ),
      ),
      home: RoleSelectScreen(),
    );
  }
}

// ==================== ROLE SELECTION SCREEN ====================
class RoleSelectScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0A0E27),
              Color(0xFF1A1F3A),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '🎮 BALL CATCHER',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Catch the falling balls!',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF9CA3AF),
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: 60),
              RoleCard(
                icon: '👨‍💼',
                title: 'Admin',
                subtitle: 'Manage users',
                color: Color(0xFF6366F1),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminLoginScreen()),
                ),
              ),
              SizedBox(height: 20),
              RoleCard(
                icon: '🎮',
                title: 'Player',
                subtitle: 'Play & catch balls',
                color: Color(0xFFEC4899),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PlayerLoginScreen()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RoleCard extends StatefulWidget {
  final String icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  RoleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  State<RoleCard> createState() => _RoleCardState();
}

class _RoleCardState extends State<RoleCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          transform: Matrix4.identity()..translate(0, _isHovered ? -8 : 0),
          child: Container(
            width: 280,
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Color(0xFF1A1F3A),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: widget.color.withOpacity(_isHovered ? 0.6 : 0.2),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.color.withOpacity(_isHovered ? 0.3 : 0.1),
                  blurRadius: _isHovered ? 20 : 8,
                  offset: Offset(0, _isHovered ? 12 : 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(widget.icon, style: TextStyle(fontSize: 56)),
                SizedBox(height: 16),
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  widget.subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==================== ADMIN LOGIN SCREEN ====================
class AdminLoginScreen extends StatefulWidget {
  @override
  _AdminLoginScreenState createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  final String adminId = "sakthi_";
  final String adminPassword = "sakthi123";

  void _login() async {
    if (idController.text.isEmpty || passController.text.isEmpty) {
      _showError("Please fill all fields");
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(Duration(milliseconds: 800));

    if (idController.text == adminId && passController.text == adminPassword) {
      setState(() => _isLoading = false);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AdminPanelScreen()),
      );
    } else {
      setState(() => _isLoading = false);
      _showError("❌ Invalid Admin Credentials");
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Color(0xFFFF6B6B),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Login'),
        leading: BackButton(),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0A0E27),
              Color(0xFF1A1F3A),
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '👨‍💼',
                    style: TextStyle(fontSize: 64),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Admin Access',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Manage players',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                  SizedBox(height: 40),
                  TextField(
                    controller: idController,
                    decoration: InputDecoration(labelText: "Admin ID"),
                    enabled: !_isLoading,
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: passController,
                    decoration: InputDecoration(
                      labelText: "Password",
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Color(0xFF9CA3AF),
                        ),
                        onPressed: () =>
                            setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                    obscureText: _obscurePassword,
                    enabled: !_isLoading,
                  ),
                  SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _login,
                      child: _isLoading
                          ? SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white),
                              ),
                            )
                          : Text(
                              'Login',
                              style: TextStyle(fontSize: 16),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ==================== ADMIN PANEL SCREEN ====================
class AdminPanelScreen extends StatefulWidget {
  @override
  _AdminPanelScreenState createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _addUser() async {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      _showError("❌ Please fill all fields");
      return;
    }

    try {
      // Check if user already exists
      var existingUser = await firestore
          .collection("users")
          .where("username", isEqualTo: usernameController.text)
          .get();

      if (existingUser.docs.isNotEmpty) {
        _showError("❌ Username already exists!");
        return;
      }

      // Add user to Firebase
      DocumentReference docRef = await firestore.collection("users").add({
        "username": usernameController.text,
        "password": passwordController.text,
        "createdAt": Timestamp.now(),
        "score": 0,
        "ballsCaught": 0,
        "highScore": 0,
        "gamesPlayed": 0,
      });

      print("✅ SUCCESS: User '${usernameController.text}' stored in Firebase!");
      print("📍 Document ID: ${docRef.id}");
      print("🗄️ Collection: users");

      usernameController.clear();
      passwordController.clear();

      _showSuccess("✅ User created & stored in Firebase!\n\nCheck Firebase Console to verify!");
    } catch (e) {
      _showError("❌ Error: $e");
      print("Firebase Error: $e");
    }
  }

  void _deleteUser(String docId, String username) async {
    try {
      await firestore.collection("users").doc(docId).delete();
      _showSuccess("✅ $username deleted!");
    } catch (e) {
      _showError("❌ Error deleting user: $e");
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Color(0xFFFF6B6B),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel'),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Color(0xFF6366F1),
          tabs: [
            Tab(text: 'Create User'),
            Tab(text: 'Manage Users'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // CREATE USER TAB
          Padding(
            padding: EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add New Player',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Create a new player account (will be stored in Firebase)',
                    style: TextStyle(
                      color: Color(0xFF9CA3AF),
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 32),
                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText: "Username",
                      prefixIcon: Icon(Icons.person, color: Color(0xFF6366F1)),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: Icon(Icons.lock, color: Color(0xFF6366F1)),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _addUser,
                      child: Text('Create User'),
                    ),
                  ),
                  SizedBox(height: 24),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xFF1A1F3A),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Color(0xFF2D3250)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '💾 Firebase Storage Info',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF6366F1),
                          ),
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(Icons.check_circle, color: Color(0xFF10B981), size: 16),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'All users automatically saved to Firebase Firestore',
                                style: TextStyle(
                                  color: Color(0xFF9CA3AF),
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.check_circle, color: Color(0xFF10B981), size: 16),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Collection: "users"',
                                style: TextStyle(
                                  color: Color(0xFF9CA3AF),
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.check_circle, color: Color(0xFF10B981), size: 16),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Fields: username, password, score, highScore, gamesPlayed',
                                style: TextStyle(
                                  color: Color(0xFF9CA3AF),
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // MANAGE USERS TAB
          Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Active Players',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                SizedBox(height: 16),
                Expanded(
                  child: StreamBuilder(
                    stream: firestore
                        .collection("users")
                        .orderBy("createdAt", descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF6366F1)),
                          ),
                        );
                      }

                      var docs = snapshot.data!.docs;

                      if (docs.isEmpty) {
                        return Center(
                          child: Text(
                            'No players yet\nCreate one in the Create User tab',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF9CA3AF),
                              fontSize: 16,
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          var data = docs[index];
                          return UserCard(
                            username: data["username"],
                            highScore: data["highScore"] ?? 0,
                            gamesPlayed: data["gamesPlayed"] ?? 0,
                            onDelete: () => _deleteUser(
                              docs[index].id,
                              data["username"],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  final String username;
  final int highScore;
  final int gamesPlayed;
  final VoidCallback onDelete;

  UserCard({
    required this.username,
    required this.highScore,
    required this.gamesPlayed,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF1A1F3A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Color(0xFF2D3250),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Color(0xFF6366F1),
            child: Text(
              username[0].toUpperCase(),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '🎮 Games: $gamesPlayed',
                      style: TextStyle(
                        color: Color(0xFF9CA3AF),
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      '⭐ Best: $highScore',
                      style: TextStyle(
                        color: Color(0xFF10B981),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Color(0xFFFF6B6B)),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}

// ==================== PLAYER LOGIN SCREEN ====================
class PlayerLoginScreen extends StatefulWidget {
  @override
  _PlayerLoginScreenState createState() => _PlayerLoginScreenState();
}

class _PlayerLoginScreenState extends State<PlayerLoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  void _login() async {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      _showError("❌ Please fill all fields");
      return;
    }

    setState(() => _isLoading = true);

    try {
      // First try exact match
      var snapshot = await firestore
          .collection("users")
          .where("username", isEqualTo: usernameController.text)
          .where("password", isEqualTo: passwordController.text)
          .get();

      // If no match, get all and try case-insensitive
      if (snapshot.docs.isEmpty) {
        snapshot = await firestore.collection("users").get();

        var matchedDoc;
        for (var doc in snapshot.docs) {
          var data = doc.data();
          if (data["username"].toString().toLowerCase() ==
                  usernameController.text.toLowerCase() &&
              data["password"] == passwordController.text) {
            matchedDoc = doc;
            break;
          }
        }

        if (matchedDoc == null) {
          setState(() => _isLoading = false);
          _showError("❌ Invalid username or password\n\nAsk admin to create your account");
          return;
        }

        var userId = matchedDoc.id;
        var userData = matchedDoc.data();

        setState(() => _isLoading = false);
        print("✅ Login successful! User: ${userData["username"]}");

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GameScreen(
              userId: userId,
              username: userData["username"],
            ),
          ),
        );
      } else {
        var userId = snapshot.docs[0].id;
        var userData = snapshot.docs[0].data();

        setState(() => _isLoading = false);
        print("✅ Login successful! User: ${userData["username"]}");

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GameScreen(
              userId: userId,
              username: userData["username"],
            ),
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      print("❌ Login Error: $e");
      _showError("❌ Error: $e");
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Color(0xFFFF6B6B),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _showAvailableUsers() async {
    try {
      var snapshot = await firestore.collection("users").get();

      if (snapshot.docs.isEmpty) {
        _showError("❌ No users found! Ask admin to create one.");
        return;
      }

      String userList = "📋 Available Users:\n\n";
      for (var doc in snapshot.docs) {
        var data = doc.data();
        userList += "👤 Username: ${data["username"]}\n";
        userList += "   Password: ${data["password"]}\n\n";
      }

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Color(0xFF1A1F3A),
          title: Text(
            '📋 Available Users',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          content: SingleChildScrollView(
            child: Text(
              userList,
              style: TextStyle(
                color: Color(0xFF9CA3AF),
                fontFamily: 'monospace',
                fontSize: 13,
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        ),
      );
    } catch (e) {
      _showError("❌ Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Player Login'),
        leading: BackButton(),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0A0E27),
              Color(0xFF1A1F3A),
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '🎮',
                    style: TextStyle(fontSize: 64),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Player Login',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Login to play & catch balls',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                  SizedBox(height: 40),
                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(labelText: "Username"),
                    enabled: !_isLoading,
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: "Password",
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Color(0xFF9CA3AF),
                        ),
                        onPressed: () =>
                            setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                    obscureText: _obscurePassword,
                    enabled: !_isLoading,
                  ),
                  SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _login,
                      child: _isLoading
                          ? SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white),
                              ),
                            )
                          : Text(
                              'Login',
                              style: TextStyle(fontSize: 16),
                            ),
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: _showAvailableUsers,
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Color(0xFF1A1F3A),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Color(0xFF2D3250)),
                      ),
                      child: Text(
                        '📋 View Available Users (DEBUG)',
                        style: TextStyle(
                          color: Color(0xFF6366F1),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ==================== BALL CATCHING GAME ====================
class GameScreen extends StatefulWidget {
  final String userId;
  final String username;

  GameScreen({required this.userId, required this.username});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class Ball {
  double x;
  double y;
  double vx;
  double vy;
  Color color;
  double radius;
  bool caught = false;

  Ball({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.color,
    this.radius = 15,
  });
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController gameController;
  List<Ball> balls = [];
  double basketX = 0;
  double basketWidth = 80;
  int score = 0;
  int health = 3;
  bool gameActive = true;
  int level = 1;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    gameController =
        AnimationController(vsync: this, duration: Duration(hours: 1));

    gameController.addListener(() {
      _updateGame();
    });

    gameController.forward();

    Future.delayed(Duration(milliseconds: 500), _startGame);
  }

  void _startGame() {
    _spawnBall();
  }

  void _spawnBall() {
    if (!gameActive) return;

    Random random = Random();
    double screenWidth = MediaQuery.of(context).size.width;
    double randomX = random.nextDouble() * (screenWidth - 30);
    double randomVx = (random.nextDouble() - 0.5) * 4;

    balls.add(
      Ball(
        x: randomX,
        y: 50,
        vx: randomVx,
        vy: 3 + (level * 0.5),
        color: [
          Color(0xFF6366F1),
          Color(0xFF8B5CF6),
          Color(0xFFEC4899),
          Color(0xFF10B981),
          Color(0xFFFACC15),
        ][Random().nextInt(5)],
      ),
    );

    if (gameActive) {
      Future.delayed(
        Duration(milliseconds: (2000 - (level * 100)).toInt().clamp(500, 2000)),
        _spawnBall,
      );
    }
  }

  void _updateGame() {
    if (!gameActive) return;

    setState(() {
      double screenHeight = MediaQuery.of(context).size.height;
      double screenWidth = MediaQuery.of(context).size.width;

      for (int i = balls.length - 1; i >= 0; i--) {
        Ball ball = balls[i];

        ball.x += ball.vx;
        ball.y += ball.vy;

        if (ball.x < 0 || ball.x > screenWidth - 30) {
          ball.vx *= -1;
          ball.x = ball.x.clamp(0, screenWidth - 30);
        }

        if (ball.y > screenHeight - 150 &&
            ball.x > basketX - ball.radius &&
            ball.x < basketX + basketWidth + ball.radius) {
          ball.caught = true;
          score += (10 * level);
        }

        if (ball.caught || ball.y > screenHeight + 50) {
          if (!ball.caught && ball.y > screenHeight) {
            health--;
            if (health <= 0) {
              _endGame();
            }
          }
          balls.removeAt(i);
        }
      }

      if (score > level * 100) {
        level++;
      }
    });
  }

  void _endGame() {
    gameActive = false;
    gameController.stop();
    _saveScore();
    _showGameOverDialog();
  }

  void _saveScore() async {
    try {
      int currentHighScore = await _getHighScore();
      int newHighScore = score > currentHighScore ? score : currentHighScore;

      await firestore.collection("users").doc(widget.userId).update({
        "highScore": newHighScore,
        "gamesPlayed": FieldValue.increment(1),
        "lastPlayedAt": Timestamp.now(),
      });

      print("✅ SCORE SAVED TO FIREBASE!");
      print("📊 High Score: $newHighScore | Score: $score");
      print("📱 Player: ${widget.username}");
    } catch (e) {
      print("❌ Error saving score: $e");
    }
  }

  Future<int> _getHighScore() async {
    try {
      var doc = await firestore.collection("users").doc(widget.userId).get();
      return doc.data()?["highScore"] ?? 0;
    } catch (e) {
      return 0;
    }
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF1A1F3A),
        title: Text(
          '⚽ Game Over!',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 16),
            Text(
              'Final Score',
              style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
            ),
            Text(
              '$score',
              style: TextStyle(
                color: Color(0xFF6366F1),
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Level: $level',
              style: TextStyle(
                color: Color(0xFF9CA3AF),
                fontSize: 14,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '✅ Score saved to Firebase!',
              style: TextStyle(
                color: Color(0xFF10B981),
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('Back to Menu'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                score = 0;
                health = 3;
                balls = [];
                gameActive = true;
                level = 1;
              });
              gameController.forward(from: 0);
              _startGame();
            },
            child: Text('Play Again'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    gameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    basketX = screenWidth / 2 - basketWidth / 2;

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        setState(() {
          basketX += details.delta.dx;
          basketX = basketX.clamp(0, screenWidth - basketWidth);
        });
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('${widget.username} - Score: $score | Level: $level'),
          elevation: 0,
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: Text(
                  '❤️ $health',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF6B6B),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF0A0E27),
                Color(0xFF1A1F3A),
              ],
            ),
          ),
          child: Stack(
            children: [
              ...balls.map((ball) {
                return Positioned(
                  left: ball.x,
                  top: ball.y,
                  child: Container(
                    width: ball.radius * 2,
                    height: ball.radius * 2,
                    decoration: BoxDecoration(
                      color: ball.color,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: ball.color.withOpacity(0.6),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),

              Positioned(
                left: basketX,
                bottom: 40,
                child: Container(
                  width: basketWidth,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color(0xFF6366F1),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF6366F1).withOpacity(0.6),
                        blurRadius: 15,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '🎯',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                ),
              ),

              if (gameController.value < 0.3)
                Center(
                  child: Container(
                    padding: EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Color(0xFF0A0E27).withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '🎮 Ball Catcher',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 24),
                        Text(
                          'Drag basket to catch falling balls!',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF9CA3AF),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Don\'t miss 3 balls',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFFFF6B6B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
