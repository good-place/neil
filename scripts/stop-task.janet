(import ../neil/tell :prefix "")

(defn main
  "Program main entry"
  [_]
  (init)
  (def running (:task/by-state c "running"))
  (tracev running)
  (if running
    (do
      (print "Stopping task: " ((last running) :name))
      (:task/stop c (get-strip "note:")))
    (print "You are not running any task")))
