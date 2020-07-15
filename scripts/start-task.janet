(import ../neil/tell :prefix "")

(defn main
  "Program main entry"
  [_]
  (init)
  (def running (first (:task/by-state c "running")))
  (if running
    (do
      (print "You have task already running: " (get-in running [1 :name])))
    (let [tid (choose (:task/by-state c "active") "task: "
                      |(string/join [(first $) (get-in $ [1 :name])] " - "))
          task (:by-id c tid)]
      (:task/start c tid)
      (print "Starting task " (task :name)))))
