(import ../tell :prefix "")
(import sh)

(defn main
  "Program main entry"
  [_]
  (var cmd nil)
  (var cmds [])
  (forever
    (unless cmd
      (set cmds (if (tell (running))
                  ["so - stop-task"
                   "ss - stop-and-start"
                   "ar - add-task-running"
                   "nt - cancel-task"
                   "ap - add-task-to-project"]
                  ["sa - start-task"
                   "co - continue-last"
                   "ct - complete-task"
                   "nt - cancel-task"
                   "as - add-and-start"
                   "ap - add-task-to-project"
                   "la - list-all-tasks"
                   "lc - list-tasks-by-client"
                   "lp - list-tasks-by-project"
                   "ls - list-tasks-by-state"
                   "ar - add-project-to-client"
                   "ac - add-client"]))
      (set cmd
           (choose cmds "tell neil:" string
                   |(peg/match '(* (thru "-") " " '(any 1)) $) first)))
    (def code (get-in
                (require (string "./neil/actions/" cmd))
                ['main :value]))
    (code cmd)

    (case (get-strip "cmd [h]ome, [r]erun:")
      "h" (set cmd nil)
      "r" (print "Rerun " cmd)
      (break))))
