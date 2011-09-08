#!/usr/bin/env escript
%% -*-erlang-*-
%%! -smp disable +P 200000

-define(PORT, 7000).
-define(BACKLOG, 1024).
-define(WORK_DELAY, 10000).

main(_) ->
    start_counter(handler_count),
    serve_forever().

start_counter(Name) ->
    Pid = spawn(fun() -> counter_loop(0) end),
    register(Name, Pid).

incr_counter(Counter) ->
    Counter ! {incr, self()},
    receive
        {counter, Count} -> Count
    end.

decr_counter(Counter) ->
    Counter ! {decr, self()},
    receive
        {counter, Count} -> Count
    end.

counter_loop(N) ->
    receive
        {incr, From} ->
            Next = N + 1,
            From ! {counter, Next},
            counter_loop(Next);
        {decr, From} ->
            Next = N - 1,
            From ! {counter, Next},
            counter_loop(Next)
    end.

serve_forever() ->
    {ok, S} = gen_tcp:listen(?PORT, [binary,
                                     {packet, raw},
                                     {active, false},
                                     {backlog, ?BACKLOG},
                                     {reuseaddr, true}]),
    io:format("Erlang server is listening on port ~b~n", [?PORT]),
    handle_connections(S).

handle_connections(Socket) ->
    {ok, Client} = gen_tcp:accept(Socket),
    {ok, Peer} = inet:peername(Client),
    ActiveHandlers = incr_counter(handler_count),
    io:format("~b ~5..0b ~s~n", [timestamp(), ActiveHandlers,
                                 format_peer(Peer)]),
    spawn(fun() -> handle_connection(Client) end),
    handle_connections(Socket).

handle_connection(Client) ->
    try
        {ok, _} = gen_tcp:recv(Client, 0),
        timer:sleep(?WORK_DELAY),
        ok = gen_tcp:send(Client,
                          "HTTP/1.1 200 OK\r\n"
                          "Content-Length: 5\r\n"
                          "Content-Type: text/plain\r\n"
                          "\r\n"
                          "hello"),
        ok = gen_tcp:close(Client)
    after
        decr_counter(handler_count)
    end.

format_peer({{A, B, C, D}, Port}) ->
    io_lib:format("~b.~b.~b.~b:~b", [A, B, C, D, Port]).

timestamp() ->
    {M, S, U} = erlang:now(),
    M * 1000000000 + S * 1000 + U div 1000.
