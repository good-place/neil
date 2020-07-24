(declare-project
  :name "neil"
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

(each f (os/dir "neil/actions/")
  (def [n] (peg/match '(<- (to ".")) f))
  (declare-executable :name n
                      :entry (string "neil/actions/" f)
                      :lflags lvd
                      :install true))

(phony "neil" [] (os/execute ["janet" "neil.janet"] :p))


(post-deps
  (import jhydro :as jh)
  (import mansion/buffet)

  (phony "genpsk" []
         (with-dyns [:out (file/open "psk.key" :w)]
           (print (jh/random/buf 32))))
  (phony "createdb" []
         (buffet/create "scores" @{:to-index [:type :abbrev :name :client :project :state]})
         (print "Scores created")))
