(import ../tell :prefix "")

(defn main
  "Program main entry"
  [_]
  (if (running)
    (stop)
    (error "You are not running any task")))
