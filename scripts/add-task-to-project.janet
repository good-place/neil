(import ../neil/tell :prefix "")

(defn main
  "Program main entry"
  [_]
  (init)

  (def project
    (choose (first (list :project))
            (string "project: ")
            |(string/join [(first $) (get-in $ [1 :name])] " - ")))
  (print "Added task with id: "
         (add :task {:project project
                     :name (get-strip "task:")}))
  (os/sleep 2))
