(declare-project
  :name "Neil"
  :description "Life Scoring with Janet"
  :dependencies ["https://github.com/janet-lang/spork.git"
                 "https://github.com/pepe/jff.git"])

(declare-executable :name "neil" :entry "neil.janet" :install true)

(declare-source :source ["neil/tell.janet"])
