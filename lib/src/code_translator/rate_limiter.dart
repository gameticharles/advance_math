part of morse_code;

/// A utility class that implements rate limiting functionality.
///
/// This class is used to ensure that a particular section of code is not
/// executed more than a certain number of times within a specified interval.
///
/// Parameters:
/// - `maxRequests`: The maximum number of requests allowed within the interval.
/// - `interval`: The time interval in which the number of requests is counted.
///
/// Example:
/// ```
/// // Create a new rate limiter that allows 10 requests per minute.
/// var rateLimiter = RateLimiter(maxRequests: 10, interval: Duration(minutes: 1));
///
/// // Example function that performs an action that should be rate-limited.
/// void performAction() {
///   try {
///     rateLimiter.checkRateLimiting();
///     print('Action performed.');
///   } on Exception catch (e) {
///     print(e);
///   }
/// }
///
/// // Simulate performing actions.
/// for (int i = 0; i < 15; i++) {
///   performAction();
/// }
/// ```
///
/// Expected output if called 15 times in a loop:
/// ```
/// Action performed.
/// Action performed.
/// Action performed.
/// ... // repeated until the 10th print statement
/// Exception: Rate limit exceeded. Please try again later.
/// ```
class RateLimiter {
  /// Maximum number of requests that can be made in the defined [interval].
  int maxRequests;

  /// Time interval in which [maxRequests] is counted.
  Duration interval;

  /// A queue to keep track of the timestamps of each request.
  final Queue<DateTime> _timestamps = Queue<DateTime>();

  /// Constructs a [RateLimiter] with optional parameters [maxRequests] and [interval].
  /// If not specified, [maxRequests] defaults to 100 and [interval] defaults to 1 second.
  RateLimiter(
      {this.maxRequests = 100, this.interval = const Duration(seconds: 1)});

  /// Checks if the rate limit has been exceeded.
  ///
  /// If the rate limit is exceeded, it throws an [Exception]. Otherwise, it records the
  /// current timestamp and allows the operation to proceed.
  ///
  /// Throws:
  /// - [Exception] if the rate limit has been exceeded.
  void checkRateLimiting() {
    var now = DateTime.now();

    // Remove timestamps outside the current interval.
    _timestamps
        .removeWhere((timestamp) => now.difference(timestamp) > interval);

    // Check if the current number of timestamps exceeds the maximum allowed requests.
    if (_timestamps.length >= maxRequests) {
      throw Exception('Rate limit exceeded. Please try again later.');
    }

    // Record the timestamp of the current request.
    _timestamps.add(now);
  }
}
