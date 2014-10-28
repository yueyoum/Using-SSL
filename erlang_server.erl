-module(erlang_server).
-export([start/0,
         start/1]).

-export([accept/1]).

-vsn("1.0.0").


-define(DEFAULT_PORT, 9900).
-define(SOCKET_OPTS, [{certfile, "server.crt"},
                      {keyfile, "server.key"},
                      {cacertfile, "ca.crt"},
                      {verify, verify_peer},
                      {fail_if_no_peer_cert, true}]).


start() ->
    start(?DEFAULT_PORT).

start(Port) ->
    ssl:start(),
    {ok, LSock} = ssl:listen(Port, [{reuseaddr, true},
                                    list | ?SOCKET_OPTS]),
    spawn(?MODULE, accept, [LSock]).


accept(LSock) ->
    case ssl:transport_accept(LSock) of
        {ok, Socket} ->
            spawn(?MODULE, accept, [LSock]),
            ssl_accept(Socket);
        {error, _Reason} ->
            spawn(?MODULE, accept, [LSock])
    end.

ssl_accept(Socket) ->
    % do hand shake
    case ssl:ssl_accept(Socket) of
        ok ->
            io:format("ssl_accept, hand shake success~n", []),
            loop(Socket);
        {error, Reason} ->
            io:format("ssl_accept error: ~p~n", [Reason])
    end.


loop(Socket) ->
    receive
        {ssl, Socket, Data} ->
            io:format("receive Data: ~p~n", [Data]),
            ok = ssl:send(Socket, Data),
            loop(Socket),
            io:format("work finish~n", []);
        {ssl_closed, Socket} ->
            io:format("ssl_closed~n", []);
        {ssl_error, Socket, Reason} ->
            io:format("ssl_error, Reason: ~p~n", [Reason])
    end,
    ok.

