" packadd quickscope

" execute 'luafile ' . stdpath('config') . '/lua/settings.lua'
function! s:manageEditorSize(...)
  let count = a:1
  let to = a:2
  for i in range(1, count ? count : 1)
      call VSCodeNotify(to == 'increase' ? 'workbench.action.increaseViewSize' : 'workbench.action.decreaseViewSize')
  endfor
endfunction

augroup highlight_yank
  autocmd!
  autocmd TextYankPost * silent! lua vim.highlight.on_yank({timeout = 200})
augroup END


function! s:vscodeCommentary(...) abort
  if !a:0
      let &operatorfunc = matchstr(expand('<sfile>'), '[^. ]*$')
      return 'g@'
  elseif a:0 > 1
      let [line1, line2] = [a:1, a:2]
  else
      let [line1, line2] = [line("'["), line("']")]
  endif

  call VSCodeCallRange("editor.action.commentLine", line1, line2, 0)
endfunction

function! s:openVSCodeCommandsInVisualMode()
  normal! gv
  let visualmode = visualmode()
  if visualmode == "V"
      let startLine = line("v")
      let endLine = line(".")
      call VSCodeNotifyRange("workbench.action.showCommands", startLine, endLine, 1)
  else
      let startPos = getpos("v")
      let endPos = getpos(".")
      call VSCodeNotifyRangePos("workbench.action.showCommands", startPos[1], endPos[1], startPos[2], endPos[2], 1)
  endif
endfunction

function! s:openWhichKeyInVisualMode()
  normal! gv
  let visualmode = visualmode()
  if visualmode == "V"
      let startLine = line("v")
      let endLine = line(".")
      call VSCodeNotifyRange("whichkey.show", startLine, endLine, 1)
  else
      let startPos = getpos("v")
      let endPos = getpos(".")
      call VSCodeNotifyRangePos("whichkey.show", startPos[1], endPos[1], startPos[2], endPos[2], 1)
  endif
endfunction

"  -- Press 'H', 'L' to jump to start/end of a line (first/last char)
nnoremap L $
nnoremap H ^


nnoremap gr <Cmd>call VSCodeNotify('editor.action.goToReferences')<CR>
" Bind C-/ to vscode commentary since calling from vscode produces double comments due to multiple cursors
xnoremap <expr> <C-/> <SID>vscodeCommentary()
nnoremap <expr> <C-/> <SID>vscodeCommentary() . '_'
nnoremap <silent> <C-w>_ :<C-u>call VSCodeNotify('workbench.action.toggleEditorWidths')<CR>
nnoremap <silent> <Space> :call VSCodeNotify('whichkey.show')<CR>
xnoremap <silent> <Space> :<C-u>call <SID>openWhichKeyInVisualMode()<CR>
xnoremap <silent> <C-P> :<C-u>call <SID>openVSCodeCommandsInVisualMode()<CR>
xmap gc  <Plug>VSCodeCommentary
nmap gc  <Plug>VSCodeCommentary
omap gc  <Plug>VSCodeCommentary
nmap gcc <Plug>VSCodeCommentaryLine
" Simulate same TAB behavior in VSCode
nmap <Tab> :Tabnext<CR>
nmap <S-Tab> :Tabprev<CR>
set clipboard=unnamedplus
