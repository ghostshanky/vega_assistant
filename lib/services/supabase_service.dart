import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';
import 'dart:io';

class SupabaseService {
  static SupabaseService? _instance;
  static SupabaseService get instance => _instance ??= SupabaseService._();

  SupabaseService._();

  static late String supabaseUrl;
  static late String supabaseAnonKey;

  // Initialize Supabase - call this in main()
  static Future<void> initialize() async {
    try {
      // Read from env.json file
      final envFile = File('env.json');
      if (await envFile.exists()) {
        final envContent = await envFile.readAsString();
        final envData = json.decode(envContent) as Map<String, dynamic>;

        supabaseUrl = envData['SUPABASE_URL'] ?? '';
        supabaseAnonKey = envData['SUPABASE_ANON_KEY'] ?? '';
      } else {
        // Fallback to environment variables
        supabaseUrl =
            const String.fromEnvironment('SUPABASE_URL', defaultValue: '');
        supabaseAnonKey =
            const String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: '');
      }

      if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
        throw Exception(
            'SUPABASE_URL and SUPABASE_ANON_KEY must be defined in env.json file or as environment variables.');
      }

      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseAnonKey,
      );
    } catch (e) {
      throw Exception('Failed to initialize Supabase: $e');
    }
  }

  // Get Supabase client
  SupabaseClient get client => Supabase.instance.client;

  // Authentication Methods
  Future<AuthResponse> signUp(String email, String password) async {
    try {
      final response = await client.auth.signUp(
        email: email,
        password: password,
      );
      return response;
    } catch (error) {
      throw Exception('Sign-up failed: $error');
    }
  }

  Future<AuthResponse> signIn(String email, String password) async {
    try {
      final response = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } catch (error) {
      throw Exception('Sign-in failed: $error');
    }
  }

  Future<void> signOut() async {
    try {
      await client.auth.signOut();
    } catch (error) {
      throw Exception('Sign-out failed: $error');
    }
  }

  // Get current user
  User? get currentUser => client.auth.currentUser;

  // Listen to auth state changes
  Stream<AuthState> get authStateStream => client.auth.onAuthStateChange;

  // Basic CRUD Operations
  Future<List<dynamic>> insertRow(
      String table, Map<String, dynamic> data) async {
    try {
      final response = await client.from(table).insert(data).select();
      return response;
    } catch (error) {
      throw Exception('Insert failed: $error');
    }
  }

  Future<List<dynamic>> selectRows(String table) async {
    try {
      final response = await client.from(table).select();
      return response;
    } catch (error) {
      throw Exception('Select failed: $error');
    }
  }

  Future<List<dynamic>> updateRow(String table, Map<String, dynamic> data,
      String column, dynamic value) async {
    try {
      final response =
          await client.from(table).update(data).eq(column, value).select();
      return response;
    } catch (error) {
      throw Exception('Update failed: $error');
    }
  }

  Future<List<dynamic>> deleteRow(
      String table, String column, dynamic value) async {
    try {
      final response =
          await client.from(table).delete().eq(column, value).select();
      return response;
    } catch (error) {
      throw Exception('Delete failed: $error');
    }
  }

  // Query with filters
  Future<List<dynamic>> queryWithFilter(
      String table, String column, dynamic value) async {
    try {
      final response = await client.from(table).select().eq(column, value);
      return response;
    } catch (error) {
      throw Exception('Query failed: $error');
    }
  }

  // Query with multiple conditions
  Future<List<dynamic>> queryWithFilters(
      String table, Map<String, dynamic> filters) async {
    try {
      var query = client.from(table).select();

      filters.forEach((column, value) {
        query = query.eq(column, value);
      });

      final response = await query;
      return response;
    } catch (error) {
      throw Exception('Query with filters failed: $error');
    }
  }

  // Real-time subscription
  RealtimeChannel subscribeToTable(String table, Function(dynamic) callback) {
    return client
        .channel('public:$table')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: table,
          callback: callback,
        )
        .subscribe();
  }

  // Remove subscription
  Future<void> removeSubscription(RealtimeChannel channel) async {
    await client.removeChannel(channel);
  }
}
