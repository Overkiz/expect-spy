# Expect-spy - expect package plugin for spies

The package `expect-spy` is a plugin to [expect](https://github.com/Overkiz/expect) which adds words used
to manage [luassert spies](https://lunarmodules.github.io/busted/#spies-mocks-stubs).

# Installation

You can install `expect-spy` using LuaRocks with the command:

```shell
luarocks install expect-spy
```

# Configuration

In order to use the plugin, you must declare it somewhere in your tests. A good place for this is a file
always read before executing the tests. For that, simply require the module, providing the `expect` object as
parameter.

```lua
local expect = require('expect')
require('expect-spy')(expect)
```

# Usage

## called([count])

If `count` is not provided, asserts that the target spy was called at least once. If `count` is provided,
asserts that the target spy was called exactly the given count of times.

```lua
local s = spy.new(function() end)
s(1, 2, 3)
s(4, 5)

expect(s).to.have.been.called() -- Called at least once
expect(s).to.have.been.called(2) -- Called exactly twice
```

## calledWith([arg1[, arg2[, ...]]])

Asserts that the target spy has been called at least once with the given arguments.

```lua
local s = spy.new(function() end)
s(1, 2, 3)
s(4, 5)

expect(s).to.have.been.calledWith(4, 5)
expect(s).to.have.been.calledWith(1, 2, 3)
```

## returned([val1[, val2[, ...]]])

Asserts that the target spy returned at least once the given values.

```lua
local s = spy.new(function() return 42 end)
s()

expect(s).to.have.returned(42)
```
