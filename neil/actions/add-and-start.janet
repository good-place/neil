(import ../tell :prefix "")

(defn main
  "Program main entry"
  [_]
  (if-let [r (running)]
    (print "You have task already running: " (get-in r [1 :name]))
    (do
      (def project
        (choose (list :project)
                (string "project: ")
                |(string/join [(first $) (get-in $ [1 :name])] " - ")))
      (def task (get-strip "task:"))
      (if (= task "cancel")
        (print "Canceled")
        (let [tid (add :task {:project project :name task})]
          (start tid)
          (print "Added and started task with id: " tid))))))
