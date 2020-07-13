(import ../neil/tell :prefix "")

(defn main
  "Program main entry"
  [_]
  (let [task (choose (:task/active c) "task: "
                     |(string/join [(first $) (get-in $ [1 :name])] " - "))]
    (:task/complete c task)))
