local call = require("./src/call")
local types = require("./src/types/type")

local process = require("@lune/process")
process.create("python", {"numpy_.py"}, {cwd = "./Modules/numpy/_index/src/lib"})

return {
    mean = function(values: {number}) : number
        return call("mean", values)
    end,

    median = function(values: {number}) : number
        return call("median", values)
    end,

    sum = function(values: {number}) : number
        return call("sum", values)
    end,

    std = function(values: {number}) : number
        return call("std", values)
    end,

    var = function(values: {number}) : number
        return call("var", values)
    end,

    min = function(values: {number}) : number
        return call("min", values)
    end,

    max = function(values: {number}) : number
        return call("max", values)
    end,
    
    sqrt = function(value: number | {number}) : number | {number}
        return call("sqrt", value)
    end,

    log = function(value: number | {number}) : number | {number}
        return call("log", value)
    end,

    exp = function(value: number | {number}) : number | {number}
        return call("exp", value)
    end,

    abs = function(value: number | {number}) : number | {number}
        return call("abs", value)
    end,

    sin = function(value: number | {number}) : number | {number}
        return call("sin", value)
    end,

    cos = function(value: number | {number}) : number | {number}
        return call("cos", value)
    end,

    round = function(value: number | {number}) : number | {number}
        return call("round", value)
    end,

} :: types.np