(import ../neil/tell :prefix "")

(defn main
  "Program main entry"
  [_]
  (init)
  (def project
    (choose (list :project)
            (string "project: ")
            |(string/join [(first $) (get-in $ [1 :name])] " - ")))
  (each t (sort-tasks (:project/tasks c project))
    (print-task t)))
