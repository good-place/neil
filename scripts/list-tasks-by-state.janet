(import ../neil/tell :prefix "")

(defn main
  "Program main entry"
  [_]
  (init)
  (def state (-> ["active" "completed"]
                 (choose "tell neil:" string identity identity)))
  (each t (:task/by-state c state)
    (def [_ {:name n :project pid :work-intervals iw :state s}] t)
    (def {:name p} (:by-id c pid))
    (def dur
      (and iw (reduce
                (fn [r i]
                  (+ r (- (or (i :end) (os/time))
                          (i :start))))
                0 iw)))
    (def completed? (= s "completed"))
    (print "# \e[36m" p (if completed? "\e[35m" "\e[0m") " - " n
           " \e[36m "
           (if iw
             (string (length iw) "x T" (durf dur))
             "not yet")
           "\e[0m")))
