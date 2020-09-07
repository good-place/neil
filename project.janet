(declare-project
  :name "neil"
  :description "Life Scoring with Janet"
  :dependencies ["https://github.com/janet-lang/spork.git"
                 "https://github.com/pepe/jff.git"
                 "https://github.com/good-place/mansion.git"
                 "https://github.com/janet-lang/jhydro.git"
                 "https://github.com/bakpakin/janet-miniz.git"
                 "https://github.com/joy-framework/dotenv"])

(declare-source :source ["neil"])

(declare-binscript :main "neiloffice" :install true)

(declare-binscript :main "neilcomm" :install true)

(phony "offi" [] (os/execute ["neiloffice"] :p))

(phony "comm" [] (os/execute ["neilcomm"] :p))

(post-deps
  (import jhydro :as jh)
  (import mansion/buffet)

  (phony "createdb" []
         (buffet/create "scores" @{:to-index [:type :abbrev :name :client :project :state]})
         (print "Scores created")))
