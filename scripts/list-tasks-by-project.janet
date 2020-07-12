(import neil/tell :prefix "")
(import jff)

(defn- datef [{:month m :year y :month-day d
               :minutes u :hours h :seconds s} &opt time?]
  (if time?
    (string/format "%i:%i:%i" h (inc u) (inc s))
    (string/format "%i-%i-%i %i:%i:%i" y (inc m) (inc d) h (inc u) (inc s))))

# @fixme tasks in projects
(defn main
  "Program main entry"
  [_]
  (def client
    (->> (list :client)
         first
         (map |(string/join [(first $) (get-in $ [1 :abbrev]) (get-in $ [1 :name])] " - "))
         (jff/choose "client: ")
         (peg/match '(<- (some :d)))
         first))
  (def project
    (->> (nest-list [client :client] :projects)
         first
         (map |(string/join [(first $) (get-in $ [1 :name])] " - "))
         (jff/choose (string "project [" client "]: "))
         (peg/match '(<- (some :d)))
         first))
  (each t (first (:project/tasks c project))
    (def [_ {:name n :work-intervals iw}] t)
    (print "# " n)
    (each {:start s :end e :note t} iw
      (default e (os/time))
      (print "  " (datef (os/date s true)) " - " (datef (os/date e true) true) " dur: " (- e s) "s note: " (or t "still running")))))
