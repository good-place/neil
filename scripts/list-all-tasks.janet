(import ../neil/tell :prefix "")

(defn main
  "Program main entry"
  [_]
  (init)
  (each t (sort-tasks (first (:task/list c)))
    (print-task t)))
