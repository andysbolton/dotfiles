(local M {})

(local config_utils (require :configs.util))
(local utils (require :utils))
(local formatters-by-ft {})

(each [_ lang (pairs (config_utils.get_configs))]
  (when lang.formatter
    (if (or (utils.empty lang.ft) (= #lang.ft 0))
        (vim.notify (.. "No filetypes specified for " lang.name ".")
                    vim.log.levels.WARN)
        (each [_ ft (pairs lang.ft)]
          (tset formatters-by-ft ft lang.formatter)))))

(fn get-file-name [path]
  (let [matches {}]
    (each [seg (string.gmatch path "([^/\\]+)")]
      (table.insert matches seg))
    (. matches (length matches))))

; TODO: Replace function name with kebab case once consumer is refactored.
(fn M.register_formatters []
  (let [group (vim.api.nvim_create_augroup :formatting-group {:clear true})]
    (vim.api.nvim_create_autocmd :BufWritePost
                                 {: group
                                  :callback (fn [ev]
                                              (let [formatter (. formatters-by-ft
                                                                 vim.bo.filetype)]
                                                (when formatter
                                                  (if formatter.use_lsp
                                                      (vim.lsp.buf.format)
                                                      (vim.cmd "FormatWrite"))
                                                  (vim.notify (.. "Formatted "
                                                                  (get-file-name ev.file)
                                                                  " with "
                                                                  (or formatter.name
                                                                      "[couldn't find formatter name]")
                                                                  (or (and formatter.use_lsp
                                                                           " (LSP)")
                                                                      "")
                                                                  " (buf "
                                                                  ev.buf ")."))
                                                  nil)))})))

M
