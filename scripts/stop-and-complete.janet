(import ../neil/tell :prefix "")

(defn main
  "Program main entry"
  [_]
  (init)
  (def running (:task/by-state c "running"))
  (if running
    (do
      (print "Stopping and marking task complete: " ((last running) :name))
      (:task/stop c (get-strip "note:"))
      (:task/complete c (first running)))
    (print "You are not running any task")))
