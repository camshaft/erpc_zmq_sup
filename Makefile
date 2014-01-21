PROJECT = erpc_zmq_sup

# Options.

CT_SUITES = erpc_zmq_sup

# Dependencies

PKG_FILE_URL = https://gist.github.com/CamShaft/815c139ad3c1ccf13bad/raw/packages.tsv

DEPS = fast_key erlzmq2 msgpack pooler
dep_fast_key = pkg://fast_key master
dep_erlzmq2 = https://github.com/zeromq/erlzmq2.git master
dep_msgpack = https://github.com/msgpack/msgpack-erlang.git master
dep_pooler = https://github.com/CamShaft/pooler.git master

# Standard targets.

include erlang.mk
