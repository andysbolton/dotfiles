{:name :c
 :ft [:c]
 :ls {:name :clangd
      :settings {:cmd [:clangd :--clang-tidy :--offset-encoding=utf-16]}}
 :formatter {:name :clang-format
             :actions #(let [fmt (require :formatter.filetypes.c)]
                         (fmt.clangformat))
             :autoinstall false}
 :linter {:name :cpplint}
 :treesitter :c}
