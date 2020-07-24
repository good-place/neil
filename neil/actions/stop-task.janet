(import ../tell :prefix "")

(defn main
  "Program main entry"
  [_]
  (init)
  (if (running)
    (stop (running))
    (print "You are not running any task")))
