import 'package:test/test.dart';
import 'package:advance_math/advance_math.dart';

void main() {
  var expression = ExpressionParser();

  group('Nerdamer algebra', () {
    test('should perform gcd operations correctly', () {
      expect(
          expression
              .parse('gcd(5*x^6+5*x^5+27*x^4+27*x^3+28*x^2+28*x, 5*x^3+7*x)')
              .evaluate()
              .toString(),
          equals('5*x^3+7*x'));
      expect(expression.parse('gcd(-20+16*i,-10+8*i)').evaluate().toString(),
          equals('-10+8*i'));
      expect(expression.parse('gcd(2*x^2+2*x+1,x+1)').evaluate().toString(),
          equals('1'));
      expect(expression.parse('gcd(x^2+2*x+1,x+1)').evaluate().toString(),
          equals('1+x'));
      expect(
          expression
              .parse('gcd(6*x^9+24*x^8+15*x^7+6*x^2+24*x+15, (2*x^2+8*x+5))')
              .evaluate()
              .toString(),
          equals('2*x^2+8*x+5'));
      expect(
          expression
              .parse('gcd(x^8+4*x^7+4*x^6+3*x^5+12*x^4+12*x^3, (x^3+3))')
              .evaluate()
              .toString(),
          equals('3+x^3'));
      expect(
          expression
              .parse('gcd(6*x^9+24*x^8+15*x^7+6*x^2+24*x+15, x^7+1)')
              .evaluate()
              .toString(),
          equals('1+x^7'));
      expect(expression.parse('gcd(1+x^2,2*x)').toString(), equals('1'));
      expect(
          expression
              .parse(
                  'gcd(84*x^4+147*x^3+16*x^2+28*x, 44*x^5+77*x^4+16*x^3+28*x^2+12*x+21)')
              .toString(),
          equals('4*x+7'));
      expect(
          expression
              .parse(
                  'gcd(5*x^11+90*x^9+361*x^7+473*x^5+72*x^3+91*x, 7150*x^12+9360*x^10+1375*x^9+1430*x^8+37550*x^7+1872*x^6+47075*x^5+7510*x^3+9360*x)')
              .toString(),
          equals('5*x^5+x'));
      expect(
          expression
              .parse(
                  'gcd(7*x^4+7*x^3+4*x^2+5*x+1, 21*x^6+47*x^4+80*x^3+20*x^2+49*x+11)')
              .toString(),
          equals('1+4*x+7*x^3'));
      expect(
          expression
              .parse(
                  'gcd(5*x^11+90*x^9+361*x^7+473*x^5+72*x^3+91*x, 7150*x^12+9360*x^10+1375*x^9+1430*x^8+37550*x^7+1872*x^6+47075*x^5+7510*x^3+9360*x,x)')
              .toString(),
          equals('x'));
      expect(
          expression
              .parse('gcd(x^8+4*x^7+4*x^6+3*x^5+12*x^4+12*x^3, (x^3+3), 3+x^3)')
              .toString(),
          equals('3+x^3'));
      expect(expression.parse('gcd(a, b, c)').toString(), equals('gcd(a,b,c)'));
      expect(expression.parse('gcd(18,12, 6)').toString(), equals('6'));
      expect(expression.parse('gcd(3, 5, 7)').toString(), equals('1'));
      expect(expression.parse('gcd(1/2, 1/3, 1/4)').toString(), equals('1/12'));
      expect(expression.parse('gcd(5%, 15%, 25%)').toString(), equals('1/20'));
      expect(expression.parse('gcd(1/a, 1/b, 1/c)').toString(),
          equals('gcd(a^(-1),b^(-1),c^(-1))'));
      expect(expression.parse('gcd(2^x, 6^x)').toString(), equals('2^x'));
      expect(
          expression
              .parse('gcd(a, b, c, gcd(x, y, z, gcd(f,gcd(g,h))))')
              .toString(),
          equals('gcd(a,b,c,x,y,z,f,g,h)'));
      expect(expression.parse('gcd(2^x, 6^x)').toString(), equals('2^x'));
      expect(expression.parse('gcd(a,a,b,b,gcd(c,c))').toString(), equals('1'));
      expect(expression.parse('gcd(a,a)').toString(), equals('a'));
      expect(expression.parse('gcd(a^b,a^c)').toString(), equals('a'));
      expect(expression.parse('gcd(a^c,b^c)').toString(), equals('1'));
      expect(expression.parse('gcd(a^a,a^a)').toString(), equals('a^a'));
    });

    test('should perform lcm operations correctly', () {
      expect(
          expression
              .parse('lcm(5*x^6+5*x^5+27*x^4+27*x^3+28*x^2+28*x, 5*x^3+7*x)')
              .evaluate(),
          equals('27*x^3+27*x^4+28*x+28*x^2+5*x^5+5*x^6'));
      expect(expression.parse('lcm(-20+16*i,-10+8*i)').evaluate(),
          equals('-10+8*i'));
      expect(expression.parse('lcm(2*x^2+2*x+1,x+1)').evaluate(),
          equals('(1+2*x+2*x^2)*(1+x)'));
      expect(expression.parse('lcm(x^2+2*x+1,x+1)').evaluate(),
          equals('1+2*x+x^2'));
      expect(
          expression
              .parse('lcm(6*x^9+24*x^8+15*x^7+6*x^2+24*x+15, (2*x^2+8*x+5))')
              .evaluate(),
          equals('15+15*x^7+24*x+24*x^8+6*x^2+6*x^9'));
      expect(
          expression
              .parse('lcm(x^8+4*x^7+4*x^6+3*x^5+12*x^4+12*x^3, (x^3+3))')
              .toString(),
          equals('12*x^3+12*x^4+3*x^5+4*x^6+4*x^7+x^8'));
      expect(
          expression
              .parse('lcm(6*x^9+24*x^8+15*x^7+6*x^2+24*x+15, x^7+1)')
              .toString(),
          equals('15+15*x^7+24*x+24*x^8+6*x^2+6*x^9'));
      expect(
          expression.parse('lcm(1+x^2,2*x)').toString(), equals('2*(1+x^2)*x'));
      expect(
          expression
              .parse(
                  'lcm(84*x^4+147*x^3+16*x^2+28*x, 44*x^5+77*x^4+16*x^3+28*x^2+12*x+21)')
              .toString(),
          equals(
              '(12*x+16*x^3+28*x^2+44*x^5+77*x^4+21)*(147*x^3+16*x^2+28*x+84*x^4)*(4*x+7)^(-1)'));
      expect(
          expression
              .parse(
                  'lcm(5*x^11+90*x^9+361*x^7+473*x^5+72*x^3+91*x, 7150*x^12+9360*x^10+1375*x^9+1430*x^8+37550*x^7+1872*x^6+47075*x^5+7510*x^3+9360*x)')
              .toString(),
          equals(
              '(1375*x^9+1430*x^8+1872*x^6+37550*x^7+47075*x^5+7150*x^12+7510*x^3+9360*x+9360*x^10)*(361*x^7+473*x^5+5*x^11+72*x^3+90*x^9+91*x)*(5*x^5+x)^(-1)'));
      expect(
          expression
              .parse(
                  'lcm(7*x^4+7*x^3+4*x^2+5*x+1, 21*x^6+47*x^4+80*x^3+20*x^2+49*x+11)')
              .toString(),
          equals(
              '(1+4*x+7*x^3)^(-1)*(1+4*x^2+5*x+7*x^3+7*x^4)*(11+20*x^2+21*x^6+47*x^4+49*x+80*x^3)'));
      expect(
          expression
              .parse(
                  'lcm(5*x^11+90*x^9+361*x^7+473*x^5+72*x^3+91*x, 7150*x^12+9360*x^10+1375*x^9+1430*x^8+37550*x^7+1872*x^6+47075*x^5+7510*x^3+9360*x,x)')
              .toString(),
          equals(
              '(1375*x^9+1430*x^8+1872*x^6+37550*x^7+47075*x^5+7150*x^12+7510*x^3+9360*x+9360*x^10)*(361*x^7+473*x^5+5*x^11+72*x^3+90*x^9+91*x)*(5*x^6+x^2)^(-1)*x'));
      expect(
          expression
              .parse('lcm(x^8+4*x^7+4*x^6+3*x^5+12*x^4+12*x^3, (x^3+3), 3+x^3)')
              .toString(),
          equals(
              '(12*x^3+12*x^4+3*x^5+4*x^6+4*x^7+x^8)*(3+x^3)^2*(6*x^3+x^6+9)^(-1)'));
      expect(expression.parse('lcm(a, b, c)').toString(),
          equals('a*b*c*gcd(a*b,a*c,b*c)^(-1)'));
      expect(expression.parse('lcm(18,12, 6)').toString(), equals('36'));
      expect(expression.parse('lcm(3, 5, 7)').toString(), equals('105'));
      expect(expression.parse('lcm(1/2, 1/3, 1/4)').toString(), equals('1'));
      expect(expression.parse('lcm(5%, 15%, 25%)').toString(), equals('3/4'));
      expect(expression.parse('lcm(1/a, 1/b, 1/c)').toString(), equals('1'));
      expect(expression.parse('lcm(2^x, 6^x)').toString(), equals('6^x'));
      expect(
          expression
              .parse('lcm(a, b, c, gcd(x, y, z, gcd(f,gcd(g,h))))')
              .toString(),
          equals('a*b*c*gcd(x,y,z,f,g,h)'));
      expect(expression.parse('lcm(2^x, 6^x)').toString(), equals('6^x'));
      expect(
          expression.parse('lcm(a,a,b,b,gcd(c,c))').toString(),
          equals(
              'a^2*b^2*c*gcd(a^2*b^2,a^2*b*c,a^2*b*c,a*b^2*c,a*b^2*c)^(-1)'));
      expect(
          expression.parse('lcm(a,a)').toString(), equals('a^2*gcd(a,a)^(-1)'));
      expect(expression.parse('lcm(a^b,a^c)').toString(), equals('a^(-1+b+c)'));
      expect(expression.parse('lcm(a^c,b^c)').toString(), equals('a^c*b^c'));
      expect(expression.parse('lcm(a^a,a^a)').toString(), equals('a^a'));
    });

    group('isPoly', () {
      test('should detect polynomials', () {
        expect(expression.parse('51').isPoly(true), equals(true));
        expect(expression.parse('x^2+1').isPoly(true), equals(true));
        expect(expression.parse('51/x').isPoly(true), equals(false));
        expect(expression.parse('x^2+1/x').isPoly(true), equals(false));
        expect(expression.parse('y*x^2+1/x').isPoly(true), equals(false));
        expect(expression.parse('y*x^2+x').isPoly(true), equals(true));
        expect(expression.parse('7*y*x^2+z*x+4').isPoly(true), equals(true));
        expect(
            expression.parse('7*y*x^2+z*x^-1+4').isPoly(true), equals(false));
        expect(expression.parse('sqrt(5*x)+7').isPoly(true), equals(false));
        expect(expression.parse('abs(5*x^3)-x+7').isPoly(true), equals(false));
        expect(
            expression.parse('cos(x)^2+cos(x)+1').isPoly(true), equals(false));
        expect(
            expression
                .parse(
                    'sqrt(97)*x^2-sqrt(13)*x+sqrt(14)*x+sqrt(43)*x^2+sqrt(3)*sqrt(101)')
                .isPoly(true),
            equals(false));
        expect(expression.parse('-5 *sqrt(14)*x-14*x^2 *sqrt(83)').isPoly(true),
            equals(false));
      });

      test('should evaluate abs() directly', () {
        // given
        var formula = 'abs(5*x^2)-x+11';

        // when
        var isPoly = expression.parse(formula).simplify().isPoly();

        // then
        expect(isPoly, equals(true));
      });
    });

    test('should perform divisions', () {
      expect(
          expression
              .parse('div(x^2*y^3+b*y^2+3*a*x^2*y+3*a*b, y^2+3*a)')
              .toString(),
          equals('[b+x^2*y,0]'));
      expect(expression.parse('div(x^2, x^3)').toString(), equals('[0,x^2]'));
      expect(
          expression
              .parse('div(cos(x^2)^2+2*cos(x^2)+1, cos(x^2)+1)')
              .toString(),
          equals('[1+cos(x^2),0]'));
      expect(expression.parse('div(2*x^2+2*x+1, x+1)').toString(),
          equals('[2*x,1]'));
      expect(expression.parse('div(7*x,2*x)').toString(), equals('[7/2,0]'));
      expect(
          expression
              .parse(
                  'div(7*b*z^2+14*y*z+14*a*x^2*z-b*t*z-2*t*y-2*a*t*x^2, 7*z-t)')
              .toString(),
          equals('[2*a*x^2+2*y+b*z,0]'));
      expect(
          expression.parse('div(x^2+5, y-1)').toString(), equals('[0,5+x^2]'));
      expect(
          expression
              .parse('div(4*a*x^2*y^2+4*a*y^2+b*x^2+a*x^2+b+a, x^2+1)')
              .toString(),
          equals('[4*a*y^2+a+b,0]'));
      expect(
          expression
              .parse('div(4*a*x^2*y^2+4*a*y^2+b*x^2+a*x^2+b+a+u^6+1, x^2+1)')
              .toString(),
          equals('[4*a*y^2+a+b,1+u^6]'));
      expect(
          expression
              .parse(
                  'div(15*x^9-25*x^7-35*x^6+6*x^5+3*x^4-10*x^3-19*x^2-7*x, 3*x^3-5*x-7)')
              .toString(),
          equals('[2*x^2+5*x^6+x,0]'));
      expect(
          expression
              .parse(
                  'div(sin(x)^2*tan(x)-4*cos(x)*tan(x)+cos(x)*sin(x)^2-4*cos(x)^2, sin(x)^2-4*cos(x)^2)')
              .toString(),
          equals(
              '[cos(x)+tan(x),-4*cos(x)*tan(x)-4*cos(x)^2+4*cos(x)^3+4*cos(x)^2*tan(x)]'));
      expect(
          expression
              .parse('div(y^2*z-4*x*z+x*y^2-4*x^2, y^2-4*x^2)')
              .toString(),
          equals('[x+z,-4*x*z-4*x^2+4*x^3+4*x^2*z]'));
      expect(
          expression
              .parse('div(-5*y^2+16*a*y+5*x^4+14*a*x^2-3*a^2, 3*a-y+x^2)')
              .toString(),
          equals('[-a+5*x^2+5*y,0]'));
      expect(expression.parse('div(y^2+2*x*y+x^2,x+y)').toString(),
          equals('[x+y,0]'));
      expect(expression.parse('div(x*y^2+x^2*y-y-x, x*y-1)').toString(),
          equals('[x+y,0]'));
      expect(
          expression
              .parse('div(y^2*z-4*x*z+x*y^2-4*x^2+x^2, y^2-4*x^2)')
              .toString(),
          equals('[x+z,-3*x^2+4*x^3-4*x*z+4*x^2*z]'));
      expect(
          expression
              .parse(
                  'div(7*x^6*z-a*x*z+28*a*x^6*y^3-4*a^2*x*y^3+7*b*x^6-a*b*x, 4*y^3*a+z+b)')
              .toString(),
          equals('[-a*x+7*x^6,0]'));
      expect(expression.parse('div(x^2+5, cos(x)-1)').toString(),
          equals('[0,5+x^2]'));
      expect(
          expression.parse('div((1+z), t*x+7)').toString(), equals('[0,1+z]'));
      expect(
          expression.parse('div(-x^2*y-y+4*a*x^2+t+4*a+6*b, x^2+1)').toString(),
          equals('[-y+4*a,6*b+t]'));
      expect(
          expression
              .parse(
                  'div(15*x^9-25*x^7-35*x^6+6*x^5+3*x^4-10*x^3-19*x^2-7*x+y, 3*x^3-5*x-7)')
              .toString(),
          equals('[2*x^2+5*x^6+x,y]'));
      expect(expression.parse('div(x^2+2*x+1+u, x+1)').toString(),
          equals('[1+x,u]'));
      expect(expression.parse('div(y^3+x*y^2+x^2*y+x^3+x, x+y)').toString(),
          equals('[x^2+y^2,x]'));
      expect(
          expression
              .parse(
                  'div(b*y*z+7*x^6*z-a*x*z-7*z+4*a*b*y^4+28*a*x^6*y^3-4*a^2*x*y^3-28*a*y^3+b^2*y+7*b*x^6-a*b*x-7*b, 4*y^3*a+z+b)')
              .toString(),
          equals('[-7-a*x+7*x^6+b*y,0]'));
      expect(
          expression
              .parse(
                  'div(b*y*z-a*x*z+4*a*b*y^4-4*a^2*x*y^3+b^2*y-a*b*x, 4*y^3*a+z+b)')
              .toString(),
          equals('[-a*x+b*y,0]'));
      expect(
          expression.parse('div(17*x^3*y+3*x^2*y+34*x+6, x^2*y+2)').toString(),
          equals('[17*x+3,0]'));
      expect(
          expression
              .parse(
                  'div(b^2*y^2+2*a*b*y^2+a^2*y^2+2*b^2*x*y+4*a*b*x*y+2*a^2*x*y+b^2*x^2+2*a*b*x^2+a^2*x^2, 2*b*y^2+2*a*y^2+4*b*x*y+4*a*x*y+2*b*x^2+2*a*x^2)')
              .toString(),
          equals('[(1/2)*a+(1/2)*b,0]'));
      expect(
          expression
              .parse('div(2*a*b*x+2*a*b*y+a^2*x+a^2*y+b^2*x+b^2*y, x+y)')
              .toString(),
          equals('[2*a*b+a^2+b^2,0]'));
      expect(expression.parse('div((2x-1)(3x^2+5x-2)-7x-14,x^2+1)').toString(),
          equals('[6*x+7,-19-22*x]'));
      expect(expression.parse('div(2(x+1)^5+1,x+2)').toString(),
          equals('[2+2*x^4+4*x+6*x^3+8*x^2,-1]'));
      expect(expression.parse('divide(a*b^(-1)+b^(-1)*c,a+c)').toString(),
          equals('b^(-1)'));
      expect(
          expression.parse('divide(-20+16*i,-10+8*i)').toString(), equals('2'));
    });

    /** #3: "(a-b)^2 - (b-a)^2" not simplifying. */
    test('should simplify to 0', () {
      // given
      var formula = '(a-b)^2-(b-a)^2';

      // when
      var result = expression.parse(formula).simplify().toString();

      // then
      expect(result, equals('0'));
    });
    /** #40: Expected more simple solution for factoring. */
    test('should use simple factor result', () {
      // given
      var formula = 'factor(x^2+x+1/4)';

      // when
      var result = expression.parse(formula).toString();

      // then
      expect(result, equals('(1/4)*(1+2*x)^2'));
    });

    /** #43: Formula not expanded. */
    test('should expand formula', () {
      // given
      var formula = 'expand((x+5)(x-3)-x^2)';

      // when
      var result = expression.parse(formula).expand().simplify().toString();

      // then
      expect(result, equals('-15+2*x'));
    });

    test('should factor correctly', () {
      expect(
          expression.parse('factor(x^2+2*x+1)').toString(), equals('(1+x)^2'));
      expect(expression.parse('factor(x^2-y^2)').toString(),
          equals('(-y+x)*(x+y)'));
      expect(expression.parse('factor(a^2*x^2-b^2*y^2)').toString(),
          equals('(-b*y+a*x)*(a*x+b*y)'));
      expect(expression.parse('factor(x^2-6*x+9-4*y^2)').toString(),
          equals('(-2*y-3+x)*(-3+2*y+x)'));
      expect(expression.parse('factor(b^6+3*a^2*b^4+3*a^4*b^2+a^6)').toString(),
          equals('(a^2+b^2)^3'));
      expect(
          expression
              .parse('factor(b^6+12*a^2*b^4+48*a^4*b^2+64*a^6)')
              .toString(),
          equals('((9007199254740996/2251799813685249)*a^2+b^2)^3'));
      expect(
          expression
              .parse(
                  'factor(c^6+3*b^2*c^4+3*a^2*c^4+3*b^4*c^2+6*a^2*b^2*c^2+3*a^4*c^2+b^6+3*a^2*b^4+3*a^4*b^2+a^6)')
              .toString(),
          equals('(a^2+b^2+c^2)^3'));
      expect(
          expression.parse('factor(x^4+25*x^3+234*x^2+972*x+1512)').toString(),
          equals('(6+x)^3*(7+x)'));
      expect(
          expression
              .parse('factor(x^5+32*x^4+288*x^3-418*x^2-16577*x-55902)')
              .toString(),
          equals('(-7+x)*(11+x)^3*(6+x)'));
      expect(expression.parse('factor(x^2*y*z+x*z+t*x^2*y+t*x)').toString(),
          equals('(1+x*y)*(t+z)*x'));
      expect(expression.parse('factor(x^2*y+x^2)').toString(),
          equals('(1+y)*x^2'));
      expect(expression.parse('factor(sqrt(4*x^2*y+4*x^2))').toString(),
          equals('2*abs(x)*sqrt(1+y)'));
      expect(expression.parse('factor(x^3-1/2x^2-13/2x-3)').toString(),
          equals('(1/2)*(-3+x)*(1+2*x)*(2+x)'));
      expect(expression.parse('factor(x^16-1)').toString(),
          equals('(-1+x)*(1+x)*(1+x^2)*(1+x^4)*(1+x^8)'));
      expect(
          expression
              .parse(
                  'factor(-1866240-311040*x^2-3265920*x+1120*x^8+150080*x^6+17610*x^7+2026080*x^4+2509920*x^3+30*x^9+738360*x^5)')
              .toString(),
          equals('10*(-1+x)*(1+x)*(3*x+4)*(6+x)^6'));
      expect(
          expression.parse('factor((7x^3+4x^2+x)/(12x^3+6x^2-2x))').toString(),
          equals('(1/2)*(-1+3*x+6*x^2)^(-1)*(1+4*x+7*x^2)'));
      expect(expression.parse('factor((-2x-2x^2-2))').toString(),
          equals('-2*(1+x+x^2)'));
      expect(expression.parse('factor(1331*x^3*y^3+216*z^6)').toString(),
          equals('(-66*x*y*z^2+121*x^2*y^2+36*z^4)*(11*x*y+6*z^2)'));
      expect(expression.parse('factor(1331*x^3*y^3-216*z^6)').toString(),
          equals('(-6*z^2+11*x*y)*(121*x^2*y^2+36*z^4+66*x*y*z^2)'));
      expect(expression.parse('factor(64a^3-27b^3)').toString(),
          equals('(-3*b+4*a)*(12*a*b+16*a^2+9*b^2)'));
      expect(expression.parse('factor(64*x^3+125)').toString(),
          equals('(-20*x+16*x^2+25)*(4*x+5)'));
      expect(expression.parse('factor((-5*K+32)^2)').toString(),
          equals('(-32+5*K)^2'));
      expect(expression.parse('factor(100)').toString(), equals('2^2*5^2'));
      expect(expression.parse('factor(100*x)').toString(), equals('100*x'));
      expect(expression.parse('(2*y+p)^2').toString(), equals('(2*y+p)^2'));
    });
    test('should not have any regression to factor', () {
      //this test will absolutely break as factor improves enough to factor this expression. For now it just serves as a safeguard
      expect(expression.parse('factor(x^a+2x^(a-1)+1x^(a-2))').toString(),
          equals('2*x^(-1+a)+x^(-2+a)+x^a'));
    });
    test('should correctly determine the polynomial degree', () {
      expect(expression.parse('deg(x^2+2*x+x^5)').toString(), equals('5'));
      expect(
          expression.parse('deg(x^2+2*x+x^x)').toString(), equals('max(2,x)'));
      expect(expression.parse('deg(x^2+2*x+cos(x))').toString(), equals('2'));
      expect(expression.parse('deg(x^a+x^b+x^c,x)').toString(),
          equals('max(a,b,c)'));
      expect(expression.parse('deg(a*x^2+b*x+c,x)').toString(), equals('2'));
    });
    test('should correctly peform partial fraction decomposition', () {
      expect(expression.parse('partfrac((3*x+2)/(x^2+x), x)').toString(),
          equals('(1+x)^(-1)+2*x^(-1)'));
      expect(expression.parse('partfrac((17*x-53)/(x^2-2*x-15), x)').toString(),
          equals('13*(3+x)^(-1)+4*(-5+x)^(-1)'));
      expect(expression.parse('partfrac((x^3+2)/(x+1)^2,x)').toString(),
          equals('(1+x)^(-2)+3*(1+x)^(-1)-2+x'));
      expect(expression.parse('partfrac(x/(x-1)^2, x)').toString(),
          equals('(-1+x)^(-1)+(-1+x)^(-2)'));
      expect(expression.parse('partfrac((x^2+1)/(x*(x-1)^3), x)').toString(),
          equals('(-1+x)^(-1)+2*(-1+x)^(-3)-x^(-1)'));
      expect(expression.parse('partfrac((17-53)/(x^2-2*x-15), x)').toString(),
          equals('(-9/2)*(-5+x)^(-1)+(9/2)*(3+x)^(-1)'));
      expect(
          expression.parse('partfrac(1/(x^6-1),x)').toString(),
          equals(
              '(-1/3)*(-x+x^2+1)^(-1)+(-1/3)*(1+x+x^2)^(-1)+(-1/6)*(1+x)^(-1)+(-1/6)*(1+x+x^2)^(-1)*x+(1/6)*(-1+x)^(-1)+(1/6)*(-x+x^2+1)^(-1)*x'));
      expect(
          expression
              .parse('partfrac((3*x^2-3*x-8)/((x-5)*(x^2+x-4)),x)')
              .toString(),
          equals('(-4+x+x^2)^(-1)*x+2*(-5+x)^(-1)'));
      expect(
          expression
              .parse(
                  'partfrac(15*(9+s^2)^(-1)*cos(1)+5*(9+s^2)^(-1)*s*sin(1),s)')
              .toString(),
          equals('(15*cos(1)+5*s*sin(1))*(9+s^2)^(-1)'));
    });
    test('should prime factor correctly', () {
      expect(
          expression.parse('pfactor(100!)').toString(),
          equals(
              '(11^9)*(13^7)*(17^5)*(19^5)*(23^4)*(29^3)*(2^97)*(31^3)*(37^2)*(3^48)*(41^2)*(43^2)*(47^2)*(53)*(59)*(5^24)*(61)*(67)*(71)*(73)*(79)*(7^16)*(83)*(89)*(97)'));
      expect(
          expression.parse('pfactor(100)').toString(), equals('(2^2)*(5^2)'));
      expect(expression.parse('pfactor(8)').toString(), equals('(2^3)'));
      expect(expression.parse('pfactor(999999999999)').toString(),
          equals('(101)*(11)*(13)*(37)*(3^3)*(7)*(9901)'));
      expect(expression.parse('pfactor(1000000005721)').toString(),
          equals('(1000000005721)'));
      expect(expression.parse('pfactor(1000000005721092)').toString(),
          equals('(131)*(212044106387)*(2^2)*(3^2)'));
      expect(expression.parse('pfactor(-10000000114421840327308)').toString(),
          equals('(-2^2)*(480827)*(7)*(8345706745687)*(89)'));
      expect(expression.parse('pfactor(-7877474663)').toString(),
          equals('(-97)*(180871)*(449)'));
      expect(expression.parse('pfactor(15!+1)').toString(),
          equals('(46271341)*(479)*(59)'));
      expect(expression.parse('pfactor(15!+11!)').toString(),
          equals('(11)*(181^2)*(2^8)*(3^4)*(5^2)*(7)'));
      expect(expression.parse('pfactor(product(n!,n,1,10))').toString(),
          equals('(2^38)*(3^17)*(5^7)*(7^4)'));
      expect(expression.parse('pfactor(4677271)').toString(),
          equals('(2089)*(2239)'));
    });
    test('should get coeffs', () {
      expect(expression.parse('coeffs(x^2+2*x+1, x)').toString(),
          equals('[1,2,1]'));
      expect(expression.parse('coeffs(a*b*x^2+c*x+d, x)').toString(),
          equals('[d,c,a*b]'));
      expect(expression.parse('coeffs(t*x, x)').toString(), equals('[0,t]'));
      expect(expression.parse('coeffs(b*(t*x-5), x)').toString(),
          equals('[-5*b,b*t]'));
      expect(expression.parse('coeffs(a*x^2+b*x+c+x, x)').toString(),
          equals('[c,1+b,a]'));
    });
    test('should get all coeffs', () {
      expect(expression.parse('coeffs(x+A+1,x)').toString(), equals('[1+A,1]'));
      expect(expression.parse('coeffs(2x+i*x+5, x)').toString(),
          equals('[5,2+i]'));
    });
    test('should calculate the line function', () {
      expect(expression.parse('line([1,2], [3,4])').toString(), equals('1+x'));
      expect(expression.parse('line([a1,b1], [a2,b2], t)').toString(),
          equals('(-a1+a2)^(-1)*(-b1+b2)*t-(-a1+a2)^(-1)*(-b1+b2)*a1+b1'));
    });
    test('should simplify correctly', () {
      expect(expression.parse('simplify(sin(x)^2+cos(x)^2)').toString(),
          equals('1'));
      expect(expression.parse('simplify(1/2*sin(x^2)^2+cos(x^2)^2)').toString(),
          equals('(1/4)*(3+cos(2*x^2))'));
      expect(
          expression.parse('simplify(0.75*sin(x^2)^2+cos(x^2)^2)').toString(),
          equals('(1/8)*(7+cos(2*x^2))'));
      expect(
          expression
              .parse(
                  'simplify(cos(x)^2+sin(x)^2+cos(x)-tan(x)-1+sin(x^2)^2+cos(x^2)^2)')
              .toString(),
          equals('-tan(x)+1+cos(x)'));
      expect(expression.parse('simplify((x^2+4*x-45)/(x^2+x-30))').toString(),
          equals('(6+x)^(-1)*(9+x)'));
      expect(expression.parse('simplify(1/(x-1)+1/(1-x))').toString(),
          equals('0'));
      expect(
          expression.parse('simplify((x-1)/(1-x))').toString(), equals('-1'));
      expect(expression.parse('simplify((x^2+2*x+1)/(x+1))').toString(),
          equals('1+x'));
      expect(
          expression
              .parse('simplify((- x + x^2 + 1)/(x - x^2 - 1))')
              .toString(),
          equals('-1'));
      expect(expression.parse('simplify(n!/(n+1)!)').toString(),
          equals('(1+n)^(-1)'));
      expect(
          expression
              .parse('simplify((17/2)*(-10+8*i)^(-1)-5*(-10+8*i)^(-1)*i)')
              .toString(),
          equals('(-9/82)*i-125/164'));
      expect(expression.parse('simplify((-2*i+7)^(-1)*(3*i+4))').toString(),
          equals('(29/53)*i+22/53'));
      expect(
          expression
              .parse(
                  'simplify(((17/2)*(-5*K+32)^(-1)*K^2+(5/2)*K-125*(-5*K+32)^(-1)*K-16+400*(-5*K+32)^(-1))*(-17*(-5*K+32)^(-1)*K+80*(-5*K+32)^(-1))^(-1))')
              .toString(),
          equals('(-35*K+4*K^2+112)*(-80+17*K)^(-1)'));
      expect(expression.parse('simplify(((a+b)^2)/c)').toString(),
          equals('(a+b)^2*c^(-1)'));
      expect(expression.parse('simplify(-(-5*x - 9 + 2*y))').toString(),
          equals('-2*y+5*x+9'));
      expect(expression.parse('simplify(a/b+b/a)').toString(),
          equals('(a*b)^(-1)*(a^2+b^2)'));
      expect(expression.parse('simplify(((2*e^t)/(e^t))+(1/(e^t)))').toString(),
          equals('(1+2*e^t)*e^(-t)'));
      expect(expression.parse('simplify((-3/2)x+(1/3)y+2+z)').toString(),
          equals('(1/6)*(-9*x+12+2*y+6*z)'));
    });
    test('should also simplify', () {
      //expect(nerdamer('6/sqrt(3)')).toEqual();
    });
    test('should calculate nth roots correctly', () {
      expect(
          expression.parse('roots((-1)^(1/5))').evaluate().text(),
          equals(
              '[0.5877852522924731*i+0.809016994374947,-0.309016994374947+0.9510565162951536*i,-1,-0.309016994374948-0.9510565162951536*i,-0.5877852522924734*i+0.809016994374947]'));
      expect(expression.parse('roots((2)^(1/3))').evaluate().text(),
          equals('[1.122462048309381,-1.122462048309381]'));
    });
    // As mentioned by @Happypig375 in issue #219
    test('should also factor correctly', () {
      expect(expression.parse('factor((x^2+4x+4)-y^2)').toString(),
          equals('(-y+2+x)*(2+x+y)'));
      expect(expression.parse('factor(81-(16a^2-56a+49))').toString(),
          equals('-8*(-4+a)*(1+2*a)'));
      expect(expression.parse('factor((9x^2-12x+4)-25)').toString(),
          equals('3*(-7+3*x)*(1+x)'));
      expect(expression.parse('factor((x^2+4x+4)+x*y+2y)').toString(),
          equals('(2+x)*(2+x+y)'));
      expect(expression.parse('factor((4x^2+24x+36)-14x*y-42y)').toString(),
          equals('2*(-7*y+2*x+6)*(3+x)'));
      expect(expression.parse('factor(35a*b-15b+(49a^2-42a+9))').toString(),
          equals('(-3+5*b+7*a)*(-3+7*a)'));
      expect(expression.parse('factor(1-6a^2+9a^4)').toString(),
          equals('(-1+3*a^2)^2'));
      expect(expression.parse('factor(1-6a^2+9a^4-49b^2)').toString(),
          equals('(-1+3*a^2+7*b)*(-1-7*b+3*a^2)'));
    });
    test('should complete the square', () {
      expect(
          expression.parse('sqcomp(a*x^2+b*x-11*c, x)').toString(),
          equals(
              '((1/2)*abs(b)*sqrt(a)^(-1)+sqrt(a)*x)^2+(-1/4)*(abs(b)*sqrt(a)^(-1))^2-11*c'));
      expect(expression.parse('sqcomp(9*x^2-18*x+17)').toString(),
          equals('(-3+3*x)^2+8'));
      expect(expression.parse('sqcomp(s^2+s+1)').toString(),
          equals('(1/2+s)^2+3/4'));
    });
  });
}
