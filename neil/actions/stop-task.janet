(import ../tell :prefix "")

(defn main
  "Program main entry"
  [_]
  (tell
    (if (running)
      (stop (running))
      (error "You are not running any task"))))
