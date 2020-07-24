(import ../tell :prefix "")

(defn main
  "Program main entry"
  [_]
  (init)
  (if (running)
    (stop-task (running))
    (print "You are not running any task")))
