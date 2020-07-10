(import ../neil/tell :prefix "")
(import jff)

(defn main
  "Program main entry"
  [_]

  (if (empty? (first (:task/running c)))
    (->> (:task/active c)
         (map |(string/join [(first $) (get-in $ [1 :name])] " - "))
         (jff/choose "task: ")
         (peg/match '(<- (some :d)))
         first
         (:task/start c))
    (print "You have task already running")))
