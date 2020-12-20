if exists("g:loaded_deardiary")
    finish
endif

let s:save_cpo = &cpo
set cpo&vim

command! -nargs=0 DearDiarySelectJournal lua require("deardiary").select_journal()
command! -nargs=0 DearDiaryToday lua require("deardiary").create_diary_entry("daily", 0)
command! -nargs=0 DearDiaryTomorrow lua require("deardiary").create_diary_entry("daily", 1)
command! -nargs=0 DearDiaryYesterday lua require("deardiary").create_diary_entry("daily", -1)
command! -nargs=0 DearDiaryThisWeek lua require("deardiary").create_diary_entry("weekly", 0)
command! -nargs=0 DearDiaryNextWeek lua require("deardiary").create_diary_entry("weekly", 1)
command! -nargs=0 DearDiaryLastWeek lua require("deardiary").create_diary_entry("weekly", -1)
command! -nargs=0 DearDiaryThisMonth lua require("deardiary").create_diary_entry("monthly", 0)
command! -nargs=0 DearDiaryNextMonth lua require("deardiary").create_diary_entry("monthly", 1)
command! -nargs=0 DearDiaryLastMonth lua require("deardiary").create_diary_entry("monthly", -1)
command! -nargs=0 DearDiaryThisYear lua require("deardiary").create_diary_entry("yearly", 0)
command! -nargs=0 DearDiaryNextYear lua require("deardiary").create_diary_entry("yearly", 1)
command! -nargs=0 DearDiaryLastYear lua require("deardiary").create_diary_entry("yearly", -1)

nmap <silent> <Plug>(DearDiarySelectJournal) <cmd>DearDiarySelectJournal<CR>
nmap <silent> <Plug>(DearDiaryToday) <cmd>DearDiaryToday<CR>
nmap <silent> <Plug>(DearDiaryTomorrow) <cmd>DearDiaryTomorrow<CR>
nmap <silent> <Plug>(DearDiaryYesterday) <cmd>DearDiaryYesterday<CR>
nmap <silent> <Plug>(DearDiaryThisWeek) <cmd>DearDiaryThisWeek<CR>
nmap <silent> <Plug>(DearDiaryNextWeek) <cmd>DearDiaryNextWeek<CR>
nmap <silent> <Plug>(DearDiaryLastWeek) <cmd>DearDiaryLastWeek<CR>
nmap <silent> <Plug>(DearDiaryThisMonth) <cmd>DearDiaryThisMonth<CR>
nmap <silent> <Plug>(DearDiaryNextMonth) <cmd>DearDiaryNextMonth<CR>
nmap <silent> <Plug>(DearDiaryLastMonth) <cmd>DearDiaryLastMonth<CR>
nmap <silent> <Plug>(DearDiaryThisYear) <cmd>DearDiaryThisYear<CR>
nmap <silent> <Plug>(DearDiaryNextYear) <cmd>DearDiaryNextYear<CR>
nmap <silent> <Plug>(DearDiaryLastYear) <cmd>DearDiaryLastYear<CR>

if !exists("g:deardiary_use_default_mappings")
    let g:deardiary_use_default_mappings = 1
endif

if g:deardiary_use_default_mappings
    if !hasmapto("<Plug>(DearDiarySelectJournal)")
        nmap <silent> <Leader>js <Plug>(DearDiarySelectJournal)
    endif

    if !hasmapto("<Plug>(DearDiaryToday)")
        nmap <silent> <Leader>jdc <Plug>(DearDiaryToday)
    endif

    if !hasmapto("<Plug>(DearDiaryTomorrow)")
        nmap <silent> <Leader>jdn <Plug>(DearDiaryTomorrow)
    endif

    if !hasmapto("<Plug>(DearDiaryYesterday)")
        nmap <silent> <Leader>jdp <Plug>(DearDiaryYesterday)
    endif

    if !hasmapto("<Plug>(DearDiaryThisWeek)")
        nmap <silent> <Leader>jwc <Plug>(DearDiaryThisWeek)
    endif

    if !hasmapto("<Plug>(DearDiaryNextWeek)")
        nmap <silent> <Leader>jwn <Plug>(DearDiaryNextWeek)
    endif

    if !hasmapto("<Plug>(DearDiaryLastWeek)")
        nmap <silent> <Leader>jwp <Plug>(DearDiaryLastWeek)
    endif

    if !hasmapto("<Plug>(DearDiaryThisMonth)")
        nmap <silent> <Leader>jmc <Plug>(DearDiaryThisMonth)
    endif

    if !hasmapto("<Plug>(DearDiaryNextMonth)")
        nmap <silent> <Leader>jmn <Plug>(DearDiaryNextMonth)
    endif

    if !hasmapto("<Plug>(DearDiaryLastMonth)")
        nmap <silent> <Leader>jmp <Plug>(DearDiaryLastMonth)
    endif

    if !hasmapto("<Plug>(DearDiaryThisYear)")
        nmap <silent> <Leader>jyc <Plug>(DearDiaryThisYear)
    endif

    if !hasmapto("<Plug>(DearDiaryNextYear)")
        nmap <silent> <Leader>jyn <Plug>(DearDiaryNextYear)
    endif

    if !hasmapto("<Plug>(DearDiaryLastYear)")
        nmap <silent> <Leader>jyp <Plug>(DearDiaryLastYear)
    endif
end

let &cpo = s:save_cpo
unlet s:save_cpo

let g:loaded_deardiary = 1
