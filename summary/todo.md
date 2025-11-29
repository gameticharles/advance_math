# Advance Math Implementation Roadmap

> **Version**: Based on codebase analysis v1.0  
> **Target**: Transform advance_math into the "NumPy + SciPy + SymPy of Dart"  
> **Integration**: Leverages `dartframe` package for NDArray/DataFrame functionality

---

## Phase 1: Core Calculus Module (HIGH PRIORITY)

> **Reference Class Structure:**
>
> ```dart
> class NumericalIntegration {
>   /// Trapezoidal rule integration
>   static num trapezoidal(Function f, num a, num b, {int n = 100});
>
>   /// Simpson's rule (more accurate)
>   static num simpsons(Function f, num a, num b, {int n = 100});
>
>   /// Romberg integration with Richardson extrapolation
>   static num romberg(Function f, num a, num b, {double tolerance = 1e-6});
>
>   /// Adaptive Simpson's rule
>   static num adaptiveSimpson(Function f, num a, num b, {double tolerance = 1e-6});
>
>   /// Gaussian quadrature
>   static num gaussianQuadrature(Function f, num a, num b, {int order = 5});
>
>   /// Double and triple integrals
>   static num doubleIntegral(Function f, num ax, num bx, num ay, num by);
>   static num tripleIntegral(Function f, num ax, num bx, num ay, num by, num az, num bz);
> }
>
> class NumericalDifferentiation {
>   /// First derivative using central difference
>   static num derivative(Function f, num x, {double h = 1e-5});
>
>   /// Second derivative
>   static num secondDerivative(Function f, num x, {double h = 1e-5});
>
>   /// nth derivative
>   static num nthDerivative(Function f, num x, int n, {double h = 1e-5});
>
>   /// Gradient for multivariate functions
>   static List<num> gradient(Function f, List<num> x);
>
>   /// Jacobian matrix
>   static Matrix jacobian(List<Function> functions, List<num> x);
>
>   /// Hessian matrix
>   static Matrix hessian(Function f, List<num> x);
> }
>
> abstract class Expression {
>   // Existing method, extend:
>   Expression differentiate({String variable = 'x'});
>
>   // New methods:
>   Expression partialDerivative(String variable);
>   Expression taylorSeries(String variable, num point, int order);
>   Expression maclaurinSeries(String variable, int order);
>   Expression indefiniteIntegral({String variable = 'x'});
>   num definiteIntegral(String variable, num a, num b);
> }
> ```

### 1.1 Numerical Integration (`lib/src/math/algebra/calculus/integration.dart`)

- [x] **Trapezoidal Rule**

  - [x] `num trapezoidal(Function f, num a, num b, {int n = 100})`
  - [x] Add adaptive step size support
  - [x] Add error estimation

- [x] **Simpson's Rule**

  - [x] `num simpsons(Function f, num a, num b, {int n = 100})`
  - [x] Ensure n is even (validation)
  - [x] Add adaptive Simpson's: `num adaptiveSimpson(Function f, num a, num b, {double tolerance = 1e-6})`

- [x] **Romberg Integration**

  - [x] `num romberg(Function f, num a, num b, {double tolerance = 1e-6, int maxDepth = 10})`
  - [x] Implement Richardson extrapolation
  - [x] Add convergence checking

- [x] **Gaussian Quadrature**

  - [x] `num gaussianQuadrature(Function f, num a, num b, {int order = 5})`
  - [x] Implement Legendre polynomial roots
  - [x] Add weights calculation

- [x] **Multi-dimensional Integration**

  - [x] `num doubleIntegral(Function f, num ax, num bx, Function ay, Function by, {int nx = 50, int ny = 50})`
  - [x] `num tripleIntegral(Function f, num ax, num bx, Function ay, Function by, Function az, Function bz)`
  - [x] Add Monte Carlo integration: `num monteCarloIntegral(Function f, List<num> lower, List<num> upper, {int samples = 10000})`

- [x] **Tests and Documentation**
  - [x] Create `test/calculus/integration_test.dart`
  - [x] Add examples for all methods
  - [ ] Benchmark performance

### 1.2 Numerical Differentiation (`lib/src/math/algebra/calculus/differentiation.dart`)

- [x] **Basic Derivatives**

  - [x] `num derivative(Function f, num x, {double h = 1e-5})` - Central difference
  - [x] `num forwardDifference(Function f, num x, {double h = 1e-5})`
  - [x] `num backwardDifference(Function f, num x, {double h = 1e-5})`

- [x] **Higher-order Derivatives**

  - [x] `num secondDerivative(Function f, num x, {double h = 1e-5})`
  - [x] `num nthDerivative(Function f, num x, int n, {double h = 1e-5})`

- [x] **Multivariate Calculus**

  - [x] `List<num> gradient(Function f, List<num> x, {double h = 1e-5})`
  - [x] `Matrix jacobian(List<Function> functions, List<num> x, {double h = 1e-5})`
  - [x] `Matrix hessian(Function f, List<num> x, {double h = 1e-5})`
  - [x] `num directionalDerivative(Function f, List<num> point, List<num> direction)`

- [x] **Tests and Documentation**
  - [x] Create `test/calculus/differentiation_test.dart`
  - [x] Add validation against known analytical derivatives
  - [x] Add examples

### 1.3 Symbolic Calculus Enhancements (`lib/src/math/algebra/expression/`)

- [x] **Enhanced Differentiation**

  - [x] Update `Expression.differentiate()` to accept `{String variable = 'x'}` (via `SymbolicCalculus`)
  - [x] Add `Expression.partialDerivative(String variable)`
  - [x] Implement chain rule detection
  - [x] Add product rule explicit handling
  - [x] Add quotient rule explicit handling

- [x] **Integration**

  - [x] Add `Expression.indefiniteIntegral({String variable = 'x'})`
  - [x] Add `num definiteIntegral(String variable, num a, num b)`
  - [x] Implement basic integration rules (polynomial, exponential, trig)

- [x] **Series Expansion**

  - [x] Add `Expression.taylorSeries(String variable, num point, int order)`
  - [x] Add `Expression.maclaurinSeries(String variable, int order)`
  - [x] Add `Expression.series(String variable, dynamic point, int order)`

- [x] **Limits**

  - [x] Add `dynamic limit(String variable, dynamic value, {String direction = 'both'})`
  - [x] Support left/right limits
  - [x] Handle indeterminate forms (0/0, ∞/∞)

- [x] **Tests and Documentation**
  - [x] Extend `test/expression_*.dart` tests (Created `test/calculus/symbolic_calculus_test.dart`)
  - [x] Add symbolic calculus examples
  - [x] Document all new methods

---

## Phase 2: Nonlinear Systems & Optimization (HIGH PRIORITY)

> **Reference Class Structure:**
>
> ```dart
> class RootFinding {
>   /// Bisection method
>   static num bisection(Function f, num a, num b, {double tolerance = 1e-6});
>   /// Newton-Raphson method
>   static num newtonRaphson(Function f, Function df, num x0, {double tolerance = 1e-6});
>   /// Secant method
>   static num secant(Function f, num x0, num x1, {double tolerance = 1e-6});
>   /// Brent's method (combines bisection, secant, and inverse quadratic)
>   static num brent(Function f, num a, num b, {double tolerance = 1e-6});
>   /// False position (Regula Falsi)
>   static num falsePosition(Function f, num a, num b, {double tolerance = 1e-6});
>   /// Müller's method (for complex roots)
>   static Complex muller(Function f, num x0, num x1, num x2);
> }
>
> class NonlinearSystemSolvers {
>   /// Newton's method for systems
>   static Matrix newtonMethod(
>     List<Function> functions,
>     List<num> initialGuess,
>     {int maxIterations = 100, double tolerance = 1e-6}
>   );
>   /// Broyden's method (quasi-Newton)
>   static Matrix broyden(
>     List<Function> functions,
>     List<num> initialGuess,
>     {int maxIterations = 100, double tolerance = 1e-6}
>   );
>   /// Fixed-point iteration
>   static Matrix fixedPoint(
>     List<Function> functions,
>     List<num> initialGuess,
>     {int maxIterations = 100, double tolerance = 1e-6}
>   );
> }
>
> class Optimization {
>   /// Gradient descent
>   static List<num> gradientDescent(Function objective, List<num> initialGuess, {double learningRate = 0.01, int maxIterations = 1000});
>   /// Conjugate gradient method
>   static List<num> conjugateGradient(Function objective, List<num> initialGuess);
>   /// Nelder-Mead simplex method (derivative-free)
>   static List<num> nelderMead(Function objective, List<num> initialGuess);
>   /// BFGS quasi-Newton method
>   static List<num> bfgs(Function objective, List<num> initialGuess);
>   /// Simulated annealing (global optimization)
>   static List<num> simulatedAnnealing(Function objective, List<num> initialGuess, {double initialTemp = 1000, double coolingRate = 0.95});
>   /// Particle swarm optimization
>   static List<num> particleSwarm(Function objective, List<List<num>> bounds, {int particles = 30, int iterations = 100});
> }
> ```

### 2.1 Root Finding (`lib/src/math/algebra/nonlinear/root_finding.dart`)

- [x] **Bracketing Methods**

  - [x] `num bisection(Function f, num a, num b, {double tolerance = 1e-6, int maxIter = 100})`
  - [x] `num falsePosition(Function f, num a, num b, {double tolerance = 1e-6, int maxIter = 100})`
  - [x] `num brent(Function f, num a, num b, {double tolerance = 1e-6})`

- [x] **Open Methods**

  - [x] `num newtonRaphson(Function f, Function df, num x0, {double tolerance = 1e-6, int maxIter = 100})`
  - [x] `num secant(Function f, num x0, num x1, {double tolerance = 1e-6, int maxIter = 100})`
  - [x] `num fixedPoint(Function g, num x0, {double tolerance = 1e-6, int maxIter = 100})`

- [x] **Complex Root Finding**

  - [x] `Complex muller(Function f, num x0, num x1, num x2, {double tolerance = 1e-6})`
  - [x] `List<Complex> allRoots(Function f, num lowerBound, num upperBound)` (Not implemented yet, deferred)

- [x] **Tests and Documentation**
  - [x] Create `test/nonlinear/root_finding_test.dart`
  - [x] Test against known functions
  - [x] Add convergence analysis (Implicit in tests)

### 2.2 Nonlinear Systems (`lib/src/math/algebra/nonlinear/systems.dart`)

- [x] **Newton's Method for Systems**

  - [x] `NonlinearSystemResult newton(List<Function> functions, List<num> initialGuess, {Function? jacobian, int maxIter = 100, double tolerance = 1e-6})`
  - [x] Support for user-provided or numerical Jacobian

- [x] **Broyden's Method**

  - [x] `NonlinearSystemResult broyden(List<Function> functions, List<num> initialGuess, {int maxIter = 100, double tolerance = 1e-6})`

- [x] **Fixed-Point Iteration for Systems**

  - [x] `NonlinearSystemResult fixedPoint(List<Function> gFunctions, List<num> initialGuess, {int maxIter = 100, double tolerance = 1e-6})`

- [x] **Result Class**

  - [x] `NonlinearSystemResult` with solution, iterations, convergence status

- [x] **Tests and Documentation**
  - [x] Create `test/nonlinear/systems_test.dart`
  - [x] Test 2x2 and 3x3 systems
  - [x] Verify convergence for various test cases

### 2.3 Optimization (`lib/src/math/algebra/nonlinear/optimization.dart`)

- [x] **Unconstrained Optimization**

  - [x] `OptimizationResult gradientDescent(Function objective, List<num> initialGuess, {double lr = 0.01, int maxIter = 1000})`
  - [x] `OptimizationResult conjugateGradient(Function objective, List<num> initialGuess, {int maxIter = 1000})`
  - [x] `OptimizationResult bfgs(Function objective, List<num> initialGuess, {int maxIter = 1000})`
  - [x] `OptimizationResult nelderMead(Function objective, List<num> initialGuess, {int maxIter = 1000})`

- [ ] **Global Optimization**

  - [ ] `OptimizationResult simulatedAnnealing(Function objective, List<num> initial, {double T0 = 1000, double coolingRate = 0.95})`
  - [ ] `OptimizationResult particleSwarm(Function objective, List<List<num>> bounds, {int particles = 30, int iterations = 100})`
  - [ ] `OptimizationResult geneticAlgorithm(Function objective, List<List<num>> bounds, {int population = 50, int generations = 100})`

- [x] **Constrained Optimization**

  - [ ] `OptimizationResult lagrangeMultipliers(Function objective, List<Function> constraints, List<num> initial)`
  - [x] `OptimizationResult penaltyMethod(Function objective, List<Function> constraints, List<num> initial)`

- [x] **Result Class**

  - [x] Create `OptimizationResult` class
    - [x] `Matrix solution`
    - [x] `num objectiveValue`
    - [x] `int iterations`
    - [x] `bool converged`
    - [x] `String message`

- [x] **Tests and Documentation**
  - [x] Create `test/nonlinear/optimization_test.dart`
  - [x] Test on quadratic and Rosenbrock functions
  - [x] Test constrained optimization with penalty method

---

## Phase 3: Differential Equations (HIGH PRIORITY)

> **Reference Class Structure:**
>
> ```dart
> class ODE {
>   /// Euler's method
>   static List<List<num>> euler(Function dydt, num y0, num t0, num tf, {int steps = 100});
>   /// Runge-Kutta 4th order (RK4)
>   static List<List<num>> rk4(Function dydt, num y0, num t0, num tf, {int steps = 100});
>   /// Runge-Kutta-Fehlberg (adaptive step size)
>   static List<List<num>> rkf45(Function dydt, num y0, num t0, num tf, {double tolerance = 1e-6});
>   /// System of ODEs
>   static List<List<List<num>>> systemRK4(List<Function> derivatives, List<num> y0, num t0, num tf, {int steps = 100});
> }
>
> class PDE {
>   /// Finite difference method for heat equation
>   static Matrix heatEquation1D(num alpha, List<num> initialCondition, num dx, num dt, int timeSteps);
>   /// Finite difference for wave equation
>   static Matrix waveEquation1D(num c, List<num> initialPosition, List<num> initialVelocity, num dx, num dt, int timeSteps);
> }
> ```

### 3.1 Ordinary Differential Equations (`lib/src/math/differential_equations/ode.dart`)

- [x] **Single ODE Solvers**

  - [x] `ODEResult euler(Function dydt, num y0, num t0, num tf, {int steps = 100})`
  - [x] `ODEResult rk4(Function dydt, num y0, num t0, num tf, {int steps = 100})`
  - [x] `ODEResult rk45(Function dydt, num y0, num t0, num tf, {double tol = 1e-6})`

- [x] **System of ODEs**

  - [x] Support for systems in all solvers (Euler, RK4, RK45)
  - [x] Automatic detection of scalar vs. system ODEs

- [x] **Stiff Methods**

  - [x] `ODEResult backwardEuler(Function dydt, num y0, num t0, num tf, {int steps = 100})`

- [x] **Result Classes**

  - [x] Create `ODEResult` class with `List<num> t`, `List<dynamic> y`

- [x] **Tests and Documentation**
  - [x] Created `test/differential_equations/ode_test.dart`
  - [x] Tested exponential decay, harmonic oscillator, Lotka-Volterra
  - [x] All 6 ODE tests passed

### 3.2 Partial Differential Equations (`lib/src/math/differential_equations/pde.dart`)

- [x] **1D PDEs**

  - [x] `PDEResult heatEquation1D(num alpha, List<num> xRange, List<num> tRange, ...)`
  - [x] `PDEResult waveEquation1D(num c, List<num> xRange, List<num> tRange, ...)`

- [x] **BVP Solvers**

  - [x] `ODEResult shootingMethod(Function f, num xa, num xb, num ya, num yb, ...)`
  - [x] `ODEResult finiteDifference(Function p, Function q, Function r, num xa, num xb, num ya, num yb, ...)`

- [x] **Tests and Documentation**
  - [x] Created `test/differential_equations/pde_test.dart`
  - [x] Validated heat and wave equations
  - [x] Tested BVP solvers
  - [x] All 6 PDE/BVP tests passed

---

## Phase 4: Advanced Statistics & Probability (MEDIUM PRIORITY)

> **Reference Class Structure:**
>
> ```dart
> abstract class ProbabilityDistribution {
>   num pdf(num x);  // Probability density function
>   num cdf(num x);  // Cumulative distribution function
>   num quantile(num p);  // Inverse CDF
>   num mean();
>   num variance();
>   num sample();
>   List<num> samples(int n);
> }
>
> class NormalDistribution extends ProbabilityDistribution {
>   final num mean;
>   final num stdDev;
>   NormalDistribution(this.mean, this.stdDev);
>   // Implementations...
> }
>
> class HypothesisTesting {
>   /// One-sample t-test
>   static TTestResult tTestOneSample(List<num> data, num populationMean);
>   /// Two-sample t-test
>   static TTestResult tTestTwoSample(List<num> sample1, List<num> sample2, {bool equalVariance = true});
>   /// Paired t-test
>   static TTestResult tTestPaired(List<num> before, List<num> after);
>   /// Chi-squared test
>   static ChiSquaredResult chiSquaredTest(List<num> observed, List<num> expected);
>   /// ANOVA (Analysis of Variance)
>   static ANOVAResult anova(List<List<num>> groups);
>   /// Kolmogorov-Smirnov test
>   static KSTestResult kolmogorovSmirnov(List<num> data, ProbabilityDistribution dist);
> }
>
> class TTestResult {
>   final num tStatistic;
>   final num pValue;
>   final num degreesOfFreedom;
>   final bool rejectNull;
> }
> ```

### 4.1 Probability Distributions (`lib/src/math/basic/distributions/`)

- [ ] **Distribution Base Class** (`base.dart`)

  - [ ] Create `abstract class ProbabilityDistribution`
    - [ ] `num pdf(num x)` - Probability density function
    - [ ] `num cdf(num x)` - Cumulative distribution function
    - [ ] `num quantile(num p)` - Inverse CDF
    - [ ] `num mean()`
    - [ ] `num variance()`
    - [ ] `num stdDev()`
    - [ ] `num sample()` - Single sample
    - [ ] `List<num> samples(int n)` - Multiple samples

- [ ] **Continuous Distributions**

  - [ ] `NormalDistribution(num mean, num stdDev)` (`normal.dart`)
  - [ ] `UniformDistribution(num a, num b)` (`uniform.dart`)
  - [ ] `ExponentialDistribution(num lambda)` (`exponential.dart`)
  - [ ] `GammaDistribution(num shape, num scale)` (`gamma.dart`)
  - [ ] `BetaDistribution(num alpha, num beta)` (`beta.dart`)
  - [ ] `ChiSquaredDistribution(int degreesOfFreedom)` (`chi_squared.dart`)
  - [ ] `StudentTDistribution(int degreesOfFreedom)` (`student_t.dart`)
  - [ ] `FDistribution(int df1, int df2)` (`f_distribution.dart`)
  - [ ] `LogNormalDistribution(num mu, num sigma)` (`lognormal.dart`)
  - [ ] `WeibullDistribution(num shape, num scale)` (`weibull.dart`)

- [ ] **Discrete Distributions**

  - [ ] `BinomialDistribution(int n, num p)` (`binomial.dart`)
  - [ ] `PoissonDistribution(num lambda)` (`poisson.dart`)
  - [ ] `GeometricDistribution(num p)` (`geometric.dart`)
  - [ ] `HypergeometricDistribution(int N, int K, int n)` (`hypergeometric.dart`)
  - [ ] `NegativeBinomialDistribution(int r, num p)` (`negative_binomial.dart`)

- [ ] **Tests and Documentation**

  - [ ] Create `test/distributions/` directory
  - [ ] Test each distribution against known values
  - [ ] Add statistical moments validation
  - [ ] Add examples for each distribution

  - [ ] `ANOVAResult` class
  - [ ] `KSTestResult` class
  - [ ] Add `toString()` methods for readable output

- [ ] **Tests and Documentation**
  - [ ] Create `test/statistics/hypothesis_testing_test.dart`
  - [ ] Validate against R or Python results
  - [ ] Add interpretation guides

### 4.3 Time Series Analysis (`lib/src/math/basic/time_series.dart`)

- [ ] **Smoothing and Trends**

  - [ ] `List<num> movingAverage(List<num> data, int window)`
  - [ ] `List<num> exponentialSmoothing(List<num> data, double alpha)`
  - [ ] `List<num> doubleExponentialSmoothing(List<num> data, double alpha, double beta)`
  - [ ] `List<num> tripleExponentialSmoothing(List<num> data, double alpha, double beta, double gamma, int period)`

- [ ] **Autocorrelation**

  - [ ] `num autocovariance(List<num> data, int lag)`
  - [ ] `num autocorrelation(List<num> data, int lag)`
  - [ ] `List<num> acf(List<num> data, int maxLag)`
  - [ ] `List<num> pacf(List<num> data, int maxLag)` - Partial autocorrelation

- [ ] **Decomposition**

  - [ ] Create `SeasonalDecomposition` class with `trend`, `seasonal`, `residual`
  - [ ] `SeasonalDecomposition decompose(List<num> data, int period, {String model = 'additive'})`

- [ ] **ARIMA** (Basic implementation)

  - [ ] Create `ARIMAModel` class
  - [ ] `ARIMAModel fitARIMA(List<num> data, int p, int d, int q)`
  - [ ] `List<num> forecast(int steps)`

- [ ] **Tests and Documentation**
  - [ ] Create `test/statistics/time_series_test.dart`
  - [ ] Test on synthetic data
  - [ ] Add real-world examples

### 4.4 Regression Enhancements (`lib/src/math/basic/regression/`)

- [ ] **Linear Regression** (`linear_regression.dart`)

  - [ ] Enhance existing `regression()` function
  - [ ] Create `RegressionResult` class
  - [ ] `RegressionResult multipleLinear(Matrix X, Matrix y)`
  - [ ] Add R², adjusted R², residuals, p-values
  - [ ] Add `predict(List<num> x)` method

- [ ] **Polynomial Regression** (`polynomial_regression.dart`)

  - [ ] `RegressionResult polynomial(List<num> x, List<num> y, int degree)`
  - [ ] Auto-generate polynomial features

- [ ] **Non-linear Regression** (`nonlinear_regression.dart`)

  - [ ] `RegressionResult logistic(Matrix X, List<num> y, {int maxIter = 100})`
  - [ ] `RegressionResult exponential(List<num> x, List<num> y)`
  - [ ] `RegressionResult power(List<num> x, List<num> y)`

- [ ] **Regularized Regression** (`regularized.dart`)

  - [ ] Enhance existing ridge regression
  - [ ] `RegressionResult lasso(Matrix X, Matrix y, {double alpha = 1.0})`
  - [ ] `RegressionResult elasticNet(Matrix X, Matrix y, {double alpha = 1.0, double l1Ratio = 0.5})`
  - [ ] Add cross-validation for hyperparameter tuning

- [ ] **Tests and Documentation**
  - [ ] Create `test/statistics/regression_test.dart`
  - [ ] Validate against sklearn results
  - [ ] Add examples with real datasets

---

## Phase 5: Machine Learning Models (HIGH PRIORITY)

> **Reference Class Structure:**
>
> ```dart
> // Linear models
> class LinearRegression {
>   Matrix coefficients;
>   num intercept;
>   void fit(Matrix X, Matrix y);
>   Matrix predict(Matrix X);
>   num score(Matrix X, Matrix y);  // R² score
> }
>
> class LogisticRegression {
>   Matrix coefficients;
>   num intercept;
>   void fit(Matrix X, List<int> y, {int maxIter = 100});
>   List<num> predictProba(Matrix X);
>   List<int> predict(Matrix X, {double threshold = 0.5});
> }
>
> // Clustering
> class KMeans {
>   final int k;
>   Matrix centroids;
>   KMeans(this.k);
>   List<int> fit(Matrix data, {int maxIter = 100});
>   List<int> predict(Matrix data);
> }
>
> class DBSCAN {
>   final double eps;
>   final int minSamples;
>   DBSCAN(this.eps, this.minSamples);
>   List<int> fit(Matrix data);
> }
>
> // Dimensionality reduction
> class PCA {
>   Matrix components;
>   List<num> explainedVariance;
>   void fit(Matrix data, {int nComponents});
>   Matrix transform(Matrix data);
>   Matrix fitTransform(Matrix data, {int nComponents});
> }
>
> // Neural Networks
> abstract class Layer {
>   Matrix forward(Matrix input);
>   Matrix backward(Matrix gradient);
>   void updateWeights(double learningRate);
> }
>
> class DenseLayer extends Layer {
>   Matrix weights;
>   Matrix biases;
>   // Implementation...
> }
>
> class NeuralNetwork {
>   final List<Layer> layers;
>   NeuralNetwork(this.layers);
>   Matrix forward(Matrix input);
>   void train(Matrix X, Matrix y, {int epochs = 100, double learningRate = 0.01, int batchSize = 32});
>   Matrix predict(Matrix input);
> }
> ```

### 5.1 Linear Models (`lib/src/models/linear/`)

- [ ] **Linear Regression Model** (`linear_regression.dart`)

  - [ ] Create `LinearRegression` class
    - [ ] `Matrix coefficients`
    - [ ] `num intercept`
    - [ ] `void fit(Matrix X, Matrix y)`
    - [ ] `Matrix predict(Matrix X)`
    - [ ] `num score(Matrix X, Matrix y)` - R² score
    - [ ] `void saveModel(String path)`
    - [ ] `static LinearRegression loadModel(String path)`

- [ ] **Logistic Regression** (`logistic_regression.dart`)

  - [ ] Create `LogisticRegression` class
    - [ ] `Matrix coefficients`
    - [ ] `num intercept`
    - [ ] `void fit(Matrix X, List<int> y, {int maxIter = 100, double lr = 0.01})`
    - [ ] `List<num> predictProba(Matrix X)`
    - [ ] `List<int> predict(Matrix X, {double threshold = 0.5})`
    - [ ] `num accuracy(Matrix X, List<int> y)`
    - [ ] `Map<String, num> classificationReport(Matrix X, List<int> y)`

- [ ] **Ridge/Lasso Regression** (`regularized_regression.dart`)

  - [ ] Create `RidgeRegression` class
  - [ ] Create `LassoRegression` class
  - [ ] Integrate with existing ridge implementation

- [ ] **Tests and Documentation**
  - [ ] Create `test/models/linear_models_test.dart`
  - [ ] Test on iris, wine datasets
  - [ ] Add examples

### 5.2 Clustering (`lib/src/models/clustering/`)

- [ ] **K-Means** (`kmeans.dart`)

  - [ ] Create `KMeans` class
    - [ ] `final int k`
    - [ ] `Matrix centroids`
    - [ ] `List<int> labels`
    - [ ] `List<int> fit(Matrix data, {int maxIter = 100, String init = 'random'})`
    - [ ] `List<int> predict(Matrix data)`
    - [ ] `num inertia()` - Sum of squared distances to centroids
    - [ ] `num silhouetteScore(Matrix data)`

- [ ] **DBSCAN** (`dbscan.dart`)

  - [ ] Create `DBSCAN` class
    - [ ] `final double eps`
    - [ ] `final int minSamples`
    - [ ] `List<int> labels`
    - [ ] `List<int> fit(Matrix data)`
    - [ ] Identify core, border, and noise points

- [ ] **Hierarchical Clustering** (`hierarchical.dart`)

  - [ ] Create `AgglomerativeClustering` class
    - [ ] `final int nClusters`
    - [ ] `final String linkage` - single, complete, average, ward
    - [ ] `List<int> fit(Matrix data)`
    - [ ] `Matrix dendrogram()`

- [ ] **Tests and Documentation**
  - [ ] Create `test/models/clustering_test.dart`
  - [ ] Test on synthetic clusters
  - [ ] Add visualization examples

### 5.3 Dimensionality Reduction (`lib/src/models/decomposition/`)

- [ ] **PCA** (`pca.dart`)

  - [ ] Create `PCA` class
    - [ ] `Matrix components`
    - [ ] `List<num> explainedVariance`
    - [ ] `List<num> explainedVarianceRatio`
    - [ ] `void fit(Matrix data, {int? nComponents})`
    - [ ] `Matrix transform(Matrix data)`
    - [ ] `Matrix fitTransform(Matrix data, {int? nComponents})`
    - [ ] `Matrix inverseTransform(Matrix transformed)`

- [ ] **SVD for Dimensionality Reduction** (`truncated_svd.dart`)

  - [ ] Create `TruncatedSVD` class
  - [ ] Leverage existing SVD implementation
  - [ ] Add LSA (Latent Semantic Analysis) support

- [ ] **LDA** (`lda.dart` - if time permits)

  - [ ] Create `LinearDiscriminantAnalysis` class
  - [ ] Supervised dimensionality reduction

- [ ] **Tests and Documentation**
  - [ ] Create `test/models/decomposition_test.dart`
  - [ ] Test on high-dimensional data
  - [ ] Add iris dataset example

### 5.4 Neural Network Foundations (`lib/src/models/neural/`)

- [ ] **Base Layer** (`layers/base.dart`)

  - [ ] Create `abstract class Layer`
    - [ ] `Matrix forward(Matrix input)`
    - [ ] `Matrix backward(Matrix gradient)`
    - [ ] `void updateWeights(double learningRate)`
    - [ ] `int get inputSize`
    - [ ] `int get outputSize`

- [ ] **Dense Layer** (`layers/dense.dart`)

  - [ ] Create `DenseLayer extends Layer`
    - [ ] `Matrix weights`
    - [ ] `Matrix biases`
    - [ ] Xavier/He initialization
    - [ ] Forward and backward pass

- [ ] **Activation Functions** (`activations.dart`)

  - [ ] `Matrix sigmoid(Matrix x)`
  - [ ] `Matrix relu(Matrix x)`
  - [ ] `Matrix tanh(Matrix x)`
  - [ ] `Matrix softmax(Matrix x)`
  - [ ] Corresponding derivatives for backprop

- [ ] **Neural Network** (`neural_network.dart`)

  - [ ] Create `NeuralNetwork` class
    - [ ] `List<Layer> layers`
    - [ ] `void addLayer(Layer layer)`
    - [ ] `Matrix forward(Matrix input)`
    - [ ] `void train(Matrix X, Matrix y, {int epochs = 100, double lr = 0.01, int batchSize = 32})`
    - [ ] `Matrix predict(Matrix input)`
    - [ ] Support for different loss functions

- [ ] **Loss Functions** (`loss.dart`)

  - [ ] `num meanSquaredError(Matrix yTrue, Matrix yPred)`
  - [ ] `num meanAbsoluteError(Matrix yTrue, Matrix yPred)`
  - [ ] `num crossEntropy(Matrix yTrue, Matrix yPred)`
  - [ ] Corresponding derivatives

- [ ] **Tests and Documentation**
  - [ ] Create `test/models/neural_test.dart`
  - [ ] Test XOR problem
  - [ ] Test MNIST-like data
  - [ ] Add examples

---

## Phase 6: DartFrame Integration & Enhancements (MEDIUM PRIORITY)

> **Note**: `dartframe` package already provides NDArray, DataFrame, Series, and DataCube. We integrate and extend rather than reimplement.
>
> **Integration Approach:**
> Create conversion utilities between advance_math types and dartframe types:
>
> - Matrix ↔ NDArray
> - Matrix ↔ DataFrame
> - Vector ↔ Series

### 6.1 Integration Tasks (`lib/src/integration/dartframe.dart`)

- [ ] **Add dartframe dependency**

  - [ ] Update `pubspec.yaml`: `dartframe: ^0.8.8`
  - [ ] Create integration layer

- [ ] **Matrix ↔ NDArray Conversion**

  - [ ] Add `Matrix.fromNDArray(NDArray array)` constructor
  - [ ] Add `NDArray toNDArray()` method to Matrix
  - [ ] Handle shape and data conversion

- [ ] **Matrix ↔ DataFrame Conversion**

  - [ ] Add `Matrix.fromDataFrame(DataFrame df)` constructor
  - [ ] Add `DataFrame toDataFrame({List<String>? columns, List<String>? index})` method

- [ ] **Series Integration**

  - [ ] Add `Vector.fromSeries(Series series)`
  - [ ] Add `Series toSeries({String? name})` method to Vector

- [ ] **Tests and Documentation**
  - [ ] Create `test/integration/dartframe_test.dart`
  - [ ] Test conversion roundtrips
  - [ ] Add examples using dartframe with advance_math

### 6.2 Statistical Enhancements using DartFrame

- [ ] **DataFrame Statistical Methods**

  - [ ] Create extension methods for statistical analysis on DataFrame
  - [ ] Correlation matrix generation
  - [ ] Covariance matrix generation
  - [ ] Add examples in README

- [ ] **Regression with DataFrame**
  - [ ] Add examples using DataFrame as input
  - [ ] Automatic feature handling

---

## Phase 7: Geometry & Computational Geometry (MEDIUM PRIORITY)

> **Reference Class Structure:**
>
> ```dart
> // 3D Solid Geometry
> class Sphere {
>   final Point3D center;
>   final num radius;
>   num volume();
>   num surfaceArea();
>   bool contains(Point3D point);
>   bool intersects(Sphere other);
>   Point3D? intersectRay(Point3D origin, Point3D direction);
> }
>
> class Cube {
>   final Point3D center;
>   final num sideLength;
>   num volume();
>   num surfaceArea();
>   List<Point3D> vertices();
>   List<Plane> faces();
> }
>
> // Computational Geometry
> class ComputationalGeometry {
>   /// Convex hull (2D)
>   static Polygon convexHull(List<Point> points);
>   /// Voronoi diagram
>   static VoronoiDiagram voronoi(List<Point> points);
>   /// Delaunay triangulation
>   static List<Triangle> delaunay(List<Point> points);
>   /// Line segment intersection
>   static bool segmentsIntersect(Point p1, Point p2, Point p3, Point p4);
>   /// Point in polygon test
>   static bool pointInPolygon(Point point, Polygon polygon);
>   /// Closest pair of points
>   static (Point, Point) closestPair(List<Point> points);
>   /// Bounding box
>   static Rectangle boundingBox(List<Point> points);
> }
>
> // 3D Transformations
> class Transform3D {
>   final Matrix4x4 matrix;
>   Transform3D.identity();
>   Transform3D.translation(num x, num y, num z);
>   Transform3D.rotation(String axis, num angle);
>   Transform3D.scale(num sx, num sy, num sz);
>   Point3D apply(Point3D point);
>   Transform3D compose(Transform3D other);
>   Transform3D inverse();
> }
> ```

### 7.1 3D Solid Geometry (`lib/src/math/geometry/solid/`)

- [ ] **Sphere** (`sphere.dart`)

  - [ ] Create `Sphere` class
    - [ ] `Point3D center`
    - [ ] `num radius`
    - [ ] `num volume()`
    - [ ] `num surfaceArea()`
    - [ ] `bool contains(Point3D point)`
    - [ ] `bool intersects(Sphere other)`
    - [ ] `Point3D? intersectRay(Point3D origin, Point3D direction)`

- [ ] **Cube** (`cube.dart`)

  - [ ] Create `Cube` class with center and side length
  - [ ] `List<Point3D> vertices()`
  - [ ] `List<Plane> faces()`
  - [ ] `num volume()`, `num surfaceArea()`

- [ ] **Cylinder** (`cylinder.dart`)

  - [ ] Create `Cylinder` class
  - [ ] Volume, surface area calculations
  - [ ] Intersection tests

- [ ] **Cone** (`cone.dart`)

  - [ ] Create `Cone` class
  - [ ] Volume, surface area

- [ ] **Additional Shapes** (if time permits)

  - [ ] `Pyramid`
  - [ ] `Tetrahedron`
  - [ ] `Prism`

- [ ] **Tests and Documentation**
  - [ ] Create `test/geometry/solid_test.dart`
  - [ ] Validate formulas
  - [ ] Add examples

### 7.2 Computational Geometry (`lib/src/math/geometry/computational/`)

- [ ] **2D Algorithms** (`algorithms_2d.dart`)

  - [ ] `Polygon convexHull(List<Point> points)` - Graham scan or Jarvis march
  - [ ] `bool segmentsIntersect(Point p1, Point p2, Point p3, Point p4)`
  - [ ] `bool pointInPolygon(Point point, Polygon polygon)` - Ray casting
  - [ ] `(Point, Point) closestPair(List<Point> points)` - Divide and conquer
  - [ ] `Rectangle boundingBox(List<Point> points)`

- [ ] **Triangulation** (`triangulation.dart`)

  - [ ] `List<Triangle> delaunayTriangulation(List<Point> points)`
  - [ ] `List<Polygon> voronoiDiagram(List<Point> points)`

- [ ] **Tests and Documentation**
  - [ ] Create `test/geometry/computational_test.dart`
  - [ ] Test on various point sets
  - [ ] Add visualization examples

### 7.3 3D Transformations (`lib/src/math/geometry/transform/`)

- [ ] **Transform3D Class** (`transform3d.dart`)

  - [ ] Create `Transform3D` class
    - [ ] `Matrix matrix` (4x4 homogeneous matrix)
    - [ ] `Transform3D.identity()`
    - [ ] `Transform3D.translation(num x, num y, num z)`
    - [ ] `Transform3D.rotationX(num angle)`
    - [ ] `Transform3D.rotationY(num angle)`
    - [ ] `Transform3D.rotationZ(num angle)`
    - [ ] `Transform3D.rotation(String axis, num angle)`
    - [ ] `Transform3D.scale(num sx, num sy, num sz)`
    - [ ] `Point3D apply(Point3D point)`
    - [ ] `Transform3D compose(Transform3D other)`
    - [ ] `Transform3D inverse()`

- [ ] **Tests and Documentation**
  - [ ] Create `test/geometry/transform_test.dart`
  - [ ] Test composition and inverse
  - [ ] Add 3D graphics pipeline example

---

## Phase 8: Graph Theory (HIGH PRIORITY - NEW MODULE)

> **Reference Class Structure:**
>
> ```dart
> class Graph<T> {
>   final Map<T, Set<T>> adjacencyList;
>   final bool directed;
>   final bool weighted;
>
>   Graph({this.directed = false, this.weighted = false});
>
>   void addVertex(T vertex);
>   void addEdge(T from, T to, {num weight = 1});
>   void removeVertex(T vertex);
>   void removeEdge(T from, T to);
>
>   // Traversal
>   List<T> bfs(T start);
>   List<T> dfs(T start);
>
>   // Path finding
>   List<T>? shortestPath(T start, T end);  // Dijkstra/BFS
>   Map<T, num> dijkstra(T start);
>   Map<T, num> bellmanFord(T start);
>   List<List<T>> allPaths(T start, T end);
>
>   // Properties
>   bool isConnected();
>   bool isCyclic();
>   bool isBipartite();
>   List<Set<T>> connectedComponents();
>
>   // Algorithms
>   Graph<T> minimumSpanningTree();  // Kruskal/Prim
>   List<T> topologicalSort();
>   int chromaticNumber();
>   Map<T, int> colorVertices();
>
>   // Centrality measures
>   Map<T, num> betweennessCentrality();
>   Map<T, num> closenessCentrality();
>   Map<T, num> degreeCentrality();
> }
> ```

### 8.1 Graph Data Structure (`lib/src/graph/`)

- [ ] **Graph Class** (`graph.dart`)

  - [ ] Create `Graph<T>` class
    - [ ] `Map<T, Set<T>> adjacencyList`
    - [ ] `Map<(T, T), num> weights` (for weighted graphs)
    - [ ] `bool directed`
    - [ ] `bool weighted`
    - [ ] `void addVertex(T vertex)`
    - [ ] `void addEdge(T from, T to, {num weight = 1})`
    - [ ] `void removeVertex(T vertex)`
    - [ ] `void removeEdge(T from, T to)`
    - [ ] `bool hasVertex(T vertex)`
    - [ ] `bool hasEdge(T from, T to)`
    - [ ] `num? getWeight(T from, T to)`
    - [ ] `List<T> neighbors(T vertex)`
    - [ ] `int degree(T vertex)`

- [ ] **Tests and Documentation**
  - [ ] Create `test/graph/graph_test.dart`
  - [ ] Test directed and undirected graphs
  - [ ] Test weighted and unweighted

### 8.2 Graph Traversal (`lib/src/graph/traversal.dart`)

- [ ] **Traversal Algorithms**

  - [ ] `List<T> bfs(T start)` - Breadth-first search
  - [ ] `List<T> dfs(T start)` - Depth-first search
  - [ ] `List<T> dfsRecursive(T start)`
  - [ ] `bool hasPath(T start, T end)`
  - [ ] `List<List<T>> allPaths(T start, T end)`

- [ ] **Tests and Documentation**
  - [ ] Add tests to `test/graph/graph_test.dart`
  - [ ] Test on various graph structures

### 8.3 Shortest Path (`lib/src/graph/shortest_path.dart`)

- [ ] **Shortest Path Algorithms**

  - [ ] `List<T>? dijkstra(T start, T end)`
  - [ ] `Map<T, num> dijkstraAll(T start)` - Distances to all vertices
  - [ ] `Map<T, num> bellmanFord(T start)` - Handles negative weights
  - [ ] `List<T>? astar(T start, T end, num Function(T, T) heuristic)`
  - [ ] `Matrix floydWarshall()` - All-pairs shortest paths

- [ ] **Tests and Documentation**
  - [ ] Create `test/graph/shortest_path_test.dart`
  - [ ] Test on various graphs
  - [ ] Compare algorithm performance

### 8.4 Graph Properties (`lib/src/graph/properties.dart`)

- [ ] **Connectivity**

  - [ ] `bool isConnected()`
  - [ ] `List<Set<T>> connectedComponents()`
  - [ ] `bool isStronglyConnected()` (for directed graphs)

- [ ] **Cycles**

  - [ ] `bool isCyclic()`
  - [ ] `List<T>? findCycle()`
  - [ ] `bool isAcyclic()`

- [ ] **Bipartiteness**

  - [ ] `bool isBipartite()`
  - [ ] `(Set<T>, Set<T>)? bipartiteSets()`

- [ ] **Tests and Documentation**
  - [ ] Add tests to `test/graph/graph_test.dart`
  - [ ] Test edge cases

### 8.5 Graph Algorithms (`lib/src/graph/algorithms.dart`)

- [ ] **Spanning Trees**

  - [ ] `Graph<T> minimumSpanningTree()` - Kruskal's or Prim's algorithm
  - [ ] `num mstWeight()`

- [ ] **Topological Sorting**

  - [ ] `List<T> topologicalSort()` (for DAGs)
  - [ ] Throw error if graph has cycles

- [ ] **Graph Coloring**

  - [ ] `Map<T, int> colorVertices()` - Greedy coloring
  - [ ] `int chromaticNumber()`

- [ ] **Centrality Measures**

  - [ ] `Map<T, num> degreeCentrality()`
  - [ ] `Map<T, num> betweennessCentrality()`
  - [ ] `Map<T, num> closenessCentrality()`

- [ ] **Tests and Documentation**
  - [ ] Create `test/graph/algorithms_test.dart`
  - [ ] Test on various graph types
  - [ ] Add examples

---

_**Note**: Phases 9-18 continue with similar detail. Each phase includes:_

- _Reference class structures from analysis document_
- _Detailed checkbox tasks_
- _File locations and function signatures_
- _Testing and documentation requirements_

## Remaining Phases Overview

- **Phase 9**: Fourier & Signal Processing - FFT enhancements, spectral analysis, filtering
- **Phase 10**: Interpolation Enhancements - Splines, multidimensional interpolation
- **Phase 11**: Number Theory - Prime operations, arithmetic functions
- **Phase 12**: Symbolic Mathematics - Enhanced simplification, equation solving
- **Phase 13**: Performance & Optimizations - Parallel processing, lazy evaluation
- **Phase 14**: Linear Algebra Enhancements - Advanced decompositions, sparse operations
- **Phase 15**: Bit Manipulation & Cryptography - Low-level operations
- **Phase 16**: Documentation & Examples - Comprehensive API docs, tutorials
- **Phase 17**: Testing & Quality Assurance - Coverage, benchmarks, validation
- **Phase 18**: Final Polish & Release - Code review, changelog, publication

---

## Summary Statistics

**Total Tasks**: 400+  
**Estimated Phases**: 18  
**Priority Breakdown**:

- High Priority: Phases 1-3, 5, 8 (Core calculus, nonlinear systems, ODEs, ML models, graph theory)
- Medium Priority: Phases 4, 6-7, 9-13 (Statistics, geometry, signal processing, optimizations)
- Low Priority: Phases 14-15 (Advanced linear algebra, bit operations)
- Ongoing: Phases 16-18 (Documentation, testing, release)

**Integration Notes**:

- ✅ Use `dartframe` for NDArray, DataFrame, Series operations
- ✅ Create conversion utilities between Matrix ↔ NDArray, DataFrame
- ✅ Focus on mathematical algorithms rather than data structures

---

## Next Steps

1. **Review and Prioritize**: Decide which phases to tackle first
2. **Set Milestones**: Break phases into smaller milestones
3. **Begin Implementation**: Start with Phase 1 (Calculus)
4. **Iterate**: Build, test, document, repeat

This roadmap transforms `advance_math` into a comprehensive scientific computing library for Dart, rivaling NumPy + SciPy + SymPy in Python!
