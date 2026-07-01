vim.bo.formatprg = "stylua --search-parent-directories --stdin-filepath " .. vim.fn.shellescape(vim.fn.expand "%:p") .. " -"
