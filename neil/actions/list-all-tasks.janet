(import ../tell :prefix "")

(defn main
  "Program main entry"
  [_]
  (tell (each t (sort-tasks (list :task)) (print-task t))))
