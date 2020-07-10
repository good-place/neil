(import ../neil/tell :prefix "")
(import jff)

(defn main
  "Program main entry"
  [_]
  (def name (get-strip "name:"))
  (def abbrev (get-strip "abbrev:"))
  (def note (get-strip "note:"))
  (:client/add c {:name name
                  :abbrev abbrev
                  :note note}))
