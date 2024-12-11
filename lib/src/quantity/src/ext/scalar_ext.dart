import '../../../number/number/double.dart';
import '../../../number/number/precision.dart';
import '../si/types/scalar.dart';

/// The standard SI unit.
final ScalarUnits one = Scalar.one;

/// Synonymous with [Scalar.percent].
final ScalarUnits percent = Scalar.percent;

/// One trillionth (US: 10^-12) as a unit.
final ScalarUnits trillionthsUS =
    ScalarUnits('trillionths', null, null, 'trillionth', 1.0e-12, false);

/// One billionth (US: 10^-9) as a unit.
final ScalarUnits billionthsUS =
    ScalarUnits('billionths', null, null, 'billionth', 1.0e-9, false);

/// One millionth as a unit.
final ScalarUnits millionths =
    ScalarUnits('millionths', null, null, 'millionth', 1.0e-6, false);

/// One thousandth as a unit.
final ScalarUnits thousandths =
    ScalarUnits('thousandths', null, null, 'thousandth', 0.001, false);

/// One hundredth as a unit.
final ScalarUnits hundredths =
    ScalarUnits('hundredths', null, null, 'hundredth', 0.01, false);

/// One tenth as a unit.
final ScalarUnits tenths =
    ScalarUnits('tenths', null, null, 'tenth', 0.1, false);

/// A pair is 2.
final ScalarUnits pair = ScalarUnits('pairs', null, null, 'pair', 2.0, false);

/// A half-dozen is 6.
final ScalarUnits halfDozen =
    ScalarUnits('half dozen', null, null, 'half dozen', 6.0, false);

/// A dozen is 12.
final ScalarUnits dozen =
    ScalarUnits('dozen', null, null, 'dozen', 12.0, false);

/// A baker's dozen is 13.  One extra donut.  Thank you.
final ScalarUnits bakersDozen =
    ScalarUnits("baker's dozen", null, null, "baker's dozen", 13.0, false);

/// A score is 20.  Four score is 80.  More poetic than just saying eighty.
final ScalarUnits score =
    ScalarUnits('score', null, null, 'score', 20.0, false);

/// 100 as a unit.
final ScalarUnits hundred =
    ScalarUnits('hundred', null, null, 'hundred', 100.0, false);

/// A gross is 144.
final ScalarUnits gross =
    ScalarUnits('gross', null, null, 'gross', 144.0, false);

/// 1000 as a unit.
final ScalarUnits thousand =
    ScalarUnits('thousand', null, null, 'thousand', 1000.0, false);

/// A great gross is 1728.
final ScalarUnits greatGross =
    ScalarUnits('great gross', null, null, 'great gross', 1728.0, false);

/// A myriad is ten thousand.
final ScalarUnits myriad =
    ScalarUnits('myriad', null, null, 'myriad', 10000.0, false);

/// One million as a unit.
final ScalarUnits million =
    ScalarUnits('million', null, null, 'million', 1.0e6, false);

/// One billion (US: 10^9) as a unit.
final ScalarUnits billionUS =
    ScalarUnits('billion', null, null, 'billion', 1.0e9, false);

/// One trillion (US: 10^12) as a unit.
final ScalarUnits trillionUS =
    ScalarUnits('trillion', null, null, 'trillion', 1.0e12, false);

/// One quadrillion (US: 10^15) as a unit.
final ScalarUnits quadrillionUS =
    ScalarUnits('quadrillion', null, null, 'quadrillion', 1.0e15, false);

/// One quintillion (US: 10^18) as a unit.
final ScalarUnits quintillionUS =
    ScalarUnits('quintillion', null, null, 'quintillion', 1.0e18, false);

/// One sextillion (US: 10^21) as a unit.
final ScalarUnits sextillionUS =
    ScalarUnits('sextillion', null, null, 'sextillion', 1.0e21, false);

/// One septillion (US: 10^24) as a unit.
final ScalarUnits septillionUS =
    ScalarUnits('septillion', null, null, 'septillion', 1.0e24, false);

/// One octillion (US: 10^27) as a unit.
final ScalarUnits octillionUS =
    ScalarUnits('octillion', null, null, 'octillion', 1.0e27, false);

/// One nonillion (US: 10^30) as a unit.
final ScalarUnits nonillionUS =
    ScalarUnits('nonillion', null, null, 'nonillion', 1.0e30, false);

/// One decillion (US: 10^33) as a unit.
final ScalarUnits decillionUS =
    ScalarUnits('decillion', null, null, 'decillion', 1.0e33, false);

/// One duotrigintillion (10^99) as a unit.
final ScalarUnits duotrigintillion = ScalarUnits(
    'duotrigintillion', null, null, 'duotrigintillion', 1.0e99, false);

/// One googol (10^100) as a unit.
final ScalarUnits googols =
    ScalarUnits('googols', null, null, 'googol', 1.0e100, true);

// European variants.

/// The European variant of one billion (10^12) as a unit.
final ScalarUnits billionEur =
    ScalarUnits('billion (eur)', null, null, 'billion (eur)', 1.0e12, false);

/// The European variant of one trillion (10^18) as a unit.
final ScalarUnits trillionEur =
    ScalarUnits('trillion (eur)', null, null, 'trillion (eur)', 1.0e18, false);

/// The European variant of one quadrillion (10^24) as a unit.
final ScalarUnits quadrillionEur = ScalarUnits(
    'quadrillion (eur)', null, null, 'quadrillion (eur)', 1.0e24, false);

/// The European variant of one quintillion (10^30) as a unit.
final ScalarUnits quintillionEur = ScalarUnits(
    'quintillion (eur)', null, null, 'quintillion (eur)', 1.0e30, false);

/// The European variant of one sextillion (10^36) as a unit.
final ScalarUnits sextillionEur = ScalarUnits(
    'sextillion (eur)', null, null, 'sextillion (eur)', 1.0e36, false);

/// The European variant of one billion (10^42) as a unit.
final ScalarUnits septillionEur = ScalarUnits(
    'septillion (eur)', null, null, 'septillion (eur)', 1.0e42, false);

/// The European variant of one octillion (10^48) as a unit.
final ScalarUnits octillionEur = ScalarUnits(
    'octillion (eur)', null, null, 'octillion (eur)', 1.0e48, false);

/// The European variant of one nonillion (10^54) as a unit.
final ScalarUnits nonillionEur = ScalarUnits(
    'nonillion (eur)', null, null, 'nonillion (eur)', 1.0e54, false);

/// The European variant of one decillion (10^60) as a unit.
final ScalarUnits decillionEur = ScalarUnits(
    'decillion (eur)', null, null, 'decillion (eur)', 1.0e60, false);

// CONSTANTS.

/// Zero, as a Scalar.
const Scalar scalarZero = Scalar.constant(Double.zero);

/// A synonym for zero.
const Scalar naught = scalarZero;

/// A synonym for zero.
const Scalar zilch = scalarZero;

/// Fine structure constant (alpha).
const Scalar fineStructureConstant = Scalar.constant(
    Double.constant(7.2973525693e-3),
    uncert: 1.5073959899206537e-10);

/// Proton g factor (gp).
const Scalar protonGFactor = Scalar.constant(Double.constant(5.5856946893),
    uncert: 2.864460177289984e-10);

/// Electron g factor (ge).
const Scalar electronGFactor = Scalar.constant(
    Double.constant(-2.00231930436256),
    uncert: 1.7479729593448774e-13);

/// Neutron g factor (gn).
const Scalar neutronGFactor = Scalar.constant(Double.constant(-3.82608545),
    uncert: 2.3522736534804782e-7);

/// Muon g factor (gn).
const Scalar muonGFactor = Scalar.constant(Double.constant(-2.0023318418),
    uncert: 6.492430339775063e-10);

/// googol (10^100), arbitrary precision.
Scalar googol = Scalar(
    value: Precision.raw(<Digit>[Digit.one], power: 100, sigDigits: 101));

/// Sackur-Tetrode constant at 1 K and 100 kPa ('S0/R').
const Scalar sackurTetrode100kPa = Scalar.constant(
    Double.constant(-1.15170753706),
    uncert: 3.9072419474542043e-10);

/// Sackur-Tetrode constant at 1 K and 101.325 kPa ('S0/R').
const Scalar sackurTetrodeStdAtm = Scalar.constant(
    Double.constant(-1.16487052358),
    uncert: 3.863090282489196e-10);

/// Weak mixing angle.
const Scalar weakMixingAngle =
    Scalar.constant(Double.constant(0.22290), uncert: 0.0013458950201884253);
