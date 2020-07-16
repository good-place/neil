(import ../tell :prefix "")

(defn main
  "Program main entry"
  [_]
  (init)
  (def state (-> ["active" "completed"]
                 (choose "tell neil:" string identity identity)))
  (each t (sort-tasks (:task/by-state c state))
    (print-task t)))
