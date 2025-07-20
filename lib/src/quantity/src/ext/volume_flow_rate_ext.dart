import '../si/types/volume_flow_rate.dart';
import 'time_ext.dart';
import 'volume_ext.dart';

/// The standard SI unit, tersely.
VolumeFlowRateUnits cubicMetersPerSecond = VolumeFlowRate.cubicMetersPerSecond;

/// Shorthand synonym for standard SI unit.
VolumeFlowRateUnits cumecs = cubicMetersPerSecond;

/// Shorthand synonym for standard SI unit.
VolumeFlowRateUnits musecs = cubicMetersPerSecond;

/// 0.001 cubic meter per second.
VolumeFlowRateUnits litersPerSecond =
    VolumeFlowRateUnits.volumeTime(liters, seconds);

/// Shorthand synonym for liters per second.
VolumeFlowRateUnits lusecs = litersPerSecond;

/// The miner's inch as a unit.
VolumeFlowRateUnits minersInches = VolumeFlowRateUnits(
    "miner's inch", null, null, "miner's inch", 7.07921e-4, false);
