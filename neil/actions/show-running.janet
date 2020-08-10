(import ../tell :prefix "")

(defn main
  "Program main entry"
  [_]
  (tell
    (if-let [[rid {:name n :project pid :work-intervals iw :state s}] (running)
             {:name p} (by-id pid)
             {:start s :note t} (last iw)]
      (prin (durf (- (os/time) s)) " @" p " - #" rid " " n "")
      (print "Last ran: " (get-in (last-running) [1 :name])))))
