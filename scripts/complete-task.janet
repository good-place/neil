(import ../neil/tell :prefix "")

(defn main
  "Program main entry"
  [_]
  (init)
  (let [task (choose (:task/by-state c "active") "task: "
                     |(string/join [(first $) (get-in $ [1 :name])] " - "))]
    (:task/complete c task)))
