(import spork/rpc)
(import mansion/buffet)
(import mansion/reception)

(defn- ensure-db
  [name]
  (match (protect (buffet/create name @{:to-index [:name :client :project]}))
    [true db] (:close db)
    [false _] (eprint "DB already created")))

(defn- start-reception
  [name]
  (:run (reception/open [name])))

(defn store [name]
  "Opens store"
  (ensure-db name)
  (start-reception name))

(defn server
  "Starts RPC server"
  [host port reception]
  (def visitor (:visit reception "neil"))
  (def funcs {:client/add (fn [self name]
                            (:save visitor "scores" {:name name}))
              :client/list (fn [self] (:retrieve visitor "scores"))})
  (rpc/server funcs host port))

(defn main [_]

  (->> "scores"
       store
       (server "localhost" 6660)))
