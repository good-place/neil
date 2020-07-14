(import ../neil/tell :prefix "")

(defn main
  "Program main entry"
  [_]
  (init)
  (def project
    (choose (first (list :project))
            (string "project: ")
            |(string/join [(first $) (get-in $ [1 :name])] " - ")))
  (each t (first (:project/tasks c project))
    (def [_ {:name n :state s :work-intervals iw}] t)
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
      (print "Not worked yet"))
    (when completed? (prin "\e[0m"))))
