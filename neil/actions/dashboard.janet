(import ../tell :prefix "")
(import sh)

(defn main
  "Program main entry"
  [_]
  (var cmd nil)
  (forever
    (unless cmd
      (set cmd
           (choose ["sa - start-task"
                    "so - stop-task"
                    "ct - complete-task"
                    "ss - stop-and-start"
                    "nt - cancel-task"
                    "as - add-and-start"
                    "ap - add-task-to-project"
                    "la - list-all-tasks"
                    "lc - list-tasks-by-client"
                    "lp - list-tasks-by-project"
                    "ls - list-tasks-by-state"
                    "ar - add-project-to-client"
                    "ac - add-client"] "tell neil:" string
                   |(peg/match '(* (thru "-") " " '(any 1)) $) first)))
    (sh/$ (string "/usr/local/bin/" cmd))
    (case (get-strip "cmd [h]ome, [r]erun:")
      "h" (set cmd nil)
      "r" (print "Rerun " cmd)
      (break))))
