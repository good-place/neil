(import neil/tell :prefix "")

(defn main
  "Program main entry"
  [_]
  (each t (:task/active c)
    (def [_ {:name n :project pid :work-intervals iw}] t)
    (def {:name p} (:by-id c pid))
    (def dur (and iw (reduce (fn [r i] (+ r (- (i :end) (i :start)))) 0 iw)))
    (print "# \e[36m" p "\e[0m - " n
           " \e[36m "
           (if iw
             (string (length iw) "x T" (durf dur))
             "not yet")
           "\e[0m")))
