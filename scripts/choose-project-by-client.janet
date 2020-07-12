(import neil/tell :prefix "")
(import jff)

(defn main
  "Program main entry"
  [_]
  (def client
    (choose (first (list :client)) "client: "
            |(string/join [(first $) (get-in $ [1 :abbrev]) (get-in $ [1 :name])] " - ")))
  (def project
    (choose (first (nest-list [client :client] :projects)) (string "project [" client "]: ")
            |(string/join [(first $) (get-in $ [1 :name])] " - "))))
