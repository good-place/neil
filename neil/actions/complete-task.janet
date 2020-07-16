(import ../tell :prefix "")

(defn main
  "Program main entry"
  [_]
  (init)
  (let [tid (choose (:task/by-state c "active") "task: "
                    |(string/join [(first $) (get-in $ [1 :name])] " - "))
        task (:by-id c tid)]
    (print "Marking " (task :name) " as complete")
    (:task/complete c tid)))
