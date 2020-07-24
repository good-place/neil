(import ../tell :prefix "")

(defn main
  "Program main entry"
  [_]
  (init)
  (unless (running)
    (def [task] (last-running))
    (start task)
    (print "Continue task id " task)))
