(import ../tell :prefix "")

(defn main
  "Program main entry"
  [_]
  (def project
    (choose (list :project)
            (string "project: ")
            |(string/join [(first $) (get-in $ [1 :name])] " - ")
            |(string/split " - " $)
            identity))
  (each t (sort-tasks (nest-list [(project 0) :project] :tasks))
    (print-task t (project 1))))
