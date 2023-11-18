## 3.3.6
* Fixed bugs
* Renamed Row Column, and Diagonal matrices to RowMatrix, ColumnMatrix and DiagonalMatrix repectively

## 3.3.5
* Added morse code
* Added more math functions
* Improved documentation and performance
* Fixed bugs and aligned code

## 3.3.4
* Added support for converting number to words
* Added test for roman numerals.
* Fixed bugs in Roman numerals
* Added some string extension (e.g. capitalization, removeSpecialCharacters etc)

## 3.3.3
* Setting support for expressions
* Fixed errors in pow for both real and Complex numbers

## 3.3.2
* Added some math constants
* Fixed error in angles
* Fixed error in parsing linear and constant polynomial strings
* Increased the SDK

## 3.3.1
* Added Interpolation

## 3.3.0
* Added ZScore computation
* Added more functions matrix statistics
* Added multiple supports for determinant
* Fixed bugs in Roman numerals
* Fixed documentation inconsistencies

## 3.2.4
* Fixed error in angles

## 3.2.3
* Fixed error in angles conversion

## 3.2.2
* Improved the checks on roman numerals
* Added conversion between roman numerals and dates
* Improved the flexibility in arithmetic with integer, roman strings and roman numbers
* Fixed README file

## 3.2.1
* Improved the checks on roman numerals

## 3.2.0
* Added roman numerals
* Added trigonometry functions supports to work with complex numbers
* Added limit
* Added factors
* Fixed README file

## 3.1.0
* Simplified Example file
* Improved exponents of Complex numbers
* Fixed bearingTo() in Point to include axis
* Fixed return type of normalize from Angle
* Fixed README file

## 3.0.0
* Added Geometry (Point, line, Circle, Triangle, Polygon, etc.)
* Added Polynomial (Linear, Quadratic, Cubic, Quartic, Durand-Kerner)
* Added List and vecctors having same properties
* Added NumPy's roll
* Fixed README file

## 2.1.2
* Fixed complex number outputing wrong string

## 2.1.1
* Fixed bugs

## 2.1.0
* Added arguments for diagonal 
* Improved min, max and sum functions with axes
* Fixed bug with magic matrix not working for singly even numbers (6, 10, 14, 18, 22 etc).
* Fixed bugs

## 2.0.2
* Changed the reverse function to flip in matrices
* Added magic() to the Maatrix constructors
* Fixed bug in FileIO

## 2.0.1
* Fixed bug

## 2.0.0
* Fixed the usage of quantities in the respective computations
* Implemented support for quantity
* Fixed Web not supported
* Fixed range
* Fixed README

## 1.0.3
* Fixed bugs
* Fixed README

## 1.0.2
* Conversion of angles(radians, degrees, gradients, DMS, and DM) 
* Organized code
* Fixed bugs
* Fixed README

## 1.0.0
* Moved codes and reorganized functions
* Fixed bugs 

## 0.1.8
* Fixed bugs (in null space)

## 0.1.7
* Added rescale for both vectors and matrix
* Improved vector compatibility with lists
* Added operations on vectors such as expo, sum, prod, etc.
* Fixed normalize function with options on the norm to use
* Fixed Norm with options
* Fixed bugs

## 0.1.5
* Added support for distance calculation for vectors and matrices
* Improved consistency in linear algebra
* Added scale for vector types

## 0.1.4
* Spercial matrices and vectors their functionalities
* Fixed spellings in matrix structure properties
* Added functions partioning of vectors subVector() and getVector()
* Improved subMatrix() function
* Fixed README

## 0.1.2
* Fixed spellings in matrix structure properties
* Added Vectors, Complex Numbers, and Complex Vectors to README
* Fixed README

## 0.1.1
* Fixed README

## 0.1.0
* Improved indexOf() and random functionalities
* Fixed README 
* Fixed bugs

## 0.0.9

* Started benchmarking
* Implemented matrix form rows and columns
* Implemented Vectors, Complex nyumbers and Complex Vectors
* Improved copyFrom() to retain or resize matrices
* Improved matrix concatenate
* Fixed README 
* Corrected anonotations
* Fixed bugs

## 0.0.8

* Added Exponential, logarithmic, and Matrix power (generalized, not just integer powers)
* Added support to create from flattened arrays
* Clean codes
* Fixed bugs

## 0.0.7

* Fixed matrix round
* Fixed corrected README
* Fixed bugs

## 0.0.6

* Added matrix broadcast and replicate matrix
* Added pseudoInverse of a matrix
* Fixed corrected README
* Fixed bugs

## 0.0.5

* Added linear equation solver (cramersRule, ridgeRegression, bareissAlgorithm, inverseMatrix, gaussElimination, gaussJordanElimination, leastSquares, etc.)
* Added function to compute matrix condition number with both SVD and norm2 approaches.
* Added matrix decompositions
  * - LU decompositions
    * - Crout's algorithm
    * - Doolittle algorithm
    * - Doolittle algorithm with Partial Pivoting
    * - Doolittle algorithm with Complete Pivoting
    * - Gauss Elimination Method
  * - QR decompositions
    * - QR decomposition Gram Schmidt
    * - QR decomposition Householder
  * - LQ decomposition
  * - Cholesky Decomposition
  * - Eigenvalue Decomposition (incomplete)
  * - Singular Value Decomposition
  * - Schur Decomposition
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

## 0.0.3

* Improved the arithmetic (+, -, *) functions to work for both scalars and matrices
* Updated range to create row and column matrices
* Added updateRow(), updateColumn, insertRow, insertColumn, appendRows, appendColumns
* Added creating random matrix
* Added more looks and feel to the toString() method
* Corrected some wrong calculations
* Fixed bugs
* Fix README file

## 0.0.2

* Added info on the README file.
* Added more functionalities
* Fixed bugs
* Tests now works with most of the functions

## 0.0.1

* initial release.
