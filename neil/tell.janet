(import ./psk :prefix "")
(import ./hydrpc :as hr)
(import jff)

# utils
(defn get-strip [s] (string/trim (getline s)))

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
    (string/format "%i-%s-%s %i:%s:%s" y (pad (inc m)) (pad (inc d)) h (pad (inc u)) (pad (inc s)))))

(defn durf
  "Format duration in seconds to mm:ss. Returns string"
  [dur]
  (def m (math/floor (/ dur 60)))
  (def s (pad (mod dur 60)))
  (string/format "%i:%s" m s))

(defn- kw-suf
  [what cmd]
  (keyword (string what "/" cmd)))

# telling
(defn init [&opt hostname port name]
  (def [h p] (string/split ":" (or (os/getenv "NEIL_URL") "localhost:6660")))
  (default hostname h)
  (default port p)
  (default name "neil-tell")
  (hr/client hostname port name psk))

(defmacro tell
  "Macro wchich defines neil for all the forms.
   It ensures closing connection after all forms are evalueated."
  [& forms]
  ~(with [neil (init)] ,;forms))

(defn running [] (tell (:task/running neil)))

(defn by-state
  "Returns tasks by state"
  [state]
  (tell (:task/by-state neil state)))

(def memo @{})

(defn by-id
  "Find by id with memoization"
  [id]
  (if-let [e (memo id)]
    e
    (let [e (tell (:by-id neil id))]
      (put memo id e)
      e)))

(defn list
  "Lists resource what"
  [what]
  (tell ((kw-suf what :list) neil)))

(defn add
  "Adds data to resource what"
  [what data]
  (eachp [k v] data
    (unless (and (string? v) (not (empty? v)))
      (error (string "Key " k " must be non empty string. Was " v))))
  (tell ((kw-suf what :add) neil data)))

(defn nest-list
  "Lists what nested under parent. Parent must be tuple with the id and name and of the parent"
  [parent what]
  (tell ((kw-suf (last parent) what) neil (first parent))))

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

(defn state-color [state]
  (case state
    "completed" "\e[35m"
    "canceled" "\e[34m"
    "\e[0m"))

(defn print-task
  "Nice prints task"
  [task &opt project]
  (def [_ {:name n :project pid :work-intervals iw :state s}] task)
  (default project ((by-id pid) :name))
  (def dur
    (and iw (reduce (fn [r i] (+ r (- (or (i :end) (os/time)) (i :start)))) 0 iw)))
  (print "# \e[36m" project (state-color s) " - " n
         " \e[36m "
         (if iw
           (string (length iw) "x T" (durf dur))
           "not yet")
         "\e[0m"))

(defn overview-task
  "Prints task overview with work intervals"
  [task &opt project]
  (print-task task project)
  (if-let [iw (get-in task [1 :work-intervals])]
    (each {:start s :end e :note t} iw
      (default e (os/time))
      (print "  " (datef (os/date s true))
             " - " (datef (os/date e true) true)
             " dur: " (durf (- e s))
             " note: " (or t "still running")))
    (print "Not worked yet")))


(defn sort-tasks
  "Sort tasks by state"
  [tasks]
  (defn score [task]
    (case (task :state)
      "running" 3
      "active" 2
      "completed" 1
      "canceled" 0
      (error (string "Unknown state " (task :state)))))
  (defn scorer [[_ task]]
    (string (task :project)
            (score task)
            (task :timestamp)))
  (sort-by scorer tasks))

(defn stop
  "Stops task and do commands if in note"
  []
  (print "Stopping running ask")
  (def note (get-strip "note:"))
  (tell
    (def r (first (running)))
    (if (string/has-suffix? "done" note)
      (do
        (print "Marking task as complete")
        (:task/complete neil r))
      (:task/stop neil note))))

(defn last-running
  "Returns the last ran task"
  []
  (->> (tell (:task/by-state neil "active"))
       (filter (fn [t] (get-in t [1 :work-intervals])))
       (sort-by |((last (get-in $ [1 :work-intervals])) :end))
       last))

(defn start
  "Starts the task"
  [task]
  (tell (:task/start neil task)))

(defn complete
  "Completes task"
  [id]
  (tell (:task/complete neil id)))

(defn cancel
  "Cancel task"
  [id]
  (tell (:task/cancel neil id)))
