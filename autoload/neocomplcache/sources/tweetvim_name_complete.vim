let s:save_cpo = &cpo
set cpo&vim

let s:source = {
\   'name' : 'tweetvim_name_complete',
\   'kind' : 'ftplugin',
\   'filetypes' : { 'tweetvim_say' : 1 },
\ }

let s:keywords = []
let s:fname = expand('~/.tweetvim/screen_name')
if filereadable(s:fname)
  for word in readfile(s:fname)
    call add(s:keywords, { 'word' : word, 'menu' : '[tweetvim]' })
  endfor
endif

function! s:source.initialize()
endfunction

function! s:source.finalize()
endfunction

function! s:source.get_keyword_pos(cur_text)
  return matchend(a:cur_text, '@')
endfunction

function! s:source.get_complete_words(cur_keyword_pos, cur_keyword_str)
  return neocomplcache#keyword_filter(copy(s:keywords), a:cur_keyword_str)
endfunction

function! neocomplcache#sources#tweetvim_name_complete#define()
  return s:source
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

