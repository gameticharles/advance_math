import 'package:test/test.dart';
import 'package:advance_math/src/quantity/quantity.dart';

void main() {
  group('Dimensions', () {
    test('base dimensions', () {
      expect(Dimensions.baseLengthKey, 'Length');
      expect(Dimensions.baseMassKey, 'Mass');
      expect(Dimensions.baseTimeKey, 'Time');
      expect(Dimensions.baseCurrentKey, 'Current');
      expect(Dimensions.baseIntensityKey, 'Intensity');
      expect(Dimensions.baseAmountKey, 'Amount');
      expect(Dimensions.baseTemperatureKey, 'Temperature');
    });

    test('auxiliary base dimensions', () {
      expect(Dimensions.baseAngleKey, 'Angle');
      expect(Dimensions.baseSolidAngleKey, 'Solid Angle');
    });

    test('constructors', () {
      var d = Dimensions();
      expect(d, isNotNull);

      const d2 = Dimensions.constant(<String, int>{'Length': 2});
      expect(d2, isNotNull);
      expect(d2.getComponentExponent(Dimensions.baseLengthKey), 2);

      d = Dimensions.fromMap(<String, int>{'Time': -1});
      expect(d, isNotNull);
      expect(d.getComponentExponent(Dimensions.baseTimeKey), -1);

      final d3 = Dimensions.copy(d);
      expect(d3, isNotNull);
      expect(d3.getComponentExponent(Dimensions.baseTimeKey), -1);
    });

    test('equality', () {
      final d1 = Dimensions.fromMap(
          <String, int>{'Time': -1, 'Length': 1, 'Angle': 1, 'Amount': -2});

      final d2 = Dimensions.fromMap(
          <String, int>{'Angle': 1, 'Amount': -2, 'Time': -1, 'Length': 1});

      expect(d1 == d2, true);
      expect(d1 != d2, false);
      expect(d1 == d1, true);
      expect(d1 != d1, false);
    });

    test('equalsSI', () {
      final d1 = Dimensions.fromMap(
          <String, int>{'Time': -1, 'Length': 1, 'Angle': 1, 'Amount': -2});

      final d2 = Dimensions.fromMap(
          <String, int>{'Amount': -2, 'Time': -1, 'Length': 1});

      final d3 = Dimensions.fromMap(<String, int>{
        'Time': -1,
        'Length': 1,
        'Angle': 5,
        'Amount': -2,
        'Solid Angle': 3
      });

      expect(d1 == d2, false);
      expect(d1 == d3, false);
      expect(d2 == d3, false);
      expect(d1.equalsSI(d2), true);
      expect(d2.equalsSI(d1), true);
      expect(d1.equalsSI(d3), true);
      expect(d3.equalsSI(d1), true);
      expect(d2.equalsSI(d3), true);
      expect(d3.equalsSI(d2), true);
    });

    test('hashCode', () {
      final d1 = Dimensions.fromMap(
          <String, int>{'Time': -1, 'Length': 1, 'Angle': 1, 'Amount': -2});

      final d2 = Dimensions.fromMap(
          <String, int>{'Angle': 1, 'Amount': -2, 'Time': -1, 'Length': 1});

      final d3 = Dimensions.fromMap(<String, int>{
        'Time': -1,
        'Length': 1,
        'Angle': 5,
        'Amount': -2,
        'Solid Angle': 3
      });

      final testMap = <Dimensions, int>{};
      testMap[d1] = 1;
      testMap[d2] = 2;
      testMap[d3] = 3;

      expect(d1.hashCode == d2.hashCode, true);
      expect(d1.hashCode == d3.hashCode, false);
      expect(testMap.length, 2);
      expect(testMap[d1], 2);
    });

    test('operator *', () {
      final d1 = Dimensions.fromMap(
          <String, int>{'Time': -1, 'Length': 1, 'Angle': 1, 'Amount': -2});

      final d2 = Dimensions.fromMap(
          <String, int>{'Amount': 2, 'Time': -1, 'Length': 2});

      final d3 = Dimensions.fromMap(
          <String, int>{'Time': -2, 'Length': 3, 'Angle': 1});

      final d4 = Dimensions.fromMap(
          <String, int>{'Time': -2, 'Length': 2, 'Angle': 2, 'Amount': -4});

      final d5 = Dimensions();

      expect(d1 * d2, d3);
      expect(d2 * d1, d3);
      expect(d1 * d1, d4);
      expect(d1 * d5, d1);
      expect(d5 * d1, d1);
    });

    test('operator /', () {
      final d1 = Dimensions.fromMap(
          <String, int>{'Time': -1, 'Length': 1, 'Angle': 1, 'Amount': -2});

      final d2 = Dimensions.fromMap(
          <String, int>{'Amount': 2, 'Time': -1, 'Length': 2});

      final d3 = Dimensions.fromMap(
          <String, int>{'Length': -1, 'Angle': 1, 'Amount': -4});

      final d4 = Dimensions.fromMap(
          <String, int>{'Length': 1, 'Angle': -1, 'Amount': 4});

      final d5 = Dimensions();

      final d6 = Dimensions.fromMap(
          <String, int>{'Time': 1, 'Length': -1, 'Angle': -1, 'Amount': 2});

      expect(d1 / d2, d3);
      expect(d2 / d1, d4);
      expect(d1 / d1, d5);
      expect(d1 / d5, d1);
      expect(d5 / d1, d6);
    });

    test('operator ^', () {
      final d1 = Dimensions.fromMap(
          <String, int>{'Time': -1, 'Length': 1, 'Angle': 1, 'Amount': -2});

      final d2 = Dimensions.fromMap(
          <String, int>{'Amount': 2, 'Time': -1, 'Length': 2});

      final d3 = Dimensions.fromMap(
          <String, int>{'Length': -1, 'Angle': 1, 'Amount': -4});

      final d4 = Dimensions.fromMap(
          <String, int>{'Length': 1, 'Angle': -1, 'Amount': 4});

      final d5 = Dimensions();

      final d6 = Dimensions.fromMap(
          <String, int>{'Time': 1, 'Length': -1, 'Angle': -1, 'Amount': 2});

      expect(d1 ^ 1, d1);
      expect(d1 ^ 0, d5);

      final d2Squared = d2 ^ 2;
      expect(d2Squared.getComponentExponent(Dimensions.baseAmountKey), 4);
      expect(d2Squared.getComponentExponent(Dimensions.baseTimeKey), -2);
      expect(d2Squared.getComponentExponent(Dimensions.baseLengthKey), 4);
      expect(d2Squared ^ 0.5, d2);

      final d3Inverse = d3 ^ -1;
      expect(d3Inverse.getComponentExponent(Dimensions.baseLengthKey), 1);
      expect(d3Inverse.getComponentExponent(Dimensions.baseAngleKey), -1);
      expect(d3Inverse.getComponentExponent(Dimensions.baseAmountKey), 4);
      final d3InverseCubed = d3Inverse ^ 3;
      expect(d3InverseCubed.getComponentExponent(Dimensions.baseLengthKey), 3);
      expect(d3InverseCubed.getComponentExponent(Dimensions.baseAngleKey), -3);
      expect(d3InverseCubed.getComponentExponent(Dimensions.baseAmountKey), 12);

      final d4Sqrt = d4 ^ 0.5;
      expect(d4Sqrt.getComponentExponent(Dimensions.baseLengthKey), 0.5);
      expect(d4Sqrt.getComponentExponent(Dimensions.baseAngleKey), -0.5);
      expect(d4Sqrt.getComponentExponent(Dimensions.baseAmountKey), 2);
      expect(d4Sqrt ^ 2, d4);

      final d6Mod = d6 ^ -0.123;
      expect(d6Mod.getComponentExponent(Dimensions.baseTimeKey), -0.123);
      expect(d6Mod.getComponentExponent(Dimensions.baseLengthKey), 0.123);
      expect(d6Mod.getComponentExponent(Dimensions.baseAngleKey), 0.123);
      expect(d6Mod.getComponentExponent(Dimensions.baseAmountKey), -0.246);
    });

    test('inverse', () {
      final d1 = Dimensions.fromMap(<String, int>{
        'Time': 3,
        'Length': 2,
        'Angle': 1,
        'Amount': 0,
        'Temperature': -1,
        'Mass': -2,
        'Current': -3,
        'Intensity': -4,
        'Solid Angle': -5
      });

      final d2 = Dimensions.fromMap(<String, int>{
        'Time': -3,
        'Length': -2,
        'Angle': -1,
        'Amount': 0,
        'Temperature': 1,
        'Mass': 2,
        'Current': 3,
        'Intensity': 4,
        'Solid Angle': 5
      });

      final d3 = Dimensions();

      expect(d1.inverse(), d2);
      expect(d2.inverse(), d1);
      expect(d3.inverse(), d3);
    });

    test('determine quantity type', () {
      // BASE QUANTITIES
      expect(
          Dimensions.determineQuantityType(
              Dimensions.fromMap(<String, int>{'Length': 1})),
          Length);
      expect(
          Dimensions.determineQuantityType(
              Dimensions.fromMap(<String, int>{'Mass': 1})),
          Mass);
      expect(
          Dimensions.determineQuantityType(
              Dimensions.fromMap(<String, int>{'Time': 1})),
          Time);
      expect(
          Dimensions.determineQuantityType(
              Dimensions.fromMap(<String, int>{'Temperature': 1})),
          TemperatureInterval);
      expect(
          Dimensions.determineQuantityType(
              Dimensions.fromMap(<String, int>{'Current': 1})),
          Current);
      expect(
          Dimensions.determineQuantityType(
              Dimensions.fromMap(<String, int>{'Intensity': 1})),
          LuminousIntensity);
      expect(
          Dimensions.determineQuantityType(
              Dimensions.fromMap(<String, int>{'Amount': 1})),
          AmountOfSubstance);

      // AUX BASE
      expect(
          Dimensions.determineQuantityType(
              Dimensions.fromMap(<String, int>{'Angle': 1})),
          Angle);
      expect(
          Dimensions.determineQuantityType(
              Dimensions.fromMap(<String, int>{'Solid Angle': 1})),
          SolidAngle);

      // THE REST

      // x-AbsorbedDose (SpecificEnergy)

      expect(
          Dimensions.determineQuantityType(
              Dimensions.fromMap(<String, int>{'Length': 2, 'Time': -3})),
          AbsorbedDoseRate);
      expect(
          Dimensions.determineQuantityType(
              Dimensions.fromMap(<String, int>{'Length': 1, 'Time': -2})),
          Acceleration);

      // x-Activity (Frequency)

      expect(
          Dimensions.determineQuantityType(
              Dimensions.fromMap(<String, int>{'Angle': 1, 'Time': -2})),
          AngularAcceleration);
      expect(
          Dimensions.determineQuantityType(Dimensions.fromMap(
              <String, int>{'Angle': 1, 'Time': -1, 'Length': 1})),
          AngularMomentum);
      expect(
          Dimensions.determineQuantityType(
              Dimensions.fromMap(<String, int>{'Angle': 1, 'Time': -1})),
          AngularSpeed);

      // x-AngularVelocity (AngularSpeed)

      expect(
          Dimensions.determineQuantityType(
              Dimensions.fromMap(<String, int>{'Length': 2})),
          Area);

      // x-Capacitance (Capacitance)

      expect(
          Dimensions.determineQuantityType(
              Dimensions.fromMap(<String, int>{'Amount': 1, 'Time': -1})),
          CatalyticActivity);

      // x-Charge (Charge)

      expect(
          Dimensions.determineQuantityType(
              Dimensions.fromMap(<String, int>{'Amount': 1, 'Length': -3})),
          Concentration);

      // x-Conductance (Conductance)
      // x-Currency (Scalar)
      // x-DoseEquivalent (SpecificEnergy)

      expect(
          Dimensions.determineQuantityType(Dimensions.fromMap(
              <String, int>{'Mass': 1, 'Length': -1, 'Time': -1})),
          DynamicViscosity);
      expect(
          Dimensions.determineQuantityType(Dimensions.fromMap(<String, int>{
            'Time': 4,
            'Current': 2,
            'Length': -2,
            'Mass': -1
          })),
          Capacitance);
      expect(
          Dimensions.determineQuantityType(
              Dimensions.fromMap(<String, int>{'Current': 1, 'Time': 1})),
          Charge);
      expect(
          Dimensions.determineQuantityType(Dimensions.fromMap(
              <String, int>{'Current': 1, 'Time': 1, 'Length': -3})),
          ChargeDensity);
      expect(
          Dimensions.determineQuantityType(Dimensions.fromMap(<String, int>{
            'Current': 2,
            'Time': 3,
            'Length': -2,
            'Mass': -1
          })),
          Conductance);
      expect(
          Dimensions.determineQuantityType(
              Dimensions.fromMap(<String, int>{'Current': 1, 'Length': -2})),
          CurrentDensity);
      expect(
          Dimensions.determineQuantityType(Dimensions.fromMap(<String, int>{
            'Current': -1,
            'Time': -3,
            'Length': 1,
            'Mass': 1
          })),
          ElectricFieldStrength);
      expect(
          Dimensions.determineQuantityType(Dimensions.fromMap(
              <String, int>{'Current': 1, 'Time': 1, 'Length': -2})),
          ElectricFluxDensity);
      expect(
          Dimensions.determineQuantityType(Dimensions.fromMap(<String, int>{
            'Current': -1,
            'Time': -3,
            'Length': 2,
            'Mass': 1
          })),
          ElectricPotentialDifference);
      expect(
          Dimensions.determineQuantityType(Dimensions.fromMap(<String, int>{
            'Current': -2,
            'Time': -3,
            'Length': 2,
            'Mass': 1
          })),
          Resistance);

      // x-ElectromotiveForce (ElectricPotentialDifference)
      // x-Emf (PotentialDifference)

      expect(
          Dimensions.determineQuantityType(Dimensions.fromMap(
              <String, int>{'Length': 2, 'Mass': 1, 'Time': -2})),
          Energy);

      // x-EnergyDensity (Pressure)
      // x-EnergyFlux (Power)
      // x-EnergyFluxDensity (HeatFluxDensity)

      expect(
          Dimensions.determineQuantityType(Dimensions.fromMap(<String, int>{
            'Length': 2,
            'Mass': 1,
            'Temperature': -1,
            'Time': -2
          })),
          Entropy);

      // x-Epoch (TimeInstant)

      expect(
          Dimensions.determineQuantityType(Dimensions.fromMap(
              <String, int>{'Current': 1, 'Mass': -1, 'Time': 1})),
          Exposure);

      // x-FieldLevel (Level)

      expect(
          Dimensions.determineQuantityType(Dimensions.fromMap(
              <String, int>{'Length': 1, 'Mass': 1, 'Time': -2})),
          Force);
      expect(
          Dimensions.determineQuantityType(
              Dimensions.fromMap(<String, int>{'Time': -1})),
          Frequency);

      // x-HeatCapacity (Entropy)
      // x-HeatFlowRate (Power)

      expect(
          Dimensions.determineQuantityType(
              Dimensions.fromMap(<String, int>{'Mass': 1, 'Time': -3})),
          HeatFluxDensity);
      expect(
          Dimensions.determineQuantityType(Dimensions.fromMap(
              <String, int>{'Length': -2, 'Intensity': 1, 'Solid Angle': 1})),
          Illuminance);

      // x-ImpartedSpecificEnergy (SpecificEnergy)
      // x-Information (Scalar)
      // x-InformationRate (Scalar)

      expect(
          Dimensions.determineQuantityType(Dimensions.fromMap(<String, int>{
            'Length': 2,
            'Mass': 1,
            'Current': -2,
            'Time': -2
          })),
          Inductance);

      // x-Irradiance (HeatFluxDensity)
      // x-Kerma (SpecificEnergy)

      expect(
          Dimensions.determineQuantityType(
              Dimensions.fromMap(<String, int>{'Length': 2, 'Time': -1})),
          KinematicViscosity);

      // x-Level (Scalar)

      expect(
          Dimensions.determineQuantityType(
              Dimensions.fromMap(<String, int>{'Length': -2, 'Intensity': 1})),
          Luminance);
      expect(
          Dimensions.determineQuantityType(Dimensions.fromMap(
              <String, int>{'Intensity': 1, 'Solid Angle': 1})),
          LuminousFlux);
      expect(
          Dimensions.determineQuantityType(
              Dimensions.fromMap(<String, int>{'Length': -1, 'Current': 1})),
          MagneticFieldStrength);
      expect(
          Dimensions.determineQuantityType(Dimensions.fromMap(<String, int>{
            'Length': 2,
            'Time': -2,
            'Current': -1,
            'Mass': 1
          })),
          MagneticFlux);
      expect(
          Dimensions.determineQuantityType(Dimensions.fromMap(
              <String, int>{'Mass': 1, 'Current': -1, 'Time': -2})),
          MagneticFluxDensity);
      expect(
          Dimensions.determineQuantityType(
              Dimensions.fromMap(<String, int>{'Mass': 1, 'Length': -3})),
          MassDensity);
      expect(
          Dimensions.determineQuantityType(
              Dimensions.fromMap(<String, int>{'Mass': 1, 'Time': -1})),
          MassFlowRate);
      expect(
          Dimensions.determineQuantityType(Dimensions.fromMap(
              <String, int>{'Mass': 1, 'Time': -1, 'Length': -2})),
          MassFluxDensity);
      expect(
          Dimensions.determineQuantityType(Dimensions.fromMap(
              <String, int>{'Mass': 1, 'Length': 2, 'Time': -2, 'Amount': -1})),
          MolarEnergy);
      expect(
          Dimensions.determineQuantityType(Dimensions.fromMap(<String, int>{
            'Mass': 1,
            'Length': 2,
            'Time': -2,
            'Amount': -1,
            'Temperature': -1
          })),
          MolarEntropy);

      // x-MolarHeatCapacity (MolarEntropy), MomentOfForce (Torque)

      expect(
          Dimensions.determineQuantityType(Dimensions.fromMap(<String, int>{
            'Length': 1,
            'Mass': 1,
            'Time': -2,
            'Current': -2
          })),
          Permeability);
      expect(
          Dimensions.determineQuantityType(Dimensions.fromMap(<String, int>{
            'Length': -3,
            'Time': 4,
            'Current': 2,
            'Mass': -1
          })),
          Permittivity);

      // x-Potential (PotentialDifference)

      expect(
          Dimensions.determineQuantityType(Dimensions.fromMap(
              <String, int>{'Length': 2, 'Mass': 1, 'Time': -3})),
          Power);

      // x-PowerFluxDensity (HeatFluxDensity)
      // x-PowerLevel (Level)

      expect(
          Dimensions.determineQuantityType(Dimensions.fromMap(
              <String, int>{'Length': -1, 'Mass': 1, 'Time': -2})),
          Pressure);
      expect(
          Dimensions.determineQuantityType(Dimensions.fromMap(
              <String, int>{'Mass': 1, 'Solid Angle': -1, 'Time': -3})),
          Radiance);

      // x-RadiantFlux (Power)

      expect(
          Dimensions.determineQuantityType(Dimensions.fromMap(<String, int>{
            'Length': 2,
            'Mass': 1,
            'Time': -3,
            'Solid Angle': -1
          })),
          RadiantIntensity);

      // x-Resistance (Resistance)

      expect(
          Dimensions.determineQuantityType(Dimensions.fromMap(<String, int>{})),
          Scalar);

      // x-SoundIntensity (HeatFluxDensity)
      // x-SoundIntensityLevel (PowerLevel => Level)
      // x-SoundPressureLevel (FieldLevel => Level)

      expect(
          Dimensions.determineQuantityType(
              Dimensions.fromMap(<String, int>{'Length': 2, 'Time': -2})),
          SpecificEnergy);

      // x-SpecificEntropy (SpecificHeatCapacity)

      expect(
          Dimensions.determineQuantityType(Dimensions.fromMap(
              <String, int>{'Length': 2, 'Time': -2, 'Temperature': -1})),
          SpecificHeatCapacity);
      expect(
          Dimensions.determineQuantityType(
              Dimensions.fromMap(<String, int>{'Length': 3, 'Mass': -1})),
          SpecificVolume);
      expect(
          Dimensions.determineQuantityType(
              Dimensions.fromMap(<String, int>{'Length': 1, 'Time': -1})),
          Speed);

      // x-Stress (Pressure)

      expect(
          Dimensions.determineQuantityType(
              Dimensions.fromMap(<String, int>{'Mass': 1, 'Time': -2})),
          SurfaceTension);

      // x-Temperature (TemperatureInterval returned instead)

      expect(
          Dimensions.determineQuantityType(Dimensions.fromMap(<String, int>{
            'Length': 1,
            'Mass': 1,
            'Time': -3,
            'Temperature': -1
          })),
          ThermalConductivity);

      // x-TimeInstant (Time returned instead)

      expect(
          Dimensions.determineQuantityType(Dimensions.fromMap(
              <String, int>{'Length': 2, 'Time': -2, 'Mass': 1, 'Angle': -1})),
          Torque);

      // x-Velocity (Speed)

      expect(
          Dimensions.determineQuantityType(
              Dimensions.fromMap(<String, int>{'Length': -3})),
          Volume);
      expect(
          Dimensions.determineQuantityType(
              Dimensions.fromMap(<String, int>{'Length': 3, 'Time': -1})),
          VolumeFlowRate);
      expect(
          Dimensions.determineQuantityType(
              Dimensions.fromMap(<String, int>{'Length': -1})),
          WaveNumber);

      // x-Work (Energy)
    });

    test('toQuantity', () {
      final d1 = Dimensions.fromMap(<String, int>{'Length': 1});
      final d2 = Dimensions.fromMap(<String, int>{'Length': 2});
      final d3 = Dimensions();
      final d4 = Dimensions.fromMap(<String, int>{'Length': 1, 'Time': -2});

      final q1 = d1.toQuantity();
      expect(q1, isNotNull);
      expect(q1 is Length, true);

      final q2 = d2.toQuantity();
      expect(q2, isNotNull);
      expect(q2 is Area, true);

      final q3 = d3.toQuantity();
      expect(q3, isNotNull);
      expect(q3 is Scalar, true);

      final q4 = d4.toQuantity();
      expect(q4, isNotNull);
      expect(q4 is Acceleration, true);
    });

    test('isScalar', () {
      expect(Length.lengthDimensions.isScalar, false);
      expect(Time.timeDimensions.isScalar, false);
      expect(Scalar.scalarDimensions.isScalar, true);
      expect(Angle.angleDimensions.isScalar, false);
      expect(SolidAngle.solidAngleDimensions.isScalar, false);
      expect(AngularSpeed.angularSpeedDimensions.isScalar, false);
      expect(Currency.currencyDimensions.isScalar, true);
      expect(Information.informationDimensions.isScalar, true);
    });

    test('isScalarSI', () {
      expect(Length.lengthDimensions.isScalarSI, false);
      expect(Time.timeDimensions.isScalarSI, false);
      expect(Scalar.scalarDimensions.isScalarSI, true);
      expect(Angle.angleDimensions.isScalarSI, true);
      expect(SolidAngle.solidAngleDimensions.isScalarSI, true);
      expect(AngularSpeed.angularSpeedDimensions.isScalarSI, false);
      expect(Currency.currencyDimensions.isScalarSI, true);
      expect(Information.informationDimensions.isScalarSI, true);
    });
  });
}
