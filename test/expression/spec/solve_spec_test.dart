import 'package:test/test.dart';
import 'package:advance_math/advance_math.dart';

void main() {
  void check(String given, String expected) {
    var parsed = Expression.parse(given);
    // solve() returns a Literal containing the list of solutions
    var result = parsed.evaluate();
    expect(result.toString(), equals(expected), reason: 'Eval of $given');
  }

  group('Expression solve', () {
    group('linear equations', () {
      test('solve(x+1=5, x)', () => check('solve(x+1=5, x)', '[4]'));
      test('solve(2*x-4=0, x)', () => check('solve(2*x-4=0, x)', '[2]'));
      test('solve(x/2+1=3, x)', () => check('solve(x/2+1=3, x)', '[4]'));
    });

    group('quadratic equations', () {
      test('solve(x^2-1=0, x)', () => check('solve(x^2-1=0, x)', '[1, -1]'));
      test('solve(x^2+2*x+1=0, x)',
          () => check('solve(x^2+2*x+1=0, x)', '[-1, -1]'));
      test('solve(x^2+1=0, x)', () => check('solve(x^2+1=0, x)', '[i, -i]'));
    });

    group('cubic equations', () {
      test('solve(x^3=0, x)', () => check('solve(x^3=0, x)', '[0]'));
    });

    group('factored equations', () {
      test('solve((x-1)*(x-2)=0, x)',
          () => check('solve((x-1)*(x-2)=0, x)', '[2, 1]'));
      test(
          'solve(x*(x+3)=0, x)', () => check('solve(x*(x+3)=0, x)', '[0, -3]'));
    });

    group('equations with parameters', () {
      test('solve(x+a=0, x)', () => check('solve(x+a=0, x)', '[-1*a]'));
      test('solve(a*x+b=0, x)', () => check('solve(a*x+b=0, x)', '[-b/a]'));
    });

    group('system of equations', () {
      test('solveEquations(["x+y=1", "x-y=1"])',
          () => check('solveEquations(["x+y=1", "x-y=1"])', '[x, 1, y, 0]'));
    });
  });

  group('Solve', () {
    test('should solve correctly', () {
      check('solve(x=y/3416.3333333333344, y)', '[3416.3333333333344*x]');
      check('solve(x, x)', '[0]');
      check('solve(5*y^x=8, x)', '[log(8/5)*log(y)^(-1)]');
      check('solve(x^y+8=a*b, x)', '[(-8+a*b)^y^(-1)]');
      check('solve(x^2, x)', '[0]');
      check('solve(x^3, x)', '[0]');
      check('solve(x+1, x)', '[-1]');
      check('solve(x^2+1, x)', '[i,-i]');
      check('solve(2*x^2+1, x)', '[(1/2)*i*sqrt(2),(-1/2)*i*sqrt(2)]');
      check('solve(3*(x+5)*(x-4), x)', '[-5,4]');
      check('solve(3*(x+a)*(x-b), x)', '[-a,b]');
      check('solve(a*x^2+b, x)',
          '[a^(-1)*i*sqrt(a)*sqrt(b),-a^(-1)*i*sqrt(a)*sqrt(b)]');
      check('solve(x^2+2*x+1, x)', '[-1]');
      check('solve(-5 sqrt(14)x-14x^2 sqrt(83)-10=0,x)',
          '[(-1/28)*sqrt(-560*sqrt(83)+350)*sqrt(83)^(-1)+(-5/28)*sqrt(14)*sqrt(83)^(-1),(-5/28)*sqrt(14)*sqrt(83)^(-1)+(1/28)*sqrt(-560*sqrt(83)+350)*sqrt(83)^(-1)]');
      check('solve(-5*sqrt(14)x-14x^2*sqrt(83)-10x=0,x)',
          '[(-5/14)*(2+sqrt(14))*sqrt(83)^(-1),0]');
      check('solve(8*x^3-26x^2+3x+9,x)', '[3/4,-1/2,3]');
      check('solve(a*x^2+b*x+c, x)',
          '[(1/2)*(-b+sqrt(-4*a*c+b^2))*a^(-1),(1/2)*(-b-sqrt(-4*a*c+b^2))*a^(-1)]');
      check('solve(sqrt(x^3)+sqrt(x^2)-sqrt(x)=0,x)',
          '[0,78202389238903801/240831735646702201]');
      check('solve(x^3-10x^2+31x-30,x)', '[3,5,2]');
      check('solve(sqrt(x)+sqrt(2x+1)=5,x)', '[4]');
      check('solve(x=2/(3-x),x)', '[1,2]');
      check('solve(1/x=a,x)', '[a^(-1)]');
      check('solve(sqrt(x^2-1),x)', '[1,-1]');
      check('solve(m*x^9+n,x)',
          '[2*m^(-1/9)*n^(1/9),2*e^((2/9)*i*pi)*m^(-1/9)*n^(1/9),2*e^((4/9)*i*pi)*m^(-1/9)*n^(1/9),2*e^((2/3)*i*pi)*m^(-1/9)*n^(1/9),2*e^((8/9)*i*pi)*m^(-1/9)*n^(1/9),2*e^((10/9)*i*pi)*m^(-1/9)*n^(1/9),2*e^((4/3)*i*pi)*m^(-1/9)*n^(1/9),2*e^((14/9)*i*pi)*m^(-1/9)*n^(1/9),2*e^((16/9)*i*pi)*m^(-1/9)*n^(1/9)]');
      check(
          'solve(sqrt(97)x^2-sqrt(13)x+sqrt(14)x+sqrt(43)x^2+sqrt(3)*sqrt(101)=0,x)',
          '[(-1/2)*(sqrt(43)+sqrt(97))^(-1)*sqrt(14)+(1/2)*(sqrt(43)+sqrt(97))^(-1)*sqrt(-2*sqrt(13)*sqrt(14)-4*sqrt(101)*sqrt(3)*sqrt(43)-4*sqrt(101)*sqrt(3)*sqrt(97)+27)+(1/2)*(sqrt(43)+sqrt(97))^(-1)*sqrt(13),(-1/2)*(sqrt(43)+sqrt(97))^(-1)*sqrt(-2*sqrt(13)*sqrt(14)-4*sqrt(101)*sqrt(3)*sqrt(43)-4*sqrt(101)*sqrt(3)*sqrt(97)+27)+(-1/2)*(sqrt(43)+sqrt(97))^(-1)*sqrt(14)+(1/2)*(sqrt(43)+sqrt(97))^(-1)*sqrt(13)]');
      check('solve(a*y^2*x^3-1, x)',
          '[((-1/2)*abs(a^(-1)*y^(-2))+(1/2)*a^(-1)*y^(-2))^(1/3)+((1/2)*a^(-1)*y^(-2)+(1/2)*abs(a^(-1)*y^(-2)))^(1/3),(((-1/2)*abs(a^(-1)*y^(-2))+(1/2)*a^(-1)*y^(-2))^(1/3)+((1/2)*a^(-1)*y^(-2)+(1/2)*abs(a^(-1)*y^(-2)))^(1/3))*((1/2)*i*sqrt(3)+1/2),(((-1/2)*abs(a^(-1)*y^(-2))+(1/2)*a^(-1)*y^(-2))^(1/3)+((1/2)*a^(-1)*y^(-2)+(1/2)*abs(a^(-1)*y^(-2)))^(1/3))*((1/2)*i*sqrt(3)+1/2)^2]');
      check('solve((1/2)*sqrt(-4*x+4*y)-2+y, y)',
          '[(1/2)*(-5+sqrt(-4*x+9)),(-1/2)*(-5-sqrt(-4*x+9))]');
      check('solve(log(a*x-c)-b=21, x)', '[-(-c-e^(21+b))*a^(-1)]');
      check('solve(x/(x-a)+4,x)', '[(4/5)*a]');
      check('solve(3*sin(a^2*x-b)-4,x)', '[a^(-2)*asin(4/3)]');
      check('solve(a*log(x^2-4)-4,x)',
          '[(1/2)*sqrt(16+4*e^(4*a^(-1))),(-1/2)*sqrt(16+4*e^(4*a^(-1)))]');
      check('solve(x/(x^2+2*x+1)+4,x)',
          '[(1/8)*sqrt(17)-9/8,(-1/8)*sqrt(17)-9/8]');
      check('solve((a*x^2+1),x)', '[a^(-1)*sqrt(-a),-a^(-1)*sqrt(-a)]');
      check(
          'solve(sqrt(x)-2x+x^2,x)', '[(-1/2)*sqrt(5)+3/2,0,1,832040/2178309]');
      check('solve((2x+x^2)^2-x,x)',
          '[0,((-1/6)*sqrt(3)^(-1)*sqrt(59)+43/54)^(1/3)+((1/6)*sqrt(3)^(-1)*sqrt(59)+43/54)^(1/3)-4/3,(((-1/6)*sqrt(3)^(-1)*sqrt(59)+43/54)^(1/3)+((1/6)*sqrt(3)^(-1)*sqrt(59)+43/54)^(1/3)-4/3)*((1/2)*i*sqrt(3)+1/2),(((-1/6)*sqrt(3)^(-1)*sqrt(59)+43/54)^(1/3)+((1/6)*sqrt(3)^(-1)*sqrt(59)+43/54)^(1/3)-4/3)*((1/2)*i*sqrt(3)+1/2)^2]');
      check('solve((5*x^4-2)/(x+1)/(x^2-1),x)',
          '[72425485/91070226,-72425485/91070226,(316684236/398209345)*i,(-316684236/398209345)*i]');
      check('solve(0=(x^(2)-2)/(e^(x)-1), x)', '[sqrt(2),-sqrt(2)]');
      check('solve(4/y^2=x^2+1,y)',
          '[(1/2)*(-1-x^2)^(-1)*sqrt(16+16*x^2),(-1/2)*(-1-x^2)^(-1)*sqrt(16+16*x^2)]');
      check('solve(1/(x+x^2), x)', '[]');
      check('solve(1/(x+x^2-1), x)', '[]');
      check('solve(-1+11000*(-100*(10+x)^(-1)+20)^(-2)*(10+x)^(-2), x)',
          '[(1/2)*sqrt(110)-5,(-1/2)*sqrt(110)-5]');
      check('solve(x^3+y^3=3, x)',
          '[((-1/2)*y^3+3/2+abs((-1/2)*y^3+3/2))^(1/3)+((-1/2)*y^3-abs((-1/2)*y^3+3/2)+3/2)^(1/3),(((-1/2)*y^3+3/2+abs((-1/2)*y^3+3/2))^(1/3)+((-1/2)*y^3-abs((-1/2)*y^3+3/2)+3/2)^(1/3))*((1/2)*i*sqrt(3)+1/2),(((-1/2)*y^3+3/2+abs((-1/2)*y^3+3/2))^(1/3)+((-1/2)*y^3-abs((-1/2)*y^3+3/2)+3/2)^(1/3))*((1/2)*i*sqrt(3)+1/2)^2]');
      check('solve(sqrt(10x+186)=x+9,x)', '[7]');
      check('solve(x^3+8=x^2+6,x)', '[-1,1+i,-i+1]');
      check('solve(x^3-10x^2+31x-30,x)', '[3,5,2]');
      check('solve(8x^3-26x^2+3x+9,x)', '[3/4,-1/2,3]');
      check('solve(x^3-1/2x^2-13/2x-3,x)', '[-2,3,-1/2]');
      check('solve(x^3+2x^2+3x-4=0,x)',
          '[0.776045435028538,0.388022717514269+0.6720750612256601*i,-0.388022717514269+0.6720750612256599*i]');
      check('solve(x*log(x),x)', '[1]');
      check(
          'solve((9x+x^2)^3+10800x+40x^4+4440x^2+720x^3+20(9*x+x^2)^2+8000,x) ',
          '[-5,-4]');
      check('solve((x^3-4)/(x^3+7x-11),x)',
          '[1.587401051968199,0.7937005259840910+1.3747296369986024*i,-0.793700525984099+1.374729636998602*i]');
      check('solve((93222358/131836323)*(-2*y+549964829/38888386)=10, y)',
          '[1/3625267041734188]');
      check('solve(sqrt(x)+sqrt(2x+1)=5,x) ', '[4]');
      check('solve(sqrt(x)-1,x) ', '[1]');
      check('solve(sqrt(x)+1,x)', '[]');
      check('solve((x-1)*(x+1)*x=3x,x)', '[0,2,-2]');
      check('solve(sqrt(x^2+1),x)', '[i,-i]');
      check('solve(sqrt(x^2-1),x)', '[1,-1]');
      check('solve(((x+1)*((x+1)+1))/2=n,x)',
          '[-3/2+sqrt(1/4+2*n),-3/2-sqrt(1/4+2*n)]');
      check('solve(sqrt(10x+186)=x+9,x)', '[7]');
      check('solve(x^3+8=x^2+6,x)', '[-1,1+i,-i+1]');
      check('solve(x^2=x^-2,x)', '[1,-1,i,-i]');
      check('solve((x+1)(x+1)x=3x,x)', '[0,-1+sqrt(3),-1-sqrt(3)]');
      check('solve(log(y) = -t, y)', '[e^(-t)]');
      check('solve(y=exp(4x),x)', '[(1/4)*log(y)]');
    });
    test('should solve system of equations correctly', () {
      check('solveEquations(["x+y=1", "2*x=6", "4*z+y=6"])',
          '[x, 3, y, -2, z, 2]');
      check('solveEquations(["x+y=a", "x-y=b", "z+y=c"], ["x", "y", "z"])',
          '[x, 0.5*a+0.5*b, y, -0.5*b+0.5*a, z, c-0.5*a+0.5*b]');
      check('solveEquations(["x-2*y=-3", "x+y-z+2*d=8", "5*d-1=19", "z+d=7"])',
          '[d, 4, x, 1, y, 2, z, 3]');
      // check('solveEquations("x^2+4=x-y")', '(1/2)*(1+sqrt(-15-4*y)),(1/2)*(-sqrt(-15-4*y)+1)'); // Single equation solveEquations?
      check('solveEquations(["x+y=3", "y^3-x=7"])', '[x, 1, y, 2]');
      check('solveEquations(["x^2+y=3", "x+y+z=6", "z^2-y=7"])',
          '[x, 1, y, 2, z, 3]');
      // check('solveEquations(["x*y-cos(z)=-3", "3*z^3-y^2+1=12", "3*sin(x)*cos(y)-x^3=-4"])', 'x,1.10523895006979,y,-2.98980336936266,z,1.88015428627437'); // Numeric solver?
      check('solveEquations(["x=i","x+y=3"])', '[x, i, y, -i+3]');
      // check('solveEquations(["x/(45909438.9 + 0 + x)=0", "45909438.9+0+x=45909438.9"])', 'x,0');
      check('solveEquations(["a=1"])', '[a, 1]');
      // check('solveEquations(["x=5", "0.6=1-(x/(10+y))"])', 'x,5,y,2.5');
    });
    /** #55: nerdamer.solveEquation quits working */
    // test('should handle text("fractions") without later impact', () {
    //     expect(nerdamer.solveEquations("x+1=2", "x").toString(),equals('1'));
    //     expect(nerdamer('x=1').text("fractions"),equals('x=1'));
    //     expect(nerdamer.solveEquations("x+1=2", "x").toString(),equals('1'));
    // });
    // test('should parse equations correctly', () {
    //     expect(nerdamer("-(a+1)=(a+3)^2").toString(),equals('-1-a=(3+a)^2'));
    // });
    // //NOTE: contains duplicates
    // test('should solve functions with factorials', () {
    //     expect(nerdamer('solve(x!-x^2,x)').text('decimals', 20),equals('[-2.200391782610595,-4.010232827899529,-2.938361683501947,1,1.000000000000001,3.562382285390900,3.562382285390896,0.9999999999999910,1.000000000000000]'));
    // });
    test('should solve for variables other than x', () {
      check('solve(2*a^(2)+4*a*6=128, a)', '[4, -16]');
    });
    // test('should solve nonlinear system of equations with multiple parameter functions', () {

    //     check('solveEquations([
    //         "y=x * 2",
    //         "z=y + max (y * 0.1, 23)",
    //         "j=y + max (y * 0.1, 23)",
    //         "6694.895373 = j + z + (max(j * 0.280587, z * 0.280587, 176))"
    //     ])', 'j,2935.601831019821,x,1334.3644686453729,y,2668.7289372907458,z,2935.601831019821');
    // });

    test('should solve factors', () {
      check('solve((x-1)*(-a*c-a*x+c*x+x^2),x)', '[1,-c,a]');
    });

    // test('should solve circle equations', () {
    //     var eq1 ="x^2+y^2=1";
    //     var eq2 ="x+y=1";
    //     var sol = nerdamer.solveEquations([eq1, eq2]);
    //     expect(sol.toString(),equals('x,1,0,y,0,1'));
    // });
  });
}
