{:formatter {:actions [(fn [] {:args [:--fix] :exe :fnlfmt :stdin false})]
             :autoinstall false
             :name :fnlfmt}
 :ft [:fennel]
 :ls {:name :fennel_language_server
      :settings {:fennel {:diagnostics {:globals [:vim]}
                          :workspace {:library (vim.api.nvim_list_runtime_paths)}}}}
 :name :fennel
 :treesitter :fennel}
