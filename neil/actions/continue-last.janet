(import ../tell :prefix "")

(defn main
  "Program main entry"
  [_]
  (init)
  (unless (running)
    (def [task] (last-running))
    (:task/start neil task)
    (print "Continue task id " task)))
