local expect = require('expect')
local luassertSpy = require('luassert.spy')

local function case(name, testedFunction, failure, plain)
  it('should ' .. (failure and 'fail ' or 'pass ') .. name, function()
    if failure then
      expect(testedFunction).to.failWith(failure, plain)
    else
      expect(testedFunction).to.Not.fail()
    end
  end)
end

describe('expect-spy', function()
  local spy

  before_each('create tested spy', function()
    spy = luassertSpy()
  end)

  case('if target is not a spy', function()
    expect(42).to.have.been.called()
  end, 'expected %(number%) 42 to be a spy$')

  case('if target is actually a simple function', function()
    expect(function()
    end).to.have.been.called()
  end, 'expected function.* to be a spy, not the original function$')

  describe('called', function()
    describe('(positive)', function()
      case('if called at least once', function()
        spy()
        expect(spy).to.have.been.called()
        spy()
        expect(spy).to.have.been.called()
      end)

      case('if called exactly count of times', function()
        spy()
        spy()
        expect(spy).to.have.been.called(2)
      end)

      case('if not called', function()
        expect(spy).to.have.been.called()
      end, 'expected spy for function.* to have been called at least once, but it was never called$')

      case('if not called exactly count of times', function()
        spy()
        expect(spy).to.have.been.called(2)
      end, 'expected spy for function.* to have been called exactly 2 times, but it was called 1 time$')
    end)

    describe('(negative)', function()
      case('if called', function()
        spy()
        expect(spy).to.Not.have.been.called()
      end, 'expected spy for function.* to not have been called, but it was called 1 time$')

      case('if called exactly count of times', function()
        spy()
        spy()
        expect(spy).to.Not.have.been.called(2)
      end, 'expected spy for function.* to not have been called exactly 2 times$')

      case('if not called', function()
        expect(spy).to.Not.have.been.called()
      end)

      case('if not called exactly count of times', function()
        spy()
        expect(spy).to.Not.have.been.called(2)
      end)
    end)
  end)

  describe('calledWith', function()
    describe('(positive)', function()
      case('if called with parameters', function()
        spy(1, 2, 3)
        expect(spy).to.have.been.calledWith(1, 2, 3)
      end)

      case('if called with no parameters', function()
        spy()
        expect(spy).to.have.been.calledWith()
      end)

      case('if called with bad parameters', function()
        spy(1, 2, 3)
        expect(spy).to.have.been.calledWith(3, 2, 1)
      end, 'expected spy for function.* to have been called with arguments 3, 2, 1$')

      case('if called without parameters, but parameters are expected', function()
        spy()
        expect(spy).to.have.been.calledWith(2)
      end, 'expected spy for function.* to have been called with arguments 2$')
    end)

    describe('(negative)', function()
      case('if called with parameters', function()
        spy(1, 2, 3)
        expect(spy).to.Not.have.been.calledWith(1, 2, 3)
      end, 'expected spy for function.* to not have been called with arguments 1, 2, 3$')

      case('if called with bad parameters', function()
        spy(1, 2, 3)
        expect(spy).to.Not.have.been.calledWith(3, 2, 1)
      end)
    end)
  end)

  describe('returned', function()
    describe('(positive)', function()
      case('if returned parameter is correct', function()
        spy = luassertSpy(function()
          return 42
        end)
        spy()
        expect(spy).to.have.returned(42)
      end)

      case('if returned parameters are correct', function()
        spy = luassertSpy(function()
          return 42, 'yes'
        end)
        spy()
        expect(spy).to.have.returned(42, 'yes')
      end)

      case('if returned incorrect paramter', function()
        spy = luassertSpy(function()
          return 12
        end)
        spy()
        expect(spy).to.have.returned(42)
      end, 'expected spy for function.* to have returned 42')
    end)

    describe('(negative)', function()
      case('if returned parameter is correct', function()
        spy = luassertSpy(function()
          return 42
        end)
        spy()
        expect(spy).to.Not.have.returned(42)
      end, 'expected spy for function.* to not have returned 42')

      case('if returned incorrect paramter', function()
        spy = luassertSpy(function()
          return 12
        end)
        spy()
        expect(spy).to.Not.have.returned(42)
      end)
    end)
  end)
end)
