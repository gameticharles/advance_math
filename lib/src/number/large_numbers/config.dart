part of 'large.dart';

/// ===============================
///  CONFIGURATION
/// ===============================
/// Configuration for compute limits and verbosity.
class ComputeConfig {
  /// Maximum bit length allowed for BigInt results.
  static int maxBitLength = 8192; // ~10^2466 digits

  /// Maximum iterations used when converting BigInt -> int.
  static int maxIterations = 1000000;

  /// Print verbose diagnostics when true.
  static bool verboseMode = false;

  /// When true, hyperop suggests symbolic fallback for huge requests.
  static bool useSymbolicFallback = true;

  /// Conservative limits.
  static void setConservative() {
    maxBitLength = 4096;
    maxIterations = 100000;
  }

  /// Aggressive limits.
  static void setAggressive() {
    maxBitLength = 16384;
    maxIterations = 10000000;
  }
}
