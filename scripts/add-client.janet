(import ../neil/tell :prefix "")

(defn main
  "Program main entry"
  [_]
  (def name (get-strip "name:"))
  (def abbrev (get-strip "abbrev:"))
  (def note (get-strip "note:"))
  (init)
  (print "Client created with id:"
         (add :client {:name name
                       :abbrev abbrev
                       :note note})))
