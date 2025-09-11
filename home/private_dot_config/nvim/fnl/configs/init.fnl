(let [files (vim.api.nvim_get_runtime_file :lua/configs/langs/*.lua true)
      langs {}]
  (each [_ filename (pairs files)]
    (let [module (.. :configs.langs.
                     (string.gsub filename "(.*[/\\])(.*)%.lua" "%2"))
          lang (require module)]
      (when (= (type lang) :table)
        (table.insert langs lang))))
  langs)
