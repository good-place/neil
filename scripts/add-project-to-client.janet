(import ../neil/tell :prefix "")

(defn main
  "Program main entry"
  [_]
  (init)
  (def client
    (choose (first (list :client))
            "client: "
            |(string/join [(first $) (get-in $ [1 :abbrev]) (get-in $ [1 :name])] " - ")))
  (add :project {:client client
                 :name (string/trim (getline "project:"))}))
