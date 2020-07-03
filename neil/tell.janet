(import spork/rpc)

(def c (rpc/client "localhost" 6660 "neil-tell"))

(defn- kw-suf
  [what cmd]
  (keyword (string what "/" cmd)))

(defn list
  "Lists resource what"
  [what]
  ((kw-suf what :list) c))

(defn add
  "Adds data to resource what "
  [what data] ((kw-suf what :add) c data))

(defn nest-list
  "Lists what nested under parent. Parent must be tuple with the id and name and of the parent"
  [parent what]
  ((kw-suf (last parent) what) c (first parent)))
