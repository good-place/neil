(import ../tell :prefix "")

(defn main
  "Program main entry"
  [_]
  (init)
  (each t (sort-tasks (list :task))
    (print-task t)))
