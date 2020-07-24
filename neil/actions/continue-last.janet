(import ../tell :prefix "")

(defn main
  "Program main entry"
  [_]
  (init)
  (unless (running)
    (def [task] (->> (:task/by-state neil "active")
                     (filter (fn [t] (get-in t [1 :work-intervals])))
                     (sort-by |((last (get-in $ [1 :work-intervals])) :end))
                     last))
    (:task/start neil task)
    (print "Continue task id " task)))
