(import neil/tell :prefix "")

(defn main
  "Program main entry"
  [_]
  (each t (:task/active c)
    (def [_ {:name n :work-intervals iw}] t)
    (def dur (and iw (reduce (fn [r i] (+ r (- (i :end) (i :start)))) 0 iw)))
    (print "# " n
           " \e[36m "
           (if iw
             (string (length iw) "x T" (durf dur))
             "not yet")
           "\e[0m")))
