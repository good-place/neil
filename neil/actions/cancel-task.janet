(import ../tell :prefix "")

(defn main
  "Program main entry"
  [_]
  (init)
  (let [projects (table ;(flatten (list :project)))
        tasks (filter |(get-in $ [1 :work-intervals]) (:task/by-state neil "active"))
        tid (choose tasks "task: "
                    |(string/join [(first $)
                                   ((projects (get-in $ [1 :project])) :name)
                                   (get-in $ [1 :name])] " - "))
        task (by-id tid)]
    (print "Marking " (task :name) " as canceled")
    (:task/cancel neil tid)))
