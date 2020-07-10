(import spork/rpc)
(import mansion/buffet)
(import mansion/reception)
(import mansion/utils)

(defn- ensure-db
  [name]
  (match (protect (buffet/create name @{:to-index [:type :abbrev :name :client :project :state]}))
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
  [reception]
  (def visitor (:visit reception "neil"))
  (defn save [what] (:save visitor "scores" what))
  (defn retrieve [which] (:retrieve visitor "scores" which))

  (defn stamp [now]
    {:timestamp now})

  (defn populate [what data]
    (def now (os/time))
    (merge
      {:type (string what)
       :created now
       :state "active"}
      data
      (stamp now)))

  (def funcs
    {:client/add (fn [_ client] (-> (populate :client client) freeze save))
     :client/list (fn [_] (retrieve {:type "client"}))
     :client/projects (fn [_ client] (retrieve {:client client}))
     :project/add (fn [_ project] (-> (populate :project project) freeze save))
     :project/list (fn [_] (retrieve {:type "project"}))
     :project/tasks (fn [_ project] (retrieve {:project project}))
     :task/add (fn [_ task] (-> (populate :task task) freeze save))
     :task/list (fn [_] (retrieve {:type "task"}))})

  (rpc/server funcs "localhost" 6660))

(defn main [_]
  (->> "scores"
       store
       (server)))
