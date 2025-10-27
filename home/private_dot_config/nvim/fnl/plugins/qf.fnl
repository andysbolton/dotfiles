(import-macros {: tx} :utils.macros)

(tx :stevearc/quicker.nvim
    {:config (fn []
               (let [{: collapse : expand : toggle :setup qfsetup} (require :quicker)]
                 (vim.keymap.set :n :<leader>q #(toggle)
                                 {:desc "Toggle quickfix"})
                 (vim.keymap.set :n :<leader>l #(toggle {:loclist true})
                                 {:desc "Toggle loclist"})
                 (qfsetup {:keys [(tx ">"
                                      #(expand {:before 2
                                                :after 2
                                                :add_to_existing true})
                                      {:desc "Expand quickfix context"})
                                  (tx "<" #(collapse)
                                      {:desc "Collapse quickfix context"})]})))})
