local net = require('@lune/net')
local serde = require('@lune/serde')
local task = require('@lune/task')

local HOST: string, PORT: number = '127.0.0.1', 9090
local conn = nil

local function isConnAlive(c)
    if not c then return false end
    local ok, _ = pcall(function() return c:write('') end)
    return ok
end

local function connectOnce()
    local ok, c = pcall(function() return net.tcp.connect(HOST, PORT) end)
    if not ok or not c then
        return nil, 'connect failed'
    end

    return c
end

local function ensureConn(retries)
    retries = retries or 2
    if isConnAlive(conn) then return conn end

    for i = 1, retries do
        local c, _ = connectOnce()
        if c then
            conn = c
            return conn
        end

        task.wait(0.02)
    end

    return nil, 'unable to connect'
end

local function read_exact(c, n)
    local parts = {}
    local readed = 0

    while readed < n do
        local ok, chunk = pcall(c.read, c, n - readed)
        if not ok then return nil, 'read error' end
        if not chunk or #chunk == 0 then
            return nil, 'remote closed'
        end

        parts[#parts+1] = chunk
        readed += #chunk
    end

    return table.concat(parts)
end

return function(func: string, ...)
    local args = { ... }
    local c, err = ensureConn()
    if not c then
        error(`RPC connect error: {err}`)
    end

    local payload = serde.encode('json', {
        v = 1,
        func = func,
        args = args
    })

    local ok, res = pcall(function()
        local prefix = string.pack('>I4', #payload)
        c:write(prefix)
        c:write(payload)

        local len_bytes = read_exact(c, 4)
        if not len_bytes or #len_bytes < 4 then
            error('Failed to read length prefix')
        end

        local len = string.unpack('>I4', len_bytes)
        local body = read_exact(c, len)
        if not body or #body < len then
            error('Incomplete payload from server')
        end

        local decoded = serde.decode('json', body)
        if not decoded then
            error('JSON decode failed')
        end
        if decoded.error then
            error(`Server error: {decoded.error}`)
        end
        if decoded.result == nil then
            error('Server returned nil result (invalid func?)')
        end

        return decoded.result
    end)

    if not ok then
        local clean = tostring(res or 'unknown error')
        if conn then
            pcall(function() conn:close() end)
            conn = nil
        end
        error(clean)
    end

    return res
end