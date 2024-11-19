Language servers usually run in a separate process and clients communicate with them in an asynchronous fashion. Additionally clients usually allow users to interact with the source code even if request results are pending. We recommend the following implementation pattern to avoid that clients apply outdated response results:

- if a client sends a request to the server and the client state changes in a way that it invalidates the response it should do the following:
  - cancel the server request and ignore the result if the result is not useful for the client anymore. If necessary the client should resend the request.
  - keep the request running if the client can still make use of the result by, for example, transforming it to a new result by applying the state change to the result.
- servers should therefore not decide by themselves to cancel requests simply due to that fact that a state change notification is detected in the queue. As said the result could still be useful for the client.
- if a server detects an internal state change (for example, a project context changed) that invalidates the result of a request in execution the server can error these requests with ContentModified. If clients receive a ContentModified error, it generally should not show it in the UI for the end-user. Clients can resend the request if they know how to do so. It should be noted that for all position based requests it might be especially hard for clients to re-craft a request.

* a client should not send resolve requests for out of date objects (for example, code lenses, …). If a server receives a resolve request for an out of date object the server can error these requests with ContentModified.
* if a client notices that a server exits unexpectedly, it should try to restart the server. However clients should be careful not to restart a crashing server endlessly. VS Code, for example, doesn’t restart a server which has crashed 5 times in the last 180 seconds.

Servers usually support different communication channels (e.g. stdio, pipes, …). To ease the usage of servers in different clients it is highly recommended that a server implementation supports the following command line arguments to pick the communication channel:

- stdio: uses stdio as the communication channel.
- pipe: use pipes (Windows) or socket files (Linux, Mac) as the communication channel. The pipe / socket file name is passed as the next arg or with --pipe=.
- socket: uses a socket as the communication channel. The port is passed as next arg or with --port=.
  node-ipc: use node IPC communication between the client and the server. This is only supported if both client and server run under node.
- To support the case that the editor starting a server crashes an editor should also pass its process id to the server. This allows the server to monitor the editor process and to shutdown itself if the editor process dies. The process id passed on the command line should be the same as the one passed in the initialize parameters. The command line argument to use is --clientProcessId.
