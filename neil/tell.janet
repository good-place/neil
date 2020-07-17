(import hydrpc :as hr)
(import jff)

(defn get-strip [s] (string/trim (getline s)))

(var c nil)

(defn init [&opt hostname port name]
  (default hostname "localhost")
  (default port 6660)
  (default name "neil-tell")
  (set c (hr/client hostname port name)))

(defn running [] (:task/running c))

(defn pad
  "Pads integer to at least two chars. Returns string"
  [i]

  (if (<= 10 i) (string i) (string "0" i)))

(defn datef
  "Format date struct. Returns string"
  [{:month m :year y :month-day d
    :minutes u :hours h :seconds s} &opt time?]

  (if time?
    (string/format "%i:%s:%s" h (pad (inc u)) (pad (inc s)))
    (string/format "%i-%i-%i %i:%s:%s" y (inc m) (inc d) h (pad (inc u)) (pad (inc s)))))

(defn durf
  "Format duration in seconds to mm:ss. Returns string"
  [dur]
  (def m (math/floor (/ dur 60)))
  (def s (pad (mod dur 60)))
  (string/format "%i:%s" m s))


(defn- kw-suf
  [what cmd]
  (keyword (string what "/" cmd)))

(defn list
  "Lists resource what"
  [what]
  ((kw-suf what :list) c))

(defn add
  "Adds data to resource what"
  [what data] ((kw-suf what :add) c data))

(defn nest-list
  "Lists what nested under parent. Parent must be tuple with the id and name and of the parent"
  [parent what]
  ((kw-suf (last parent) what) c (first parent)))

(defn choose
  "Shows chooser for the input and return choosed ID"
  [options prompts linef &opt matcher transformer]
  (default matcher |(peg/match '(<- (some :d)) $))
  (default transformer first)
  (->> options
       (map linef)
       (jff/choose prompts)
       matcher
       transformer))

(defn print-task
  "Nice prints task"
  [t]
  (def [_ {:name n :project pid :work-intervals iw :state s}] t)
  (def {:name p} (:by-id c pid))
  (def dur (and iw (reduce (fn [r i] (+ r (- (or (i :end) (os/time))
                                             (i :start)))) 0 iw)))
  (defn color [state] (case state
                        "completed" "\e[35m"
                        "canceled" "\e[34m"
                        "\e[0m"))
  (print "# \e[36m" p (color s) " - " n
         " \e[36m "
         (if iw
           (string (length iw) "x T" (durf dur))
           "not yet")
         "\e[0m"))

(defn- task-scorer [[_ task]]
  (string (task :project)
          (case (task :state) "running" 100 "active" 10 "complete" 1 0)
          (task :timestamp)))

(defn sort-tasks
  "Sort tasks by state"
  [tasks]
  (sort-by task-scorer tasks))

(defn stop-task
  "Stops task and do commands if in note"
  [running]
  (print "Stopping task: " ((last running) :name))
  (def note (get-strip "note:"))
  (:task/stop c note)
  (when (string/has-suffix? "done" note)
    (print "Marking task as complete")
    (:task/complete c (first running))))
