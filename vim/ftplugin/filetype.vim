" Detecting YAML files
augroup filetypedetect
    au BufNewFile, BufRead *.yaml   setf yaml
    au BufNewFile, BufRead *.yml    setf yaml
augroup END
