(import ../tell :prefix "")

(defn main
  "Program main entry"
  [_]
  (init)
  (def running (:task/running c))
  (if running
    (do
      (print "Stopping task: " ((last running) :name))
      (def note (get-strip "note:"))
      (:task/stop c note)
      (when (string/has-suffix? "done" note)
        (print "Marking task as complete")
        (:task/complete c (first running))))
    (print "You are not running any task")))
