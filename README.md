# Lune TCP Libs
### Module Integration TCP

# What is this initiative
This project demonstrates how to create a communication layer between languages and libraries using TCP sockets. The idea is simple: any library or module can be exposed as a TCP daemon, and other processes (such as clients written in Python, Lua, Rust, or any language) can connect and consume its functionalities.

# How the connection works
Server (Daemon TCP)

- Runs continuously listening on a TCP port.

- Receives structured messages (JSON, soon binaries) with instructions on which function to execute and which parameters to use.

- Processes the request using the internal library/module.

- Returns the response also in JSON, encapsulated with framing (4-byte prefix indicating the message size).

- Client (Function Caller)

- Opens a TCP connection to the daemon.

- Sends the request in JSON with framing.

- Reads the response, decodes it, and returns the result to the application.

Example of a basic request:

json
{
  "func": "function_name",
  "values": [parameters]
}

Folder structure It is mandatory to have a main folder called Modules. Inside it are the modules that implement both the client and the daemons:

/Modules/YourLib (Your library extracted from this repository)

# How to use in applications
You can use require to get the main file that has .luau in the libraries, and thus work with libraries from other programming languages, making your applications easier and more scalable. See the example:

local numpy = require("./Modules/numpy/np")

# Objective of the initiative
- Create a generic infrastructure to integrate external libraries into any application.

- Allow different languages to communicate easily via TCP.

- Facilitate the creation of custom RPCs (Remote Procedure Calls) without relying on complex protocols and while respecting Lune's limitations.

- Pave the way to integrate calculation modules, graphics, GUIs, or any other functionality, without being limited to a specific language or runtime library.
