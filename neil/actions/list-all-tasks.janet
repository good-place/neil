(import ../tell :prefix "")

(defn main
  "Program main entry"
  [_]
  (init)
  (each t (sort-tasks (:task/list c))
    (print-task t)))
