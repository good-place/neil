(import ../neil/tell :prefix "")
(import sh)

(defn main
  "Program main entry"
  [_]
  (-> ["show-running"
       "start-task"
       "stop-task"
       "add-task-to-project"
       "complete-task"
       "list-all-tasks"
       "list-tasks-by-client"
       "list-tasks-by-project"
       "list-tasks-by-state"]
      (choose "tell neil:" string identity identity)
      sh/$))
