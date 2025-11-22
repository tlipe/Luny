local call = require("./src/call")
local types = require("./src/types/type")

local process = require("@lune/process")
process.create("python", {"numpy_.py"}, {cwd = "./Modules/numpy/_index/src/lib"})

return {
    mean = function(values: {number}) : number
        return call("mean", values)
    end,

    sum = function(values: {number}) : number
        return call("sum", values)
    end,

    sqrt = function(value: number) : number
        return call("sqrt", value)
    end,

    log = function(value: number) : number
        return call("log", value)
    end,
} :: types.np