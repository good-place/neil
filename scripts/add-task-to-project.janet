(import ../neil/tell :prefix "")

(defn main
  "Program main entry"
  [_]
  (init)

  (def project
    (choose (list :project)
            (string "project: ")
            |(string/join [(first $) (get-in $ [1 :name])] " - ")))
  (def task (get-strip "task:"))
  (if (= task "cancel")
    (print "Canceled")
    (print "Added task with id: "
           (add :task {:project project
                       :name task}))))
