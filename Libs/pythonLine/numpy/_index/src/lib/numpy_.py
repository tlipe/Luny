import asyncio, orjson, struct, numpy as np

HOST, PORT = "127.0.0.1", 9090

# NumPy
FUNCTIONS = {
    "mean": lambda v: float(np.mean(np.array(v))) if isinstance(v, list) else None,
    "median": lambda v: float(np.median(np.array(v))) if isinstance(v, list) else None,

    "sum": lambda v: float(np.sum(np.array(v))) if isinstance(v, list) else None,
    "std": lambda v: float(np.std(np.array(v))) if isinstance(v, list) else None,
    "var": lambda v: float(np.var(np.array(v))) if isinstance(v, list) else None,
    "min": lambda v: float(np.min(np.array(v))) if isinstance(v, list) else None,
    "max": lambda v: float(np.max(np.array(v))) if isinstance(v, list) else None,

    "sqrt": lambda v: (
        np.sqrt(np.array(v)).tolist() if isinstance(v, list) else float(np.sqrt(v))
    ) if isinstance(v, (list, int, float)) else None,

    "log": lambda v: (
        np.log(np.array(v)).tolist() if isinstance(v, list) else float(np.log(v))
    ) if isinstance(v, (list, int, float)) else None,

    "exp": lambda v: (
        np.exp(np.array(v)).tolist() if isinstance(v, list) else float(np.exp(v))
    ) if isinstance(v, (list, int, float)) else None,

    "abs": lambda v: (
        np.abs(np.array(v)).tolist() if isinstance(v, list) else float(np.abs(v))
    ) if isinstance(v, (list, int, float)) else None,

    "sin": lambda v: (
        np.sin(np.array(v)).tolist() if isinstance(v, list) else float(np.sin(v))
    ) if isinstance(v, (list, int, float)) else None,

    "cos": lambda v: (
        np.cos(np.array(v)).tolist() if isinstance(v, list) else float(np.cos(v))
    ) if isinstance(v, (list, int, float)) else None,
    
    "round": lambda v: (
        np.round(np.array(v)).tolist() if isinstance(v, list) else float(np.round(v))
    ) if isinstance(v, (list, int, float)) else None,
}

async def handle_client(reader, writer):
    try:
        raw_len = await reader.readexactly(4)
        msg_len = struct.unpack(">I", raw_len)[0]

        data = await reader.readexactly(msg_len)
        req = orjson.loads(data)

        func = req.get("func")
        args = req.get("args", [])

        result = FUNCTIONS[func](*args) if func in FUNCTIONS else None

        response = orjson.dumps({"result": result})
        writer.write(struct.pack(">I", len(response)) + response)

        await writer.drain()

    except Exception as e:
        error = orjson.dumps({"error": str(e)})
        writer.write(struct.pack(">I", len(error)) + error)
        await writer.drain()

    finally:
        writer.close()
        await writer.wait_closed()

async def main():
    server = await asyncio.start_server(handle_client, HOST, PORT)
    async with server:
        await server.serve_forever()

asyncio.run(main())