let s:save_cpo = &cpo
set cpo&vim

let s:source = {
\   'name' : 'tweetvim_tag_complete',
\   'kind' : 'ftplugin',
\   'filetypes' : { 'tweetvim_say' : 1 },
\ }

function! s:source.initialize()
  call neocomplcache#set_completion_length('tweetvim_tag_complete',
        \ g:neocomplcache_auto_completion_start_length)
endfunction

function! s:source.finalize()
endfunction

function! s:source.get_keyword_pos(cur_text)
  let col = col('.')
  let pos = 0
  while 1
    let idx = stridx(a:cur_text, '#', pos + 1)
    if idx == -1 || idx >= col
      break
    endif
    let pos = idx
  endwhile
  return matchend(a:cur_text, '#', pos)
endfunction

function! s:source.get_complete_words(cur_keyword_pos, cur_keyword_str)
  let keywords = map(tweetvim#cache#get('hash_tag'),
        \ "{ 'word' : v:val, 'menu' : '[tweetvim]' }")
  return neocomplcache#keyword_filter(keywords, a:cur_keyword_str)
endfunction

function! neocomplcache#sources#tweetvim_tag_complete#define()
  return s:source
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
