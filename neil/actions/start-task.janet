(import ../tell :prefix "")

(defn main
  "Program main entry"
  [_]
  (init)
  (if (running)
    (print "You have task already running: " (get-in (running) [1 :name]))
    (let [projects (table ;(flatten (list :project)))
          tid (choose (by-state "active") "task: "
                      |(string/join [(first $)
                                     ((projects (get-in $ [1 :project])) :name)
                                     (get-in $ [1 :name])] " - "))
          task (by-id tid)]
      (:task/start neil tid)
      (print "Starting task " (task :name)))))
