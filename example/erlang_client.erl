-module(erlang_client).
-export([start/0,
         connect/2]).

-vsn("1.0.0").

-define(SOCKET_OPTS, [{certfile, "../client.crt"},
                      {keyfile, "../client.key"}]).

start() ->
    ssl:start().


connect(Host, Port) ->
    {ok, Socket} = ssl:connect(Host, Port, [list | ?SOCKET_OPTS]),
    Socket.

