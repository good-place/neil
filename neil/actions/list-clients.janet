(import ../tell :prefix "")

(defn main
  "Program main entry"
  [_]
  (each [i c] (sort (list :client) (fn [[a _] [b _]] (< a b)))
    (print "#" i " - " (c :name))))
