(import ../neil/tell :prefix "")

(defn main
  "Program main entry"
  [_]
  (init)
  (def client
    (choose (first (list :client))
            "client: "
            |(string/join [(first $) (get-in $ [1 :abbrev]) (get-in $ [1 :name])] " - ")))
  (each [p] (first (nest-list [client :client] :projects))
    (each t (first (nest-list [p :project] :tasks))
      (def [_ {:name n :project pid :work-intervals iw :state s}] t)
      (def {:name p} (:by-id c pid))
      (def dur (and iw (reduce (fn [r i] (+ r (- (or (i :end) (os/time))
                                                 (i :start)))) 0 iw)))
      (def completed? (= s "completed"))
      (print "# \e[36m" p (if completed? "\e[35m" "\e[0m") " - " n
             " \e[36m "
             (if iw
               (string (length iw) "x T" (durf dur))
               "not yet")
             "\e[0m")))
  (confirm-exit))
