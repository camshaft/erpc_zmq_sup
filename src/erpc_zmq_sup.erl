-module(erpc_zmq_sup).

-export([start_link/1]).
-export([call/6]).

start() ->
  application:start(pooler),
  application:start(erpc_zmq_sup).

start_link(Host) ->
  %% TODO use options
  {ok, Context} = erlzmq:context(),
  {ok, Requester} = erlzmq:socket(Context, [req, {active, false}]),
  ok = erlzmq:connect(Requester, Host),
  {ok, Requester}.

call(Requester, Mod, Fun, Args, Sender, Ref) ->
  spawn_link(fun() ->
    case encode(Mod, Fun, Args) of
      {error, Error} ->
        Sender ! {error, Error, Ref};
      Bin when is_binary(Bin) ->
        ok = erlzmq:send(Requester, Bin),
        case erlzmq:recv(Requester) of
          {ok, Msg} ->
            {ok, Res} = msgpack:unpack(Msg, [jsx]),
            Sender ! {ok, Res, Ref}
        end
    end
  end),
  ok.

encode(Mod, Fun, Args) ->
  Module = atom_to_binary(Mod, utf8),
  Function = atom_to_binary(Fun, utf8),
  %% TODO encode the arguments
  msgpack:pack([Module, Function, Args]).
