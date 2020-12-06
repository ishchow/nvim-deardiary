fun! DearDiary()
    lua for k in pairs(package.loaded) do if k:match("^deardiary") then package.loaded[k] = nil end end
    lua require('deardiary')
endfun

augroup DearDiary
    autocmd!
augroup end
