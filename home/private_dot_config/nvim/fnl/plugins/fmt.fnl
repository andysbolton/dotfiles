(import-macros {: tx} :utils.macros)

(local formatters (let [{: get_formatters} (require :configs.util)]
                    (get_formatters)))

(local formatter-names (accumulate [acc [] _ formatter (pairs formatters)]
                         (do
                           (if (and formatter.name
                                    (not= formatter.use_lsp true)
                                    (not= formatter.autoinstall false))
                               (table.insert acc formatter.name))
                           acc)))

(local filetype-actions (accumulate [acc [] _ formatter (pairs formatters)]
                          (do
                            (each [_ filetype (pairs (or formatter.filetypes {}))]
                              (tset acc filetype formatter.actions))
                            acc)))

[(tx :mhartington/formatter.nvim
     {:dependencies [:williamboman/mason.nvim
                     :WhoIsSethDaniel/mason-tool-installer.nvim]
      :config #(let [mason-tool-installer (require :mason-tool-installer)
                     {: remove_trailing_whitespace} (require :formatter.filetypes.any)
                     {: register_formatters} (require :cmds.fmt)
                     formatter (require :formatter)]
                 (mason-tool-installer.setup {:ensure_installed [(table.unpack formatter-names)]})
                 (if (= vim.fn.has :win32)
                     (tset filetype-actions "*" (remove_trailing_whitespace)))
                 (formatter.setup {:logging true
                                   :log_level vim.log.levels.WARN
                                   :filetype filetype-actions})
                 (register_formatters))})]
