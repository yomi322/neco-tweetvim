let s:save_cpo = &cpo
set cpo&vim

let s:source = {
\   'name'        : 'tweetvim_name_complete',
\   'rank'        : 200,
\   'kind'        : 'manual',
\   'filetypes'   : { 'tweetvim_say' : 1 },
\ }

call tweetvim#hook#add(
      \ 'write_screen_name',
      \ 'neocomplete#sources#tweetvim_name_complete#recache')

function! s:source.get_complete_position(context)
  let col = col('.')
  let pos = 0
  while 1
    let idx = stridx(a:context.input, '@', pos + 1)
    if idx == -1 || idx >= col
      break
    endif
    let pos = idx
  endwhile

  let pos  = matchend(a:context.input, '@', pos)
  let text = eval("a:context.input[" . string(pos) . ":" . string(pos + g:neocomplete#auto_completion_start_length) . "]")
  let text = substitute(text, ' ', '', 'g')
  let pos  = len(text) < g:neocomplete#auto_completion_start_length ? -1 : pos
  
  return pos
endfunction

function! s:source.gather_candidates(context)
  if !exists('s:keywords')
    let s:keywords = map(tweetvim#cache#get('screen_name'),
          \ "{ 'word' : v:val, 'menu' : '[tweetvim]' }")
  endif
  return filter(copy(s:keywords), 'v:val.word =~ "' . a:context.complete_str . '"')
endfunction

function! neocomplete#sources#tweetvim_name_complete#define()
  return s:source
endfunction

function! neocomplete#sources#tweetvim_name_complete#recache(...)
  let s:keywords = map(a:1, "{ 'word' : v:val, 'menu' : '[tweetvim]' }")
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

