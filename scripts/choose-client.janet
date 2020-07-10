(import neil/tell :prefix "")
(import jff)

(defn main
  "Program main entry"
  [_]
  (->> (list :client)
       first
       (map |(string/join [(first $) (get-in $ [1 :abbrev]) (get-in $ [1 :name])] " - "))
       (jff/choose "client: ")
       (peg/match '(<- (some :d)))
       first
       print))
