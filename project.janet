(declare-project
  :name "Neil"
  :description "Life Scoring with Janet"
  :dependencies ["https://github.com/janet-lang/spork.git"
                 "https://github.com/pepe/jff.git"
                 "https://github.com/good-place/mansion.git"
                 "https://github.com/janet-lang/jhydro.git"
                 "https://github.com/bakpakin/janet-miniz.git"
                 "https://github.com/andrewchambers/janet-sh.git"])

(declare-source :source ["neil/tell.janet"])

(def lvd ["-lleveldb"])
(declare-executable :name "neil"
                    :entry "neil.janet"
                    :lflags lvd
                    :install true)

(each f (os/dir "scripts")
  (def [n] (peg/match '(<- (to ".")) f))
  (declare-executable :name n
                      :entry (string "scripts/" f)
                      :lflags lvd
                      :install true))

(phony "neil" [] (os/execute ["janet" "neil.janet"] :p))


(post-deps
  (import jhydro :as jh)
  (phony "genpsk" []
         (with-dyns [:out (file/open "psk.key" :w)]
           (print (jh/random/buf 32)))))
