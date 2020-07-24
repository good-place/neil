(import ../tell :prefix "")

(defn main
  "Program main entry"
  [_]
  (init)
  (let [tid (choose (by-state "active") "task: "
                    |(string/join [(first $) (get-in $ [1 :name])] " - "))
        task (by-id tid)]
    (print "Marking " (task :name) " as complete")
    (:task/complete neil tid)))
