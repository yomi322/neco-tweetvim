let s:save_cpo = &cpo
set cpo&vim
"
" source
"
let s:source = {
\   'name'      : 'tweetvim_tag_complete',
\   'rank'      : 200,
\   'kind'      : 'manual',
\   'filetypes' : { 'tweetvim_say' : 1 },
\ }
"
" return complete position after #.
" return -1 if not completable.
"
function! s:source.get_complete_position(context)
  let col = col('.')
  let pos = 0
  while 1
    let idx = stridx(a:context.input, '#', pos + 1)
    if idx == -1 || idx >= col
      break
    endif
    let pos = idx
  endwhile

  let pos  = matchend(a:context.input, '#', pos)
  let text = eval("a:context.input[" . string(pos) . ":" . string(pos + g:neocomplete#auto_completion_start_length) . "]")
  let text = substitute(text, ' ', '', '#')
  let pos  = len(text) < g:neocomplete#auto_completion_start_length ? -1 : pos
  
  return pos
endfunction
"
" gather candidates from tweetvim's cache
"
function! s:source.gather_candidates(context)
  if !exists('s:keywords')
    let s:keywords = map(tweetvim#cache#get('hash_tag'),
          \ "{ 'word' : v:val, 'menu' : '[tweetvim]' }")
  endif
  return filter(copy(s:keywords), 'v:val.word =~ "' . a:context.complete_str . '"')
endfunction
"
" source#define
"
function! neocomplete#sources#tweetvim_tag_complete#define()
  return s:source
endfunction
"
" hook to recache word
"
call tweetvim#hook#add(
      \ 'write_hash_tag',
      \ 'neocomplete#sources#tweetvim_tag_complete#recache')
"
" recache tweetvim's tag.
"
function! neocomplete#sources#tweetvim_name_complete#recache(...)
  let s:keywords = map(a:1, "{ 'word' : v:val, 'menu' : '[tweetvim]' }")
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
