(import ../neil/tell :prefix "")
(import jff)

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
  (add :project {:client client
                 :name (string/trim (getline "project:"))}))
