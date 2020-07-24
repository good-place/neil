(import ../tell :prefix "")

(defn main
  "Program main entry"
  [_]
  (init)
  (stop-task (running))
  (let [projects (table ;(flatten (list :project)))
        tid (choose (by-state "active") "task: "
                    |(string/join [(first $)
                                   ((projects (get-in $ [1 :project])) :name)
                                   (get-in $ [1 :name])] " - "))
        task (by-id tid)]
    (start tid)
    (print "Starting task " (task :name))))
