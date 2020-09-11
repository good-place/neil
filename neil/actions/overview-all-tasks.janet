(import ../tell :prefix "")

(defn main
  "Program main entry"
  [_]
  (each t (sort-tasks (list :task)) (overview-task t)))
