(import ../tell :prefix "")

(defn main
  "Program main entry"
  [_]
  (each [_ p] (sort (list :project) (fn [[_ a] [_ b]] (< (a :client) (b :client))))
    (def c (by-id (p :client)))
    (print (p :name) " - " (c :name))))
