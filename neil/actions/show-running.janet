(import ../tell :prefix "")

(defn main
  "Program main entry"
  [_]
  (init)
  (def running (:task/running c))
  (if running
    (let [[rid {:name n :project pid :work-intervals iw :state s}] running
          {:name p} (:by-id c pid)
          {:start s :note t} (last iw)]
      (prin (durf (- (os/time) s)) " @" p " - #" rid " " n ""))
    (prin "No task is running")))
