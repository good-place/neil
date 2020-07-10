(import ../neil/tell :prefix "")
(import jff)

(defn main
  "Program main entry"
  [_]
  (def task
    (->> (:task/active c)
         first
         (map |(string/join [(first $) (get-in $ [1 :name])] " - "))
         (jff/choose "task: : ")))
  (:))
