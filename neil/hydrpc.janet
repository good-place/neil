(import jhydro :as jh)
(import miniz :as z)
###
### hydrpc.janet
###
### Crypto RPC server and client tailored to Janet.
###
### Blatantly stolen from janet-lang/spork/rpc

### Limitations:
###
### Currently calls are resolved in the order that they are sent
### on the connection - in other words, a single RPC server must resolve
### remote calls sequentially. This means it is recommended to make multiple
### connections for separate transactions.

(use spork/msg)

(def ctx "neilneil")

(def default-host
  "Default host to run server on and connect to."
  "127.0.0.1")

(def default-port
  "Default port to run the net repl."
  "9366")

(def psk (string/trimr (slurp "psk.key")))

(defn encode [msg-id session-pair]
  (fn encoder [msg]
    (-> msg
        marshal
        z/compress
        (jh/secretbox/encrypt msg-id ctx (session-pair :tx)))))

(defn decode [msg-id session-pair]
  (fn decoder [msg]
    (-> msg
        (jh/secretbox/decrypt msg-id ctx (session-pair :rx))
        z/decompress
        unmarshal)))

# RPC Protocol
#
# 1. server <- {user specified name of client} <- client
# 2. server -> {marshalled tuple of supported keys in marshal dict (capabilites)} -> client
# 3. server <- {marshalled function call: [fnname args]} <- client
# 4. server -> {result of unmarshalled call: [status result]} -> client
# 5. go back to 3.

(defn server
  "Create an RPC server. The default host is \"127.0.0.1\" and the
  default port is \"9366\". Also must take a dictionary of functions
  that clients can call."
  [functions &opt host port]
  (default host default-host)
  (default port default-port)
  (def keys-msg (keys functions))
  (def {:public-key pk :secret-key sk} (jh/kx/keygen))

  (defn handshake [stream]
    (def hrecv (make-recv stream string))
    (def hsend (make-send stream string))
    (def packet1 (hrecv))
    (def packet2 @"")
    (def state (jh/kx/xx2 packet2 packet1 psk pk sk))
    (hsend packet2)
    (def packet3 (hrecv))
    (jh/kx/xx4 state packet3 psk))

  (net/server
    host port
    (fn on-connection
      [stream]
      (defer (:close stream)
        (def session-pair (handshake stream))
        (var msg-id 0)
        (def recv (make-recv stream (decode msg-id session-pair)))
        (def send (make-send stream (encode msg-id session-pair)))
        (send keys-msg)
        (while (def msg (recv))
          (++ msg-id)
          (try
            (let [[fnname args] msg
                  f (functions fnname)]
              (if-not f
                (error (string "no function " fnname " supported")))
              (def result (f functions ;args))
              (when (functions :aspect/before) (:aspect/before functions fnname args))
              (send [true result])
              (when (functions :aspect/after) (:aspect/after functions fnname args)))
            ([err]
              (send [false err]))))))))

(defn client
  "Create an RPC client. The default host is \"127.0.0.1\" and the
  default port is \"9366\". Returns a table of async functions
  that can be used to make remote calls. This table also contains
  a close function that can be used to close the connection."
  [&opt host port name]
  (default host default-host)
  (default port default-port)
  (def stream (net/connect host port))

  (var session-pair {})
  (defn handshake [stream]
    (def {:public-key pk :secret-key sk} (jh/kx/keygen))
    (def hrecv (make-recv stream string))
    (def hsend (make-send stream string))
    (def packet1 @"")
    (def state (jh/kx/xx1 packet1 psk))
    (hsend packet1)
    (def packet2 (hrecv))
    (def packet3 @"")
    (set session-pair (jh/kx/xx3 state packet3 packet2 psk pk sk))
    (hsend packet3))

  (handshake stream)
  (var msg-id 0)
  (def recv (make-recv stream (decode msg-id session-pair)))
  (def send (make-send stream (encode msg-id session-pair)))
  (def fnames (recv))
  (defn closer [&] (:close stream))
  (def ret @{:close closer})
  (each f fnames
    (put ret (keyword f)
         (fn rpc-function [_ & args]
           (send [f args])
           (++ msg-id)
           (let [[ok x] (recv)]
             (if ok x (error x))))))
  ret)
