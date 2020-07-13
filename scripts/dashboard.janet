(import ../neil/tell :prefix "")
(import sh)

(defn main
  "Program main entry"
  [_]
  (def cmd (-> ["show-running"
                "start-task"
                "stop-task"
                "add-task-to-project"
                "complete-task"
                "list-all-tasks"
                "list-tasks-by-client"
                "list-tasks-by-project"
                "list-tasks-by-state"
                "add-project-to-client"
                "add-client"]
               (choose "tell neil:" string identity identity)))
  (sh/$ (string "/usr/local/bin/" cmd)))
