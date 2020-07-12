(import neil/tell :prefix "")

(defn main
  "Program main entry"
  [_]
  (def client
    (choose (first (list :client))
            "client: "
            |(string/join [(first $) (get-in $ [1 :abbrev]) (get-in $ [1 :name])] " - ")))
  (def project
    (choose (first (nest-list [client :client] :projects))
            (string "project [" client "]: ")
            |(string/join [(first $) (get-in $ [1 :name])] " - ")))
  (each t (first (:project/tasks c project))
    (def [_ {:name n :work-intervals iw}] t)
    (print "# " n)
    (if iw
      (each {:start s :end e :note t} iw
        (default e (os/time))
        (print "  " (datef (os/date s true))
               " - " (datef (os/date e true) true)
               " dur: " (durf (- e s))
               " note: " (or t "still running")))
      (print "Not worked yet")))
  (getline "Press enter to finish"))
