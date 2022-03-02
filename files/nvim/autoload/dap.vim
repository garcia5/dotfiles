function! dap#shutdown() abort
    lua require('dap').terminate()
    lua require('dapui').close()
endfunction
