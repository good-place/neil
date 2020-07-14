(import hydrpc :as hr)
(import jff)

(defn get-strip [s] (string/trim (getline s)))

(var c nil)

(defn init [&opt hostname port name]
  (default hostname "localhost")
  (default port 6660)
  (default name "neil-tell")
  (set c (hr/client hostname port name)))

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
