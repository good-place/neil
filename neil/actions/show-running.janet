(import ../tell :prefix "")

(defn main
  "Program main entry"
  [_]
  (init)
  (def running (:task/running c))
  (if running
    (do
      (def [_ {:name n :project pid :work-intervals iw :state s}] running)
      (def {:name p} (:by-id c pid))
      (prin "@" p " - #" (first running) " " n ":")
      (if iw
        (let [{:start s :end e :note t} (last iw)]
          (default e (os/time))
          (print " " (datef (os/date s true) true)
                 " dur: " (durf (- e s))))
        (print "Not worked yet")))
    (print "No task is running")))
