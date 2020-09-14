(import ../tell :prefix "")

(defn main
  "Program main entry"
  [_]
  (def client
    (choose (list :client)
            "client: "
            |(string/join [(first $) (get-in $ [1 :abbrev]) (get-in $ [1 :name])] " - ")))
  (each [p] (nest-list [client :client] :projects)
    (each t (sort-tasks (nest-list [p :project] :tasks))
      (when (= "active" (get-in t [1 :state])) (print-task t)))))
