(import neil/tell :prefix "")

(print
  (string/join
    (->> :client list first
         (map |(string/join [(first $) (get-in $ [1 :abbrev]) (get-in $ [1 :name])] " - "))) "\n"))
