(import ../neil/tell :prefix "")

(defn main
  "Program main entry"
  [_]
  (init)
  (def running (:task/running c))
  (when running
    (print "Stopping task: " ((last running) :name))
    (:task/stop c (get-strip "note:")))
  (let [projects (table ;(flatten (list :project)))
        tid (choose (:task/by-state c "active") "task: "
                    |(string/join [(first $)
                                   ((projects (get-in $ [1 :project])) :name)
                                   (get-in $ [1 :name])] " - "))
        task (:by-id c tid)]
    (:task/start c tid)
    (print "Starting task " (task :name))))
