(declare-project
  :name "Neil"
  :description "Life Scoring with Janet"
  :dependencies ["https://github.com/janet-lang/spork.git"
                 "https://github.com/pepe/jff.git"
                 "https://github.com/good-place/mansion.git"
                 "https://github.com/janet-lang/jhydro.git"])

(declare-executable :name "neil" :entry "neil.janet" :install true)

(declare-source :source ["neil/tell.janet"])

(phony "neil" [] (os/execute ["janet" "neil.janet"] :p))


(post-deps
  (import jhydro :as jh)
  (phony "genpsk" []
         (with-dyns [:out (file/open "psk.key" :w)]
           (print (jh/random/buf 32)))))
