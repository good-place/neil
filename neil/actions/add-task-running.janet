(import ../tell :prefix "")

(defn main
  "Program main entry"
  [_]
  (tell
    (if (running)
      (let [name (get-strip "task: ")
            tid (add :task {:name name
                            :project (get-in (running) [1 :project])})]
        (print "Added task id: " tid))
      (prin "No task is running"))))
