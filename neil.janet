(import spork/rpc)
(import mansion/buffet)
(import mansion/reception)

(defn- ensure-db
  [name]
  (match (protect (buffet/create name @{:to-index [:type :abbrev :name :client :project]}))
    [true db] (do (print "Creating DB") (:close db))
    [false _] (print "DB already created")))

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
  (defn save [what] (:save visitor "scores" what))
  (defn retrieve [which] (:retrieve visitor "scores" which))

  (defn stamp []
    (def now (os/time))
    {:timestamp now})

  (defn populate [what]
    (def now (os/time))
    (merge (stamp)
           {:type (string what)
            :created now
            :state "active"}))

  (def funcs
    {:client/add (fn [self client] (-> client (merge (populate :client)) freeze save))
     :client/list (fn [self] (retrieve {:type "client"}))
     :project/add (fn [self project] (-> project (merge (populate :project) freeze save)))
     :project/list (fn [self] (retrieve {:type "project"}))
     :client/projects (fn [self client] (retrieve {:type :project :client client}))
     :task/add (fn [self task] (-> task (merge (populate :task)) freeze save))
     :task/list (fn [self] (retrieve {:type "task"}))})

  (rpc/server funcs host port))

(defn main [_]
  (->> "scores"
       store
       (server "localhost" 6660)))
