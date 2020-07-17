(import mansion/buffet)
(import mansion/reception)
(import mansion/utils)

(import hydrpc :as hr)

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
  (defn load [id] (:load visitor "scores" id))

  (defn stamp [&opt now]
    (default now (os/time))
    {:timestamp now})

  (defn populate [what data]
    (def now (os/time))
    (merge
      {:type (string what)
       :created now
       :state "active"}
      data
      (stamp now)))

  (defn- first-retrieved [what]
    (-> what retrieve first))

  (def funcs
    {:client/add (fn [_ client] (-> (populate :client client) freeze save))
     :client/list (fn [_] (first-retrieved {:type "client"}))
     :client/projects (fn [_ client] (first-retrieved {:client client}))
     :by-id (fn [_ id] (:load visitor "scores" id))
     :project/add (fn [_ project] (-> (populate :project project) freeze save))
     :project/list (fn [_] (first-retrieved {:type "project"}))
     :project/tasks (fn [_ project] (first-retrieved {:project project}))
     :task/add (fn [_ task] (-> (populate :task task) freeze save))
     :task/list (fn [_] (first-retrieved {:type "task"}))
     :task/by-state (fn [_ state] (utils/intersect (retrieve {:type "task" :state state})))
     :task/running (fn [self] (first (:task/by-state self "running")))
     :task/start (fn [_ id]
                   (def task (table ;(kvs (load id))))
                   (if-let [wi (task :work-intervals)]
                     (let [wi (array ;wi)]
                       (put task :work-intervals
                            (-> wi
                                (array/concat @[{:start (os/time)}])
                                freeze)))
                     (put task :work-intervals [{:start (os/time)}]))
                   (save [id (-> task
                                 (merge (stamp) {:state "running"})
                                 freeze)]))
     :task/stop (fn [_ note]
                  (def [[[id task]]] (retrieve {:state "running"}))
                  (def iw (array ;(task :work-intervals)))
                  (def running (array/pop iw))
                  (array/push iw
                              (merge running {:note note
                                              :end (os/time)}))
                  (save [id (-> task
                                (merge (stamp) {:state "active"
                                                :work-intervals iw})
                                freeze)]))
     :task/complete (fn [_ id]
                      (def nt
                        (-> id load
                            (merge {:state "completed"})
                            freeze))
                      (save [id nt]))
     :task/cancel (fn [_ id]
                    (def nt
                      (-> id load
                          (merge {:state "canceled"})
                          freeze))
                    (save [id nt]))})

  (hr/server funcs "localhost" 6660))

(defn main [_]
  (->> "scores"
       store
       (server)))
