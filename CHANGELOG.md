# 5.4.0

## Symbolic Calculus & Equation Solving

- **[FEATURE]** Added comprehensive symbolic calculus module (`lib/src/math/algebra/calculus/`)
  - `symbolic_calculus.dart`: Core symbolic calculus operations
  - `symbolic_integration.dart`: Advanced integration strategies (power rule, trig, exponential, substitution, integration by parts)
  - `differentiation.dart`: Enhanced differentiation with curl calculations and variable naming improvements
  - `hybrid_calculus.dart`: Combined symbolic and numerical calculus approaches
- **[FEATURE]** Implemented equation solver framework (`lib/src/math/algebra/solver/`)
  - `equation_solver.dart`: Polynomial solving, variable isolation, factor solving, and identity handling
  - Support for linear, quadratic, cubic equations
  - Recursive solving for factored equations (e.g., `(x-1)*(x-2) = 0`)
  - Power equation solving (e.g., `x^3 = 0`)
  - Identity equation detection (e.g., `x - x = 0`)
- **[FEATURE]** Added expression simplification framework (`lib/src/math/algebra/expression/simplifier/`)
  - `simplifier.dart`: Core simplification strategies
  - `trig_simplifier.dart`: Trigonometric simplification rules
- **[FEATURE]** Added inverse trigonometric functions
  - `asin.dart`: Inverse sine function
  - `acos.dart`: Inverse cosine function
  - `atan.dart`: Inverse tangent function
- **[FEATURE]** Added nonlinear mathematics modules (`lib/src/math/algebra/nonlinear/`)
  - `optimization.dart`: Optimization algorithms
  - `root_finding.dart`: Root finding methods
  - `systems.dart`: Nonlinear systems solving
- **[FEATURE]** Added differential equations module (`lib/src/math/differential_equations/`)
- **[FEATURE]** Added statistics module (`lib/src/math/statistics/`)

## Parser Enhancements

- **[FEATURE]** Enhanced expression parser with calculus operations
  - Added `diff(expr, var)` parsing for differentiation
  - Added `integrate(expr, var)` parsing for integration
  - Added `solve(eq, var)` parsing for equation solving
  - Added `solveEquations(equations)` parsing for system of equations
  - Added algebraic functions: `gcd(a, b)`, `lcm(a, b)`, `factor(poly)`, `deg(poly)`, `pfactor(n)`, `coeffs(poly, var)`, `line(p1, p2)`, `roots(poly)`, `sqcomp(poly)`
  - Improved simplification of parsed results

## Polynomial Algebra Enhancements

- **[FEATURE]** Polynomial modulo operator (`%`) for polynomial division remainder
- **[FEATURE]** Polynomial GCD and LCM methods
  - `gcd(other)`: Greatest Common Divisor using Euclidean algorithm
  - `lcm(other)`: Least Common Multiple
- **[FEATURE]** Added `Modulo` expression class for symbolic modulo operations
- **[FEATURE]** Implemented `isPoly([strict])` method across all expression types for polynomial detection
- **[BUG_FIX]** Fixed `Polynomial.simplify()` to correctly handle `Complex` coefficients by checking if coefficients are real before computing GCD

## Equation Solving Enhancements

- **[FEATURE]** System of equations solver (`solveEquations`)
  - Supports linear and simple non-linear systems
  - Uses substitution method for system solving
  - Returns solutions in `[var, val, var, val, ...]` format

## Symbolic Integration Enhancements

- **[FEATURE]** Added `InverseTrigStrategy` for inverse trigonometric integrals
  - Handles patterns like `1/(x^2 + a^2)` → `atan(x/a)`
  - Handles patterns like `1/sqrt(a^2 - x^2)` → `asin(x/a)`
- **[IMPROVEMENT]** Enhanced `BasicTrigStrategy` with trigonometric power reduction
  - Power reduction for `sin^2(x)`, `cos^2(x)`, etc.
- **[IMPROVEMENT]** Improved `IntegrationByPartsStrategy` to handle logarithmic and inverse trigonometric functions
- **[BUG_FIX]** Fixed `Cubic` equation solver robustness:
  - Added explicit check for triple roots (`d0=0`, `d1=0`) to prevent `NaN` results
  - Improved zero-check logic for intermediate values using magnitude thresholds
- **[BUG_FIX]** Fixed `IntegrationByParts` failure for solo functions (e.g., `ln(x)`, `asin(x)`) by treating them as `f(x) * 1`
- **[BUG_FIX]** Fixed `PowerRuleStrategy` to correctly handle `Complex` exponents safely avoiding type cast errors
- **[FEATURE]** Added logarithmic integration pattern (`u'/u`) to `SubstitutionStrategy` supporting forms like `integrate(1/(x+1))`
- **[BUG_FIX]** Fixed `integrate(cos(x)*sin(x))` sign error by improving `Divide.simplifyBasic`
- **[IMPROVEMENT]** Generalized linear substitution to handle implicit constant factors (e.g. `integrate((2x+1)^2)`)
- **[BUG_FIX]** Fixed `solve(x^3)` returning `NaN` by fixing `Complex.pow` for zero base

## Test Coverage Improvements

- **[IMPROVEMENT]** Enabled and fixed tests in `algebra_spec_test.dart`
  - Uncommented `isPoly` tests
  - Uncommented simplification and factorization tests
- **[IMPROVEMENT]** Enabled and adapted tests in `solve_spec_test.dart`
  - Uncommented `solveEquations` tests
  - Adapted test expectations for parser syntax
- **[IMPROVEMENT]** Fixed tests in `core_spec_test.dart`
  - Adjusted expectations for symbolic results (e.g., `11/4` instead of `2.75`)
  - Enabled hyperbolic function tests
- **[IMPROVEMENT]** Parser now handles complex nested expressions correctly

## Expression System Refactoring

- **[BREAKING]** Updated `differentiate()` signature to accept optional `Variable` parameter for partial differentiation support
  - Updated in all expression classes: `Add`, `Subtract`, `Multiply`, `Divide`, `Pow`, `Sin`, `Cos`, `Tan`, `Sec`, `Csc`, `Cot`, `Exp`, `Ln`, `Log`, `Abs`, and all other expression types
- **[IMPROVEMENT]** Refactored `simplify()` to `simplifyBasic()` in binary operations for better simplification control
  - Updated: `Add`, `Subtract`, `Multiply`, `Power`
- **[BUG_FIX]** Fixed `Add.simplifyBasic()` to correctly parse terms instead of creating invalid `Variable` objects
- **[BUG_FIX]** Fixed `Subtract.simplifyBasic()` to handle nested additions and parse terms correctly
- **[BUG_FIX]** Fixed `Multiply.simplifyBasic()` to implement associativity rules for coefficient combination (e.g., `(-1) * (2 * x)` → `(-2) * x`)
- **[IMPROVEMENT]** Enhanced `Subtract` to flatten nested subtractions and additions
- **[IMPROVEMENT]** Improved term parsing in algebraic operations
- **[FEATURE]** Enhanced `Expression` type conversion:
  - Added support for `String` inputs in `_toExpression` (automatic parsing)
  - Added support for `Complex` inputs in `_toExpression`
  - Enabled support for `NaN` and `Infinity` values in `Expression` operations
- **[BUG_FIX]** Fixed type safety in arithmetic operations (`Add`, `Subtract`, `Divide`) to handle mixed `num` and `Complex` types

## Rational Function Enhancements

- **[FEATURE]** Implemented `RationalFunction.simplify()` with polynomial division and GCD cancellation
- **[BUG_FIX]** Fixed `RationalFunction.evaluate()` to ensure correct simplification and type handling

## Polynomial Algebra Enhancements

- **[BUG_FIX]** Fixed `Polynomial.fromString` to correctly handle whitespace and division by constants (e.g., `x/2`)
- **[BUG_FIX]** Fixed `Polynomial.simplify` to prevent root casting errors during GCD calculation
- **[BUG_FIX]** Fixed `Polynomial.evaluate` to prevent nested `Literal` creation
- **[BUG_FIX]** Fixed coefficient extraction in polynomial solver for correct quadratic detection
- **[BUG_FIX]** Fixed identity equation handling (e.g., `solve(x-x, x)` now returns `[0]`)
- **[BUG_FIX]** Fixed cancellation detection in subtraction (e.g., `x - x = 0`)

- **[FEATURE]** Added comprehensive test suites
  - `test/parser_calculus_test.dart`: 100 tests for differentiation, integration, and solving
  - `test/calculus/`: Calculus module tests
  - `test/solver/`: Equation solver tests
  - `test/differential_equations/`: Differential equations tests
  - `test/statistics/`: Statistics tests
  - `test/nonlinear/`: Nonlinear mathematics tests
- **[FEATURE]** Added example: `example/symbolic_calculus_example.dart`
- **[IMPROVEMENT]** Enhanced `Limit` class with better limit calculation
- **[IMPROVEMENT]** Updated expression exports in `advance_math.dart` and `algebra.dart`
- **[IMPROVEMENT]** Code formatting improvements across multiple files
- **[REFACTOR]** Variable naming consistency (e.g., `F1, F2, F3` → `f1, f2, f3` in curl calculations)
- **[CLEANUP]** Removed `simple_export_test.dart`

## Complex Number Enhancements

- **[FEATURE]** Added reciprocal trigonometric functions to Complex (`trigonometric.dart`)
  - `sec()`: Secant function
  - `csc()`: Cosecant function
  - `cot()`: Cotangent function
- **[FEATURE]** Added inverse reciprocal trigonometric functions
  - `asec()`, `arcsec()`: Inverse secant
  - `acsc()`, `arccsc()`: Inverse cosecant
  - `acot()`, `arccot()`: Inverse cotangent
- **[FEATURE]** Added alias methods for inverse trig functions
  - `arcsin()`, `arccos()`, `arctan()`
- **[FEATURE]** Added reciprocal hyperbolic functions to Complex (`hyperbolic.dart`)
  - `sech()`: Hyperbolic secant
  - `csch()`: Hyperbolic cosecant
  - `coth()`: Hyperbolic cotangent
- **[FEATURE]** Added inverse reciprocal hyperbolic functions
  - `asech()`, `arcsech()`: Inverse hyperbolic secant
  - `acsch()`, `arccsch()`: Inverse hyperbolic cosecant
  - `acoth()`, `arccoth()`: Inverse hyperbolic cotangent
- **[FEATURE]** Added alias methods for inverse hyperbolic functions
  - `arcsinh()`, `arccosh()`, `arctanh()`
- **[FEATURE]** Added logarithmic functions to Complex (`operations.dart`)
  - `log10()`: Base-10 logarithm
  - `log2()`: Base-2 logarithm
  - `logBase(n)`: Arbitrary base logarithm
- **[FEATURE]** Added special mathematical functions (`special_functions.dart` - NEW FILE)
  - `gamma()`: Gamma function using Lanczos approximation
  - `lnGamma()`: Natural logarithm of gamma function
  - `digamma()`: Digamma (psi) function
  - `erf()`: Error function with Taylor series expansion
  - `erfc()`: Complementary error function
  - `beta()`: Beta function
  - `zeta()`: Riemann Zeta function
- **[FEATURE]** Added precision functions
  - `expm1()`: `e^x - 1` for small `x`
  - `log1p()`: `ln(1 + x)` for small `x`
- **[FEATURE]** Added floating-point utilities
  - `frexp()`: Mantissa and exponent decomposition
  - `ldexp()`: Recompose double from mantissa and exponent
- **[FEATURE]** Added static utility methods for collections of Complex numbers
  - `Complex.sum(List<Complex>)`: Sum of complex numbers
  - `Complex.mean(List<Complex>)`: Arithmetic mean
  - `Complex.product(List<Complex>)`: Product of complex numbers

## Geometry Enhancements

### Plane Geometry

- **[FEATURE]** Added geometric centers to `Triangle` class
  - `centroid`: Intersection of medians (center of mass)
  - `inCenter`: Intersection of angle bisectors (center of inscribed circle)
  - `circumCenter`: Intersection of perpendicular bisectors (center of circumscribed circle)
  - `orthocenter`: Intersection of altitudes
- **[BUG_FIX]** Fixed `Polygon` class to extend `PlaneGeometry` correctly
  - Implemented `area()` method using Shoelace formula for arbitrary polygons
  - Implemented `perimeter()` method override
- **[FEATURE]** Enhanced regular polygon classes (`Pentagon`, `Hexagon`, `Heptagon`, `Octagon`)
  - Added `apothem` property (distance from center to midpoint of side)
  - Added `sumInteriorAngles` property
  - Added `shortDiagonal` property to `Pentagon`
- **[FEATURE]** Added `boundingBox()` method to circle components
  - `Sector`: Includes center, arc endpoints, and arc extremes
  - `Segment`: Includes chord endpoints and arc extremes
  - `Arc`: Includes endpoints and arc extremes
- **[IMPROVEMENT]** Refactored `Sector`, `Segment`, and `Arc` classes
  - Encapsulated fields with private accessors and validation
  - Optimized `contains(Point)` method in `Sector` for better performance
- **[REFACTOR]** Merged `ErrorEllipse` implementation
  - Consolidated fields to support both covariance matrix (`sigmaX2`, `sigmaY2`, `sigmaXY`) and standard deviation (`sigmaX`, `sigmaY`, `rho`)
  - Added `generateEllipsePoints()` for plotting
  - Added `toJson()`/`fromJson()` serialization
  - Added dynamic `updateParameters()` method
  - Restored `PlaneGeometry` inheritance and `contains()` logic

### Solid Geometry

- **[FEATURE]** Implemented `Sphere` class (`lib/src/math/geometry/solid/sphere.dart`)
  - Volume: `(4/3)πr³`
  - Surface Area: `4πr²`
  - Named constructors: `fromVolume()`, `fromSurfaceArea()`
  - `contains(Point)` method to check if point is inside sphere
- **[FEATURE]** Implemented `Cylinder` class (`lib/src/math/geometry/solid/cylinder.dart`)
  - Volume: `πr²h`
  - Surface Area: `2πr(r + h)`
  - Lateral Surface Area: `2πrh`
  - Named constructor: `fromVolumeAndRadius()`
- **[FEATURE]** Implemented `Cone` class (`lib/src/math/geometry/solid/cone.dart`)
  - Volume: `(1/3)πr²h`
  - Surface Area: `πr(r + s)` where `s` is slant height
  - Slant Height: `√(r² + h²)`
  - Lateral Surface Area: `πrs`
- **[FEATURE]** Implemented `RectangularPrism` class (`lib/src/math/geometry/solid/rectangular_prism.dart`)
  - Volume: `l × w × h`
  - Surface Area: `2(lw + lh + wh)`
  - Space Diagonal: `√(l² + w² + h²)`
  - `vertices()` method returns 8 corner points
  - Factory constructor: `RectangularPrism.cube(side)` for creating cubes
- **[FEATURE]** Created example: `example/solid_geometry_example.dart`

## Statistics & Basic Math Refactoring

- **[FEATURE]** Refactored core statistics functions to `VarArgsFunction` allowing flexible usage (e.g., `mean(1, 2, 3)` vs `mean([1, 2, 3])`)
  - `mean`, `median`, `mode`, `variance`, `standardDeviation`
  - `gcd`, `lcm`
- **[FEATURE]** Refactored `max` and `min` in `basic.dart` to `VarArgsFunction`
- **[IMPROVEMENT]** Optimized `SVD` decomposition to use `dart:math` for `max`/`min` operations for better performance and type safety

## Expression Context Enhancements

- **[FEATURE]** Added missing basic math functions to default expression context (`utils.dart`)
  - `sinc`, `sumUpTo`, `isClose`, `integerPart`, `fibRange`
- **[FEATURE]** Added calculus helpers to expressions
  - `diff()`: Numerical differentiation
  - `simpson()`, `numIntegrate()`: Numerical integration
- **[FEATURE]** Added robust random number generation to expressions
  - `rand([min, max])`
  - `randint(max)`
- **[FEATURE]** Flattened and exposed constants in expressions
  - Angle constants: `halfPi`, `quarterPi`, `deg2rad`, `rad2deg`
  - Physics constants: `c`, `G`, `g`, `h_planck`, etc.
- **[BUG_FIX]** Fixed `CallExpression` to correctly handle `VarArgsFunction` invocations
- **[BUG_FIX]** Fixed `IndexExpression` and `BinaryExpression` type handling failures

# 5.3.8

- **[IMPROVEMENT]** Updated dependencies
- **[REFACTOR]** Simplify conditional logic and improve readability in `Scientific` class
- **[STYLE]** Format code for consistency in `num` extension and tests
- **[IMPROVEMENT]** Fixed documentation comments in `AngleUnits`, `NumWords`, and `Units` classes
- **[FEATURE]** Implemented methods in `MultiVariablePolynomial`: `depth`, `size`, `getVariableTerms`, `simplify`, `expand`, `differentiate`, `integrate`, `isIndeterminate`, and `isInfinity`

# 5.3.7

- **[IMPROVEMENT]** Updated dependencies
- **[IMPROVEMENT]** Clean code

# 5.3.6

- **[FEATURE]** Added some large value computations
- **[IMPROVEMENT]** Updated dependencies
- **[IMPROVEMENT]** Clean code

# 5.3.5

- **[FEATURE]** Add num to expression conversion extension
- **[FEATURE]** Add NumToExpressionExtension with toExpression() and operator overloads
- **[FEATURE]** Create global helper function ex() for concise expression creation
- **[IMPROVEMENT]** Add unit tests for all new functionality
- **[IMPROVEMENT]** Update examples to demonstrate new expression creation methods
- **[IMPROVEMENT]** Add documentation for enhanced expression creation approaches
- **[FEATURE]** Extend Inverse Hyperbolic Functions to Support Complex Numbers (`asinh`, `acosh`, `atanh`, `asech`, `acsch`, and `acoth`) to support `Complex` number inputs.

# 5.3.4

- **[FEATURE]** Changed to MIT License

# 5.3.3

- **[BUG_FIX]** Fixed error from `Package conflict after update` as from issues [#8](https://github.com/gameticharles/advance_math/issues/8)
- **[IMPROVEMENT]** Clean code

# 5.3.2

- **[IMPROVEMENT]** Added detailed documentations
- **[IMPROVEMENT]** Updated packages
- **[IMPROVEMENT]** Clean code

# 5.3.1

- **[IMPROVEMENT]** Improved Imaginary

# 5.3.0

- **[FEATURE]** Added `isClose` similar to that of Python
- **[IMPROVEMENT]** Enhanced Complex number
- **[IMPROVEMENT]** Improved Decimal and Rational Numbers
- **[BUG_FIX]** Fix bugs and matrices
- **[FEATURE]** Added `memoize` class wrapper (see examples from `var_args_function_test.dart` )
- **[FEATURE]** Added more functions including: `sumUpTo`, `timeAsync`, `time` etc.

# 5.2.0

- **[FEATURE]** Added `isClose` similar to that of Python
- **[FEATURE]** Added conversion of `Complex` to `num`
- **[FEATURE]** Added more functions to `Complex`
- **[BREAKING]** Remove the FileIO form the library as it is the same from [DartFrame](https://pub.dev/packages/dartframe).
- **[IMPROVEMENT]** Enhanced Complex number integration throughout the library
- **[FEATURE]** Added `simplify()` method to return appropriate data types from mathematical operations
- **[IMPROVEMENT]** Updated mathematical functions to work with Complex numbers:
  - `round()` - Now supports rounding both real and imaginary parts
  - `hypot()` - Enhanced to work with Complex inputs
  - `sign()` - Added support for Complex numbers
  - `clamp()` - Now clamps both real and imaginary parts of Complex numbers
  - `lerp()` - Added support for linear interpolation between Complex numbers
- **[BUG_FIX]** Fixed test cases for Roman numerals
- **[IMPROVEMENT]** `SVD` and `LU` algorithms
- **[IMPROVEMENT]** Standardized error handling across mathematical functions
- **[IMPROVEMENT]** Improved documentation with examples for Complex number operations

# 5.1.0

- **[BUG_FIX]** Fixed error from `svd` as from issues [#3](https://github.com/gameticharles/advance_math/issues/3)
- **[IMPROVEMENT]** Changed the default PI computation to use
- **[IMPROVEMENT]** Changed the entire `Matrix` class and `Vector` class to use `Complex` for all operations.

# 5.0.0

- **[IMPROVEMENT]** `pseudoInverse` function has been improved to work with singular and poorly conditioned matrices. Added condition number check and SVD fallback for improved robustness with singular and poorly conditioned matrices.
- **[BUG_FIX]** `isPrime` function now works correctly.
- **[FEATURE]** Added extensions to `Bases` class for converting between bases and `Strings`.
- **[FEATURE]** Added a class for `PerfectNumbers` and functions for calculating perfect numbers including `isMersennePrime`.
- **[IMPROVEMENT]** Improved `isPerfectNumber` function for performance and to work with large numbers with `BigInt`, large `String` number, and int support.
- **[FEATURE]** Added `sqrt` to the `BigInt` class to aid computations.
- **[IMPROVEMENT]** Fixed the error with `cumsum` and improved it with functionalities
- **[IMPROVEMENT]** Improve the computation of `fib` function.
- **[FEATURE]** Added `Expression` class for parsing and evaluating mathematical expressions. See `Expression` class for more information.

# 4.0.2

- **[BUG_FIX]** Changed the characters dependency to 1.3.0

# 4.0.1

- **[IMPROVEMENT]** Fixed change log
- **[IMPROVEMENT]** Updated SDK to 3.6.0

# 4.0.0

- **[BROKEN]** DataFrame is no longer maintained in `advance_math`. Now has a separate package for DataFrame called `dartframe`.
- **[FEATURE]** Added `PI` class for calculating pi to any precision.
- **[FEATURE]** Added `Decimal` and `Rational` classes to support arbitrary precision calculations.
- **[BROKEN]** Old `Decimal` class based on `Number` has been changed to `Precision` class. See `Precision` class for more information.
- **[FEATURE]** Added `Decimal` and `Rational` class based on `BigInt` with support for arbitrary precision calculations.
- **[FEATURE]** Added bases to `advance math`. You can now convert from any base to any other base (i.e base 2-36). See `Bases` class for more information.
- **[IMPROVEMENT]** Matrix inverse has been improved to work with matrices of any size (e.g. 1x1 matrix).

- **[IMPROVEMENT]** Added `Dataframe` empty initializer/constructor.
- **[FEATURE]** Converted `Dataframe` columns to a class `Series`
- **[FEATURE]** Added more functionalities to the `Random` class eg: nextIntInRange, nextDoubleInRange, nextBytes, nextBigIntInRange, nextBigInt, nextDateTime, nextElementFromList, nextNonRepeatingIntList etc.
- **[IMPROVEMENT]** `isPrime` function has been improved to use the trial division method for small numbers and Rabin-Miller for large numbers. Now support various data types:

  ```dart
  print(isPrime(5)); // Output: true (int)
  print(isPrime(6)); // Output: false (int)
  print(isPrime(BigInt.from(1433))); // Output: true (BigInt)
  print(isPrime('567887653')); // Output: true (String)
  print(isPrime('75611592179197710042')); // Output: false (String)
  print(isPrime('205561530235962095930138512256047424384916810786171737181163')); // Output: true (String)
  ```

- **[FEATURE]** Added more basic math functions: `mod`, `modInv`, nChooseRModPrime, bigIntNChooseRModPrime etc.
- **[FEATURE]** Added more statistics math functions: `gcf`, `egcd`, `lcm` etc.
- **[IMPROVEMENT]** In the `Geometry` class:
  - The class is splitted into Plane and Solid geometries.
  - In Point class: fixed example function calling, isCollinear computation is moved into GeoUtils, and use `rec` in the constructor fromPolarCoordinates.
- **[IMPROVEMENT]** Added an argument `isDegrees` for `rec` and `pol` easy computation.
- **[IMPROVEMENT]** Roman numerals to work with overline characters and parentheses.
- **[FEATURE]** Added converts polar coordinate `rec` and converts rectangular coordinates`pol` functions
- **[FEATURE]** Added an extension `groupBy` to the iterables and `groupByKey` to maps.
- **[FEATURE]** Added more extensions to String class:

  ```dart
  String testString = "Hello123World456! Café au lait costs 3.50€. Contact: test@example.com or visit https://example.com";

  print(testString.extractLetters()); // Includes 'é'
  print(testString.extractNumbers(excludeDecimalsAndSymbols: false));
  print(testString.extractWords(excludeNumbers: false));
  print(testString.extractAlphanumeric(excludeSymbols: false));

  print(testString.extractLettersList(excludeSymbols: false));
  print(testString.extractNumbersList(excludeDecimalsAndSymbols: false));
  print(testString.extractEmails()); // Extracts email addresses
  print(testString.extractUrls()); // Extracts URLs
  print(testString.containsSymbol()) //Check if the string contains a symbol

  // Custom pattern example: extract words starting with 'C'
  print(testString.extractCustomPattern(r'\bC\w+', unicode: false));

  ```

- **[IMPROVEMENT]** Following the Dart format for libraries
- **[IMPROVEMENT]** Cleaned code base and examples files
- **[IMPROVEMENT]** Fixed README

# 3.3.8

- **[BUG_FIX]** CoordinateType not set to UTM
- **[BUG_FIX]** Change the data types of mean and correlation to num
- **[BROKEN]** `NumOrWords` has been moved into code translators with the same name as Morse code.
- **[BROKEN]** `MorseCodeTranslator` class has been renamed to `MorseCode`
- **[FEATURE]** Added `Dataframe` class for working with dataframes or tables.
- **[IMPROVEMENT]** Removed duplicate functions
- **[IMPROVEMENT]** Enhanced `combinations` and `permutations` function:
  - The function now generates the actual combinations or permutations of elements, mimicking the behavior of the combinations function in R.
  - Added support for Lists as input for `n`.
  - Introduced optional `func` and simplify parameters for applying functions to combinations or permutations and controlling output structure.
  - Improved documentation with clearer explanations, examples, and comments.
- **[IMPROVEMENT]** Cleaned code for expressions (symbolic math)
- **[IMPROVEMENT]** Added doc-strings to some functions
- **[IMPROVEMENT]** Added documentation of Morse code in the ReadMe file
- **[IMPROVEMENT]** Fixed README

# 3.3.7

- Fixed README
- Added functions

# 3.3.6

- Fixed bugs
- Renamed Row, Column, and Diagonal matrices to RowMatrix, ColumnMatrix and DiagonalMatrix repectively

# 3.3.5

- Added morse code
- Added more math functions
- Improved documentation and performance
- Fixed bugs and aligned code

# 3.3.4

- Added support for converting number to words
- Added test for roman numerals.
- Fixed bugs in Roman numerals
- Added some string extension (e.g. capitalization, removeSpecialCharacters etc)

# 3.3.3

- Setting support for expressions
- Fixed errors in pow for both real and Complex numbers

# 3.3.2

- Added some math constants
- Fixed error in angles
- Fixed error in parsing linear and constant polynomial strings
- Increased the SDK

# 3.3.1

- Added Interpolation

# 3.3.0

- Added ZScore computation
- Added more functions matrix statistics
- Added multiple supports for determinant
- Fixed bugs in Roman numerals
- Fixed documentation inconsistencies

# 3.2.4

- Fixed error in angles

# 3.2.3

- Fixed error in angles conversion

# 3.2.2

- Improved the checks on roman numerals
- Added conversion between roman numerals and dates
- Improved the flexibility in arithmetic with integer, roman strings and roman numbers
- Fixed README file

# 3.2.1

- Improved the checks on roman numerals

# 3.2.0

- Added roman numerals
- Added trigonometry functions supports to work with complex numbers
- Added limit
- Added factors
- Fixed README file

# 3.1.0

- Simplified Example file
- Improved exponents of Complex numbers
- Fixed bearingTo() in Point to include axis
- Fixed return type of normalize from Angle
- Fixed README file

# 3.0.0

- Added Geometry (Point, line, Circle, Triangle, Polygon, etc.)
- Added Polynomial (Linear, Quadratic, Cubic, Quartic, Durand-Kerner)
- Added List and vecctors having same properties
- Added NumPy's roll
- Fixed README file

# 2.1.2

- Fixed complex number outputing wrong string

# 2.1.1

- Fixed bugs

# 2.1.0

- Added arguments for diagonal
- Improved min, max and sum functions with axes
- Fixed bug with magic matrix not working for singly even numbers (6, 10, 14, 18, 22 etc).
- Fixed bugs

# 2.0.2

- Changed the reverse function to flip in matrices
- Added magic() to the Maatrix constructors
- Fixed bug in FileIO

# 2.0.1

- Fixed bug

# 2.0.0

- Fixed the usage of quantities in the respective computations
- Implemented support for quantity
- Fixed Web not supported
- Fixed range
- Fixed README

# 1.0.3

- Fixed bugs
- Fixed README

# 1.0.2

- Conversion of angles(radians, degrees, gradients, DMS, and DM)
- Organized code
- Fixed bugs
- Fixed README

# 1.0.0

- Moved codes and reorganized functions
- Fixed bugs

# 0.1.8

- Fixed bugs (in null space)

# 0.1.7

- Added rescale for both vectors and matrix
- Improved vector compatibility with lists
- Added operations on vectors such as expo, sum, prod, etc.
- Fixed normalize function with options on the norm to use
- Fixed Norm with options
- Fixed bugs

# 0.1.5

- Added support for distance calculation for vectors and matrices
- Improved consistency in linear algebra
- Added scale for vector types

# 0.1.4

- Spercial matrices and vectors their functionalities
- Fixed spellings in matrix structure properties
- Added functions partioning of vectors subVector() and getVector()
- Improved subMatrix() function
- Fixed README

# 0.1.2

- Fixed spellings in matrix structure properties
- Added Vectors, Complex Numbers, and Complex Vectors to README
- Fixed README

# 0.1.1

- Fixed README

# 0.1.0

- Improved indexOf() and random functionalities
- Fixed README
- Fixed bugs

# 0.0.9

- Started benchmarking
- Implemented matrix form rows and columns
- Implemented Vectors, Complex nyumbers and Complex Vectors
- Improved copyFrom() to retain or resize matrices
- Improved matrix concatenate
- Fixed README
- Corrected anonotations
- Fixed bugs

# 0.0.8

- Added Exponential, logarithmic, and Matrix power (generalized, not just integer powers)
- Added support to create from flattened arrays
- Clean codes
- Fixed bugs

# 0.0.7

- Fixed matrix round
- Fixed corrected README
- Fixed bugs

# 0.0.6

- Added matrix broadcast and replicate matrix
- Added pseudoInverse of a matrix
- Fixed corrected README
- Fixed bugs

# 0.0.5

- Added linear equation solver (cramersRule, ridgeRegression, bareissAlgorithm, inverseMatrix, gaussElimination, gaussJordanElimination, leastSquares, etc.)
- Added function to compute matrix condition number with both SVD and norm2 approaches.
- Added matrix decompositions
  - - LU decompositions
    - - Crout's algorithm
    - - Doolittle algorithm
    - - Doolittle algorithm with Partial Pivoting
    - - Doolittle algorithm with Complete Pivoting
    - - Gauss Elimination Method
  - - QR decompositions
    - - QR decomposition Gram Schmidt
    - - QR decomposition Householder
  - - LQ decomposition
  - - Cholesky Decomposition
  - - Eigenvalue Decomposition (incomplete)
  - - Singular Value Decomposition
  - - Schur Decomposition
- Added matrix condition
- Added support for exponential, logarithmic, and trigonometric functions on matrices
- Added more matrix operations like scale,norm, norm2, l2Norms,
- Added support for checking matrix properties.
- Added class for Complex numbers
- Added support for to auto detect matrix types.
- Added scaleRow and addRow operations.
- Implemented new constructors like tridiagonal matrix
- Modified the Matrix.diagonal() to accept super-diagonal, diagonal, minor diagonals.
- Implemented Iterator and Iterable interfaces for easy traversal of matrix elements
- Provide methods to import and export matrices to and from other formats (e.g., CSV, JSON, binary)
- Fixed bugs

# 0.0.3

- Improved the arithmetic (+, -, \*) functions to work for both scalars and matrices
- Updated range to create row and column matrices
- Added updateRow(), updateColumn, insertRow, insertColumn, appendRows, appendColumns
- Added creating random matrix
- Added more looks and feel to the toString() method
- Corrected some wrong calculations
- Fixed bugs
- Fix README file

# 0.0.2

- Added info on the README file.
- Added more functionalities
- Fixed bugs
- Tests now works with most of the functions

# 0.0.1

- initial release.
