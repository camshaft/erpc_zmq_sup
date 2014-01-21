-module(erpc_zmq_sup_port).

-export([start_link/1]).
-export([stop/1]).

start_link([Command]) ->
  start_link([Command, infinity]);
start_link([Command, Timeout]) ->
  spawn_link(fun() ->
    process_flag(trap_exit, true),
    Port = create_port(Command),
    link(Port),
    loop(Port, Timeout, Command)
  end).

stop(Pid) ->
  Pid ! stop,
  true.

create_port(Command) ->
  open_port({spawn, Command}, [{packet, 4}, nouse_stdio, exit_status, binary]).

loop(Port, Timeout, Command) ->
  receive
    noose ->
      port_close(Port),
      noose;
    shutdown ->
      port_close(Port),
      exit(shutdown);
    {Port, {exit_status, Code}} ->
      % Hard and Unanticipated Crash
      io:format("Port closed with code ~p! ~p~n", [Code, Port]),
      exit({error, Code});
    {'EXIT', _Pid, shutdown} ->
      port_close(Port),
      exit(shutdown);
    Any ->
      io:format("PortWrapper ~p got unexpected message: ~p~n", [self(), Any]),
      loop(Port, Timeout, Command)
  end.
