-module(erpc_zmq_sup_app).

-export([start/2]).
-export([stop/1]).

start(_Type, _Args) ->
  erpc_zmq_sup_sup:start_link().

stop(_State) ->
  ok.
