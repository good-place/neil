(import ../neil/tell :prefix "")

(defn main
  "Program main entry"
  [_]
  (init)
  (def running (:task/running c))
  (if running
    (do
      (print "Stopping task: " ((last running) :name))
      (:task/stop c (get-strip "note:")))
    (print "You are not running any task")))
