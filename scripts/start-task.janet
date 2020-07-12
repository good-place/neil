(import ../neil/tell :prefix "")

(defn main
  "Program main entry"
  [_]

  (def running (get-in (:task/running c) [0 0]))
  (if running
    (do
      (print "You have task already running: " (get-in running [1 :name]))
      (getline))
    (let [task (choose (:task/active c) "task: "
                       |(string/join [(first $) (get-in $ [1 :name])] " - "))]
      (:task/start c task))))
