(import neil/tell :prefix "")

(defn main
  "Program main entry"
  [_]
  (print (choose (first (list :client)) "client: "
                 |(string/join [(first $) (get-in $ [1 :abbrev]) (get-in $ [1 :name])] " - "))))
