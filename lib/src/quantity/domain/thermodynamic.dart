/// Quantity types, units and constants commonly encountered in the field of
/// thermodynamics and related sciences.
library thermodynamic;

import '../quantity.dart';

export '../quantity.dart'
    show
        unifiedAtomicMassUnits,
        boltzmannUnit,
        boltzmannConstant,
        sackurTetrode100kPa,
        sackurTetrodeStdAtm,
        Entropy,
        EntropyUnits,
        MiscQuantity,
        MassUnits,
        Scalar;

// CONSTANTS

/// Avogadro's Number ('NA' or 'L')
const MiscQuantity avogadro = MiscQuantity.constant(
    Double.constant(6.02214076e23),
    Dimensions.constant(<String, int>{'Amount': -1}));

/// The common symbol for Avogadro's Number.
// ignore: constant_identifier_names
const MiscQuantity NA = avogadro;

/// An alternative symbol for Avogadro's Number.
// ignore: constant_identifier_names
const MiscQuantity L = avogadro;

/// Boltzmann constant ('k')
Entropy k = boltzmannConstant;

/// Faraday constant ('F')
const MiscQuantity faradayConstant = MiscQuantity.constant(
    Double.constant(96485.332122222222),
    Dimensions.constant(<String, int>{'Current': 1, 'Time': 1, 'Amount': -1}));

/// First Radiation Constant ('c1')
const MiscQuantity firstRadiationConstant = MiscQuantity.constant(
    Double.constant(3.7417718522222222e-16),
    Dimensions.constant(<String, int>{'Length': 3, 'Mass': 1, 'Time': -3}));

/// Locshmidt Constant ('n0') at 273.15 K and 101.325 kPa
const MiscQuantity loschmidtStdAtm = MiscQuantity.constant(
    Double.constant(2.6867801111111111e25),
    Dimensions.constant(<String, int>{'Length': -3}));

/// Molar Gas Constant ('R')
const MolarEntropy gasConstantMolar =
    MolarEntropy.constant(Double.constant(8.3144626188888888));

/// Molar Planck Constant ('Nah')
const MiscQuantity molarPlanck = MiscQuantity.constant(
    Double.constant(3.9903127122222222e-10),
    Dimensions.constant(
        <String, int>{'Length': 2, 'Mass': 1, 'Time': -1, 'Amount': 1}));

/// Molar Volume of Ideal Gas at 273.15 K and 100 kPa ('Vm')
const MiscQuantity molarVolume100kPa = MiscQuantity.constant(
    Double.constant(22.710954644444444e-3),
    Dimensions.constant(<String, int>{'Length': 3, 'Amount': -1}));

/// Molar Volume of Ideal Gas at 273.15 K and 101.325 kPa ('Vm')
const MiscQuantity molarVolumeStdAtm = MiscQuantity.constant(
    Double.constant(22.413969544444444e-3),
    Dimensions.constant(<String, int>{'Length': 3, 'Amount': -1}));

/// Second Radiation Constant ('c2')
const MiscQuantity secondRadiationConstant = MiscQuantity.constant(
    Double.constant(1.4387768777777777e-2),
    Dimensions.constant(<String, int>{'Length': 1, 'Temperature': 1}));

/// Stefan-Boltzmann constant (sigma)
const MiscQuantity stefanBoltzmann = MiscQuantity.constant(
    Double.constant(5.6703744199999999e-8),
    Dimensions.constant(
        <String, int>{'Mass': 1, 'Time': -3, 'Temperature': -4}));

/// Wien Displacement Law Constant ('b')
const MiscQuantity wienDisplacement = MiscQuantity.constant(
    Double.constant(2.8977719555555555e-3),
    Dimensions.constant(<String, int>{'Length': 1, 'Temperature': 1}));
