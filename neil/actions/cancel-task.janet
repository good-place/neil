(import ../tell :prefix "")

(defn main
  "Program main entry"
  [_]
  (let [projects (table ;(flatten (list :project)))
        tasks (filter |(not (get-in $ [1 :work-intervals])) (by-state "active"))
        tid (choose tasks "task: "
                    |(string/join [(first $)
                                   ((projects (get-in $ [1 :project])) :name)
                                   (get-in $ [1 :name])] " - "))
        task (by-id tid)]
    (print "Marking " (task :name) " as canceled")
    (cancel tid)))
