(import neil/tell :prefix "")
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
  (->> (nest-list [client :client] :projects)
       first
       (map |(string/join [(first $) (get-in $ [1 :name])] " - "))
       (jff/choose (string "project [" client "]: "))
       (peg/match '(<- (some :d)))
       first
       print))
