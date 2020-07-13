(import ../neil/tell :prefix "")

(defn main
  "Program main entry"
  [_]
  (init)
  (def client
    (choose (first (list :client))
            "client: "
            |(string/join [(first $) (get-in $ [1 :abbrev]) (get-in $ [1 :name])] " - ")))
  (print "Created project with id: "
         (add :project {:client client
                        :name (string/trim (getline "project:"))}))
  (os/sleep 2))
