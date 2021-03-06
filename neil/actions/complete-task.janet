(import ../tell :prefix "")

(defn main
  "Program main entry"
  [_]
  (let [tid (choose (by-state "active") "task: "
                    |(string/join [(first $) (get-in $ [1 :name])] " - "))
        task (by-id tid)]
    (print "Marking " (task :name) " as complete")
    (complete tid)))
