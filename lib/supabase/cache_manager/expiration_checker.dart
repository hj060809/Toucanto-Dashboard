import 'package:supabase_flutter/supabase_flutter.dart';

Future<bool> readExpirationAt(String dataName) async {
  final _supabase = Supabase.instance.client;
  final isExpired = await _supabase
      .from("cache_expiration")
      .select("is_expired")
      .eq("data_type", dataName)
      .limit(1);
  return isExpired[0]["is_expired"];
}

Future<void> notifyCacheUpdateAt(String dataName) async {
  final _supabase = Supabase.instance.client;
  await _supabase
      .from("cache_expiration")
      .update({"is_expired": false})
      .eq("data_type", dataName);
}