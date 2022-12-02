f = __FILE__.sub(/\d\..*/, 'input')
p eval"[#{File.read(f).tr(?\n,?+).gsub'++',?,}].max(3).sum"
