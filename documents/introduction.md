---
title: Introduction
---

# Introduction

With great power comes with great responsibility... or something.
While many big number libraries exist in the Roblox ecosystem, there really isn't one that caters specifically to Roblox games.

SerikaNum does exactly that. Its limit, `10^(2^1024)`, or 1 followed by 179 uncentillion zeroes, makes a great choice for incremental
games that need to exceed the normal floating point limit of `2^1024` while not compromising on performance and convenience.

## Installation
SerikaNum is pretty easy to install and use!
To get started, download the library from any of the following options:

1. [Roblox Toolbox](https://create.roblox.com/store/asset/18720686231/SerikaNum)
2. [Wally](https://wally.run/package/evilbocchi/serikanum)
3. [npm for roblox-ts](https://www.npmjs.com/package/@antivivi/serikanum)

## Basic Usage
Example in Lua:
```lua
local OnoeNum = require(path.to.OnoeNum)

local number = OnoeNum.new(5) -- make a new object representing 5
print(number) -- 5
local toAdd = OnoeNum.new(250)
toAdd = toAdd.mul(2) -- You can choose to use the provided macro functions...
number = number + toAdd -- Or simply use metamethods
print(number) -- 505
```

Example in TypeScript:
```ts
import OnoeNum from "@antivivi/OnoeNum";

let number = new OnoeNum(5); // make a new object representing 5
print(number) // 5
let toAdd = new OnoeNum(250);
toAdd = toAdd.mul(2); // You can only use macros due to TypeScript limitations
number = number.add(toAdd)
print(number) // 505
```

