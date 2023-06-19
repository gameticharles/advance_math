import '../../quantity_ext.dart';
import '../si/types/angular_speed.dart';
import '../si/types/time.dart';

/// The standard SI unit.
final AngularSpeedUnits radiansPerSecond = AngularSpeed.radiansPerSecond;

/// Accepted for use with the SI.
final AngularSpeedUnits degreesPerSecond = AngularSpeed.degreesPerSecond;

/// Rotation frequency.
final AngularSpeedUnits revolutionsPerMinute =
    AngularSpeedUnits.angleTime(AngleUnits.revolutions, Time.minutes);

/// A synonym for [revolutionsPerMinute].
final AngularSpeedUnits rpm = revolutionsPerMinute;
