(import ../tell :prefix "")

(defn main
  "Program main entry"
  [_]
  (def client
    (choose (list :client)
            "client: "
            |(string/join [(first $) (get-in $ [1 :abbrev]) (get-in $ [1 :name])] " - ")))
  (print "Created project with id: "
         (add :project {:client client
                        :name (string/trim (getline "project:"))})))
