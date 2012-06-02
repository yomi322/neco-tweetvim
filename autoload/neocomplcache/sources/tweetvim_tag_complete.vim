let s:save_cpo = &cpo
set cpo&vim

let s:source = {
\   'name' : 'tweetvim_name_complete',
\   'kind' : 'ftplugin',
\   'filetypes' : { 'tweetvim_say' : 1 },
\ }

function! s:source.initialize()
  call neocomplcache#set_completion_length('tweetvim_name_complete',
        \ g:neocomplcache_auto_completion_start_length)
endfunction

function! s:source.finalize()
endfunction

function! s:source.get_keyword_pos(cur_text)
  return matchend(a:cur_text, '@')
endfunction

function! s:source.get_complete_words(cur_keyword_pos, cur_keyword_str)
  let keywords = []
  let fname = g:tweetvim_config_dir . '/screen_name'
  if filereadable(fname)
    let keywords = map(readfile(fname), "{ 'word' : v:val, 'menu' : '[tweetvim]' }")
  endif
  return neocomplcache#keyword_filter(keywords, a:cur_keyword_str)
endfunction

function! neocomplcache#sources#tweetvim_name_complete#define()
  return s:source
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

