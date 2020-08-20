(declare-project
  :name "neil"
  :description "Life Scoring with Janet"
  :dependencies ["https://github.com/janet-lang/spork.git"
                 "https://github.com/pepe/jff.git"
                 "https://github.com/good-place/mansion.git"
                 "https://github.com/janet-lang/jhydro.git"
                 "https://github.com/bakpakin/janet-miniz.git"
                 "https://github.com/andrewchambers/janet-sh.git"
                 "https://github.com/joy-framework/dotenv"])

(declare-source :source ["neil/tell.janet"])

(def lvd ["-lleveldb"])
(declare-executable :name "neil"
                    :entry "neil.janet"
                    :lflags lvd
                    :install true)

(declare-executable :name "dashboard"
                    :entry "neil/actions/dashboard.janet"
                    :lflags lvd
                    :install true)

(phony "neil" [] (os/execute ["janet" "neil.janet"] :p))


(post-deps
  (import jhydro :as jh)
  (import mansion/buffet)

  (phony "genpsk" []
         (with-dyns [:out (file/open ".env" :a)]
           (print "NEIL_PSK=" (jh/random/buf 32))))
  (phony "createdb" []
         (buffet/create "scores" @{:to-index [:type :abbrev :name :client :project :state]})
         (print "Scores created")))
