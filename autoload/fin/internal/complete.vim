let s:modes = [
      \ 'm',
      \ 'n',
      \ 't',
      \ 'i',
      \ 'x',
      \ '!',
      \]

let s:options = {
      \ 'Fern': [
      \   '-matcher=',
      \   '-matchers=',
      \   '-feedkeys=',
      \ ],
      \ 'FernFocus': [
      \   '-mode',
      \ ]
      \}

function! fin#internal#complete#modes(arglead, cmdline, cursorpos) abort
  let pattern = '^' . a:arglead
  let candidates = map(copy(s:modes), { _, v -> printf('-mode=%s', v) })
  return filter(candidates, { _, v -> v =~# pattern })
endfunction

function! fern#internal#complete#options(arglead, cmdline, cursorpos) abort
  let pattern = '^' . a:arglead
  let command = matchstr(a:cmdline, '^\w\+')
  let candidates = get(s:options, command, [])
  return filter(copy(candidates), { _, v -> v =~# pattern })
endfunction

function! fern#internal#complete#url(arglead, cmdline, cursorpos) abort
  let scheme = matchstr(a:arglead, '^[^:]\+\ze://')
  if empty(scheme)
    return map(getcompletion(a:arglead, 'dir'), { -> escape(v:val, ' ') })
  endif
  let rs = fern#internal#scheme#complete_url(scheme, a:arglead, a:cmdline, a:cursorpos)
  return rs is# v:null ? [printf('%s:///', scheme)] : rs
endfunction

function! fern#internal#complete#reveal(arglead, cmdline, cursorpos) abort
  let scheme = matchstr(a:cmdline, '\<[^ :]\+\ze://')
  if empty(scheme)
    let rs = getcompletion(matchstr(a:arglead, '^-reveal=\zs.*'), 'file')
    call map(rs, { _, v -> matchstr(v, '.\{-}\ze[/\\]\?$') })
    return map(rs, { _, v -> printf('-reveal=%s', escape(v, ' ')) })
  endif
  let rs = fern#internal#scheme#complete_reveal(scheme, a:arglead, a:cmdline, a:cursorpos)
  return rs is# v:null ? [] : rs
endfunction
