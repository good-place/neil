(import ../neil/tell :prefix "")

(defn main
  "Program main entry"
  [_]
  (init)
  (:task/stop c (get-strip "note:")))
