(import ../tell :prefix "")

(defn main
  "Program main entry"
  [_]
  (def state (choose ["active" "completed" "canceled"] "tell neil:" string identity identity))
  (each t (sort-tasks (by-state state)) (print-task t)))
