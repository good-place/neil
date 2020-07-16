(import ../neil/tell :prefix "")

(defn main
  "Program main entry"
  [_]
  (init)
  (def running (:task/by-state c "running"))
  (if running
    (do
      (def [_ {:name n :state s :work-intervals iw}] running)
      (def completed? (= s "completed"))
      (when completed? (prin "\e[35m"))
      (prin "# " n ":")
      (if iw
        (let [{:start s :end e :note t} (last iw)]
          (default e (os/time))
          (print " " (datef (os/date s true) true)
                 " dur: " (durf (- e s))))
        (print "Not worked yet")))
    (print "No task is running")))
