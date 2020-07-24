(import ../tell :prefix "")

(defn main
  "Program main entry"
  [_]
  (init)
  (def state (-> ["active" "completed" "canceled"]
                 (choose "tell neil:" string identity identity)))
  (each t (sort-tasks (by-state state))
    (print-task t)))
