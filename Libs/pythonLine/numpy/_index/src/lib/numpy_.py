import asyncio, json, struct, math, statistics, numpy as np

HOST, PORT = "127.0.0.1", 9090

# NumPy/math
FUNCTIONS = {
    "mean": lambda v: float(np.mean(np.array(v))) if isinstance(v, list) else None,

    "sum": lambda v: float(np.sum(np.array(v))) if isinstance(v, list) else None,

    "sqrt": lambda v: (
        np.sqrt(np.array(v)).tolist() if isinstance(v, list) else float(np.sqrt(v))
    ) if isinstance(v, (list, int, float)) else None,

    "log": lambda v: (
        np.log(np.array(v)).tolist() if isinstance(v, list) else float(np.log(v))
    ) if isinstance(v, (list, int, float)) else None,
}

async def handle_client(reader, writer):
    try:
        raw_len = await reader.readexactly(4)
        msg_len = struct.unpack(">I", raw_len)[0]
        data = (await reader.readexactly(msg_len)).decode()

        req = json.loads(data)
        func = req.get("func")
        values = req.get("values")

        result = None
        if func in FUNCTIONS:
            result = FUNCTIONS[func](values)

        response = json.dumps({"result": result}).encode()
        writer.write(struct.pack(">I", len(response)))
        writer.write(response)

        await writer.drain()
    except Exception as e:
        error_msg = json.dumps({"error": str(e)}).encode()
        writer.write(struct.pack(">I", len(error_msg)))
        writer.write(error_msg)

        await writer.drain()
    finally:
        writer.close()
        await writer.wait_closed()

async def main():
    server = await asyncio.start_server(handle_client, HOST, PORT)

    async with server:
        await server.serve_forever()

asyncio.run(main())