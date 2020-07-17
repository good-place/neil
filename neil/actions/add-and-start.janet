(import ../tell :prefix "")

(defn main
  "Program main entry"
  [_]
  (init)
  (def running (:task/running c))
  (if running
    (print "You have task already running: " (get-in running [1 :name]))
    (do
      (def project
        (choose (list :project)
                (string "project: ")
                |(string/join [(first $) (get-in $ [1 :name])] " - ")))
      (def task (get-strip "task:"))
      (if (= task "cancel")
        (print "Canceled")
        (let [tid (add :task {:project project :name task})]
          (:task/start c tid)
          (print "Added and started task with id: " tid))))))
