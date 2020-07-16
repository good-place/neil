(import ../neil/tell :prefix "")

(defn main
  "Program main entry"
  [_]
  (init)
  (def client
    (choose (list :client)
            "client: "
            |(string/join [(first $) (get-in $ [1 :abbrev]) (get-in $ [1 :name])] " - ")))
  (each [p] (first (nest-list [client :client] :projects))
    (each t (sort-tasks (first (nest-list [p :project] :tasks)))
      (print-task t))))
