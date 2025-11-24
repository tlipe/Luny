export type np = {
    mean: (values: {number}) -> number,
    median: (values: {number}) -> number,
    sum: (values: {number}) -> number,
    std: (values: {number}) -> number,
    var: (values: {number}) -> number,
    min: (values: {number}) -> number,
    max: (values: {number}) -> number,
    sqrt: (value: number | {number}) -> number | {number},
    log: (value: number | {number}) -> number | {number},
    exp: (value: number | {number}) -> number | {number},
    abs: (value: number | {number}) -> number | {number},
    sin: (value: number | {number}) -> number | {number},
    cos: (value: number | {number}) -> number | {number},
    round: (value: number | {number}) -> number | {number},
}

return 1