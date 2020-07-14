(import ../neil/tell :prefix "")

(defn main
  "Program main entry"
  [_]
  (init)
  (def running (first (:task/by-state c "running")))
  (if running
    (do
      (def [_ {:name n :state s :work-intervals iw}] running)
      (def completed? (= s "completed"))
      (when completed? (prin "\e[35m"))
      (print "# " n)
      (if iw
        (each {:start s :end e :note t} iw
          (default e (os/time))
          (print "  " (datef (os/date s true))
                 " - " (datef (os/date e true) true)
                 " dur: " (durf (- e s))
                 " note: " (or t "still running")))
        (print "Not worked yet")))
    (print "No task is running")))
