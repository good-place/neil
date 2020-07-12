(import ../neil/tell :prefix "")
(import jff)

(defn main
  "Program main entry"
  [_]

  (def running (get-in (:task/running c) [0 0]))
  (if running
    (do
      (print "You have task already running: " (get-in running [1 :name]))
      (getline))
    (->> (:task/active c)
         (map |(string/join [(first $) (get-in $ [1 :name])] " - "))
         (jff/choose "task: ")
         (peg/match '(<- (some :d)))
         first
         (:task/start c))))
