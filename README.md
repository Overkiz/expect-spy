# Expect-spy - expect package plugin for spies

The package `expect-spy` is a plugin to [expect](https://github.com/sveyret/expect) which adds words used
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
