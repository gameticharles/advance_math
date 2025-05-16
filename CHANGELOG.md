# 5.3.2

* **[IMPROVEMENT]** Clean code

# 5.3.1

* **[IMPROVEMENT]** Improved Imaginary

# 5.3.0

* **[FEATURE]** Added `isClose` similar to that of Python
* **[IMPROVEMENT]** Enhanced Complex number
* **[IMPROVEMENT]** Improved Decimal and Rational Numbers
* **[BUG_FIX]** Fix bugs and matrices
* **[FEATURE]** Added `memoize` class wrapper (see examples from `var_args_function_test.dart` )
* **[FEATURE]** Added more functions including: `sumUpTo`, `timeAsync`, `time` etc.

# 5.2.0

* **[FEATURE]** Added `isClose` similar to that of Python
* **[FEATURE]** Added conversion of `Complex` to `num`
* **[FEATURE]** Added more functions to `Complex`
* **[BREAKING]** Remove the FileIO form the library as it is the same from [DartFrame](https://pub.dev/packages/dartframe).
* **[IMPROVEMENT]** Enhanced Complex number integration throughout the library
* **[FEATURE]** Added `simplify()` method to return appropriate data types from mathematical operations
* **[IMPROVEMENT]** Updated mathematical functions to work with Complex numbers:
  * `round()` - Now supports rounding both real and imaginary parts
  * `hypot()` - Enhanced to work with Complex inputs
  * `sign()` - Added support for Complex numbers
  * `clamp()` - Now clamps both real and imaginary parts of Complex numbers
  * `lerp()` - Added support for linear interpolation between Complex numbers
* **[BUG_FIX]** Fixed test cases for Roman numerals
* **[IMPROVEMENT]** `SVD` and `LU` algorithms
* **[IMPROVEMENT]** Standardized error handling across mathematical functions
* **[IMPROVEMENT]** Improved documentation with examples for Complex number operations

# 5.1.0

* **[BUG_FIX]** Fixed error from `svd` as from issues [#3](https://github.com/gameticharles/advance_math/issues/3)
* **[IMPROVEMENT]** Changed the default PI computation to use
* **[IMPROVEMENT]** Changed the entire `Matrix` class and `Vector` class to use `Complex` for all operations.

# 5.0.0

* **[IMPROVEMENT]** `pseudoInverse` function has been improved to work with singular and poorly conditioned matrices. Added condition number check and SVD fallback for improved robustness with singular and poorly conditioned matrices.
* **[BUG_FIX]** `isPrime` function now works correctly.
* **[FEATURE]** Added extensions to `Bases` class for converting between bases and `Strings`.
* **[FEATURE]** Added a class for `PerfectNumbers` and functions for calculating perfect numbers including `isMersennePrime`.
* **[IMPROVEMENT]** Improved `isPerfectNumber` function for performance and to work with large numbers with `BigInt`, large `String` number, and int support.
* **[FEATURE]** Added `sqrt` to the `BigInt` class to aid computations.
* **[IMPROVEMENT]** Fixed the error with `cumsum` and improved it with functionalities
* **[IMPROVEMENT]** Improve the computation of `fib` function.
* **[FEATURE]** Added `Expression` class for parsing and evaluating mathematical expressions. See `Expression` class for more information.

# 4.0.2

* **[BUG_FIX]** Changed the characters dependency to 1.3.0

# 4.0.1

* **[IMPROVEMENT]** Fixed change log
* **[IMPROVEMENT]** Updated SDK to 3.6.0

# 4.0.0

* **[BROKEN]** DataFrame is no longer maintained in `advance_math`. Now has a separate package for DataFrame called `dartframe`.
* **[FEATURE]** Added `PI` class for calculating pi to any precision.
* **[FEATURE]** Added `Decimal` and `Rational` classes to support arbitrary precision calculations.
* **[BROKEN]** Old `Decimal` class based on `Number` has been changed to `Precision` class. See `Precision` class for more information.
* **[FEATURE]** Added `Decimal` and `Rational` class based on `BigInt` with support for arbitrary precision calculations.
* **[FEATURE]** Added bases to `advance math`. You can now convert from any base to any other base (i.e base 2-36). See `Bases` class for more information.
* **[IMPROVEMENT]** Matrix inverse has been improved to work with matrices of any size (e.g. 1x1 matrix).

* **[IMPROVEMENT]** Added `Dataframe` empty initializer/constructor.
* **[FEATURE]** Converted `Dataframe` columns to a class `Series`
* **[FEATURE]** Added more functionalities to the `Random` class eg: nextIntInRange, nextDoubleInRange, nextBytes, nextBigIntInRange, nextBigInt, nextDateTime, nextElementFromList, nextNonRepeatingIntList etc.
* **[IMPROVEMENT]** `isPrime` function has been improved to use the trial division method for small numbers and Rabin-Miller for large numbers. Now support various data types:

  ```dart
  print(isPrime(5)); // Output: true (int)
  print(isPrime(6)); // Output: false (int)
  print(isPrime(BigInt.from(1433))); // Output: true (BigInt)
  print(isPrime('567887653')); // Output: true (String)
  print(isPrime('75611592179197710042')); // Output: false (String)
  print(isPrime('205561530235962095930138512256047424384916810786171737181163')); // Output: true (String)
  ```

* **[FEATURE]** Added more basic math functions: `mod`, `modInv`, nChooseRModPrime, bigIntNChooseRModPrime etc.
* **[FEATURE]** Added more statistics math functions: `gcf`, `egcd`, `lcm` etc.
* **[IMPROVEMENT]** In the `Geometry` class:
  * The class is splitted into Plane and Solid geometries.
  * In Point class: fixed example function calling, isCollinear computation is moved into GeoUtils, and use `rec` in the constructor fromPolarCoordinates.
* **[IMPROVEMENT]** Added an argument `isDegrees` for `rec` and `pol` easy computation.
* **[IMPROVEMENT]** Roman numerals to work with overline characters and parentheses.
* **[FEATURE]** Added converts polar coordinate `rec` and converts rectangular coordinates`pol` functions
* **[FEATURE]** Added an extension `groupBy` to the iterables and `groupByKey` to maps.
* **[FEATURE]** Added more extensions to String class:
  
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

* **[IMPROVEMENT]** Following the Dart format for libraries
* **[IMPROVEMENT]** Cleaned code base and examples files
* **[IMPROVEMENT]** Fixed README

# 3.3.8

* **[BUG_FIX]** CoordinateType not set to UTM
* **[BUG_FIX]** Change the data types of mean and correlation to num
* **[BROKEN]** `NumOrWords` has been moved into code translators with the same name as Morse code.
* **[BROKEN]** `MorseCodeTranslator` class has been renamed to `MorseCode`
* **[FEATURE]** Added `Dataframe` class for working with dataframes or tables.
* **[IMPROVEMENT]** Removed duplicate functions
* **[IMPROVEMENT]** Enhanced `combinations` and `permutations` function:
  * The function now generates the actual combinations or permutations of elements, mimicking the behavior of the combinations function in R.
  * Added support for Lists as input for `n`.
  * Introduced optional `func` and simplify parameters for applying functions to combinations or permutations and controlling output structure.
  * Improved documentation with clearer explanations, examples, and comments.
* **[IMPROVEMENT]** Cleaned code for expressions (symbolic math)
* **[IMPROVEMENT]** Added doc-strings to some functions
* **[IMPROVEMENT]** Added documentation of Morse code in the ReadMe file
* **[IMPROVEMENT]** Fixed README

# 3.3.7

* Fixed README
* Added functions

# 3.3.6

* Fixed bugs
* Renamed Row, Column, and Diagonal matrices to RowMatrix, ColumnMatrix and DiagonalMatrix repectively

# 3.3.5

* Added morse code
* Added more math functions
* Improved documentation and performance
* Fixed bugs and aligned code

# 3.3.4

* Added support for converting number to words
* Added test for roman numerals.
* Fixed bugs in Roman numerals
* Added some string extension (e.g. capitalization, removeSpecialCharacters etc)

# 3.3.3

* Setting support for expressions
* Fixed errors in pow for both real and Complex numbers

# 3.3.2

* Added some math constants
* Fixed error in angles
* Fixed error in parsing linear and constant polynomial strings
* Increased the SDK

# 3.3.1

* Added Interpolation

# 3.3.0

* Added ZScore computation
* Added more functions matrix statistics
* Added multiple supports for determinant
* Fixed bugs in Roman numerals
* Fixed documentation inconsistencies

# 3.2.4

* Fixed error in angles

# 3.2.3

* Fixed error in angles conversion

# 3.2.2

* Improved the checks on roman numerals
* Added conversion between roman numerals and dates
* Improved the flexibility in arithmetic with integer, roman strings and roman numbers
* Fixed README file

# 3.2.1

* Improved the checks on roman numerals

# 3.2.0

* Added roman numerals
* Added trigonometry functions supports to work with complex numbers
* Added limit
* Added factors
* Fixed README file

# 3.1.0

* Simplified Example file
* Improved exponents of Complex numbers
* Fixed bearingTo() in Point to include axis
* Fixed return type of normalize from Angle
* Fixed README file

# 3.0.0

* Added Geometry (Point, line, Circle, Triangle, Polygon, etc.)
* Added Polynomial (Linear, Quadratic, Cubic, Quartic, Durand-Kerner)
* Added List and vecctors having same properties
* Added NumPy's roll
* Fixed README file

# 2.1.2

* Fixed complex number outputing wrong string

# 2.1.1

* Fixed bugs

# 2.1.0

* Added arguments for diagonal
* Improved min, max and sum functions with axes
* Fixed bug with magic matrix not working for singly even numbers (6, 10, 14, 18, 22 etc).
* Fixed bugs

# 2.0.2

* Changed the reverse function to flip in matrices
* Added magic() to the Maatrix constructors
* Fixed bug in FileIO

# 2.0.1

* Fixed bug

# 2.0.0

* Fixed the usage of quantities in the respective computations
* Implemented support for quantity
* Fixed Web not supported
* Fixed range
* Fixed README

# 1.0.3

* Fixed bugs
* Fixed README

# 1.0.2

* Conversion of angles(radians, degrees, gradients, DMS, and DM)
* Organized code
* Fixed bugs
* Fixed README

# 1.0.0

* Moved codes and reorganized functions
* Fixed bugs

# 0.1.8

* Fixed bugs (in null space)

# 0.1.7

* Added rescale for both vectors and matrix
* Improved vector compatibility with lists
* Added operations on vectors such as expo, sum, prod, etc.
* Fixed normalize function with options on the norm to use
* Fixed Norm with options
* Fixed bugs

# 0.1.5

* Added support for distance calculation for vectors and matrices
* Improved consistency in linear algebra
* Added scale for vector types

# 0.1.4

* Spercial matrices and vectors their functionalities
* Fixed spellings in matrix structure properties
* Added functions partioning of vectors subVector() and getVector()
* Improved subMatrix() function
* Fixed README

# 0.1.2

* Fixed spellings in matrix structure properties
* Added Vectors, Complex Numbers, and Complex Vectors to README
* Fixed README

# 0.1.1

* Fixed README

# 0.1.0

* Improved indexOf() and random functionalities
* Fixed README
* Fixed bugs

# 0.0.9

* Started benchmarking
* Implemented matrix form rows and columns
* Implemented Vectors, Complex nyumbers and Complex Vectors
* Improved copyFrom() to retain or resize matrices
* Improved matrix concatenate
* Fixed README
* Corrected anonotations
* Fixed bugs

# 0.0.8

* Added Exponential, logarithmic, and Matrix power (generalized, not just integer powers)
* Added support to create from flattened arrays
* Clean codes
* Fixed bugs

# 0.0.7

* Fixed matrix round
* Fixed corrected README
* Fixed bugs

# 0.0.6

* Added matrix broadcast and replicate matrix
* Added pseudoInverse of a matrix
* Fixed corrected README
* Fixed bugs

# 0.0.5

* Added linear equation solver (cramersRule, ridgeRegression, bareissAlgorithm, inverseMatrix, gaussElimination, gaussJordanElimination, leastSquares, etc.)
* Added function to compute matrix condition number with both SVD and norm2 approaches.
* Added matrix decompositions
  * * LU decompositions
    * * Crout's algorithm
    * * Doolittle algorithm
    * * Doolittle algorithm with Partial Pivoting
    * * Doolittle algorithm with Complete Pivoting
    * * Gauss Elimination Method
  * * QR decompositions
    * * QR decomposition Gram Schmidt
    * * QR decomposition Householder
  * * LQ decomposition
  * * Cholesky Decomposition
  * * Eigenvalue Decomposition (incomplete)
  * * Singular Value Decomposition
  * * Schur Decomposition
* Added matrix condition
* Added support for exponential, logarithmic, and trigonometric functions on matrices
* Added more matrix operations like scale,norm, norm2, l2Norms,
* Added support for checking matrix properties.
* Added class for Complex numbers
* Added support for to auto detect matrix types.
* Added scaleRow and addRow operations.
* Implemented new constructors like tridiagonal matrix
* Modified the Matrix.diagonal() to accept super-diagonal, diagonal, minor diagonals.
* Implemented Iterator and Iterable interfaces for easy traversal of matrix elements
* Provide methods to import and export matrices to and from other formats (e.g., CSV, JSON, binary)
* Fixed bugs

# 0.0.3

* Improved the arithmetic (+, -, *) functions to work for both scalars and matrices
* Updated range to create row and column matrices
* Added updateRow(), updateColumn, insertRow, insertColumn, appendRows, appendColumns
* Added creating random matrix
* Added more looks and feel to the toString() method
* Corrected some wrong calculations
* Fixed bugs
* Fix README file

# 0.0.2

* Added info on the README file.
* Added more functionalities
* Fixed bugs
* Tests now works with most of the functions

# 0.0.1

* initial release.
