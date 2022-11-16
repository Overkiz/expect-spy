local Expect = require('expect.Expect')
local FailureMessage = require('expect.FailureMessage')
local spy = require('luassert.spy')

return function(expect)
  local function ensureSpy(controlData)
    controlData:assert(type(controlData.actual) ~= 'function',
      FailureMessage('expected {#} to be a spy, not the original function'), nil, 2)
    controlData:assert(spy.is_spy(controlData.actual), FailureMessage('expected {#} to be a spy'), nil, 2)
  end

  -- Check the spy was called
  expect.addMethod('called', function(controlData, expectedTimes)
    ensureSpy(controlData)
    local ok, actualTimes = controlData.actual:called(expectedTimes)
    local params = {
      actualFunction = controlData.actual.callback,
      expectedTimes = expectedTimes,
      expectedPlural = (expectedTimes and expectedTimes > 1) and 's' or '',
      actualTimes = actualTimes,
      actualPlural = actualTimes > 1 and 's' or ''
    }
    controlData:assert(ok, FailureMessage(expectedTimes and
                                            'expected spy for {actualFunction} to have been called exactly {!expectedTimes} time{!expectedPlural}, but it was called {!actualTimes} time{!actualPlural}' or
                                            'expected spy for {actualFunction} to have been called at least once, but it was never called',
      params), FailureMessage(expectedTimes and
                                'expected spy for {actualFunction} to not have been called exactly {!expectedTimes} time{!expectedPlural}' or
                                'expected spy for {actualFunction} to not have been called, but it was called {!actualTimes} time{!actualPlural}',
      params))
  end)

  -- Check the spy called arguments
  expect.addMethod('calledWith', function(controlData, ...)
    ensureSpy(controlData)
    local params = {
      actualFunction = controlData.actual.callback,
      arguments = setmetatable({...}, {
        __tostring = function(arguments)
          local result = ''
          for i = 1, #arguments do
            if i > 1 then
              result = result .. ', '
            end
            result = result .. tostring(arguments[i])
          end
          return result
        end
      })
    }
    local arguments = {...}
    arguments.n = #arguments
    controlData:assert(controlData.actual:called_with(arguments), FailureMessage(
      'expected spy for {actualFunction} to have been called with arguments {!arguments}', params), FailureMessage(
      'expected spy for {actualFunction} to not have been called with arguments {!arguments}', params))
  end)
end
