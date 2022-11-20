{pkgs, ...}:

let
  # Import unstable channel.
  # sudo nix-channel --add http://nixos.org/channels/nixos-unstable nixos-unstable
  # sudo nix-channel --update nixos-unstable
  unstable = import <nixos-unstable> {};
  myPythonPackages = pythonPackages: with pythonPackages; [
    cookiecutter
    flake8
    isort
    pylint
    yapf
  ]; 
in 

{
  environment.systemPackages = with pkgs; [
    (python3.withPackages myPythonPackages)
    fzf
    yarn
    ctags

    neovide

    # Telescope
    fd
    ripgrep

    # Tree sitter depenencies
    clang
    tree-sitter
    git
    curl

    # Python language server
    nodePackages.pyright
    ];

  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
    defaultEditor = true;

  configure = {
    customRC = ''
      """""""""""""""""""""""""""""""""""""""
      " General settings
      """""""""""""""""""""""""""""""""""""""
      " Keybindings

      " Sane moving between window panes
      nnoremap <c-j> <c-w>j
      nnoremap <c-k> <c-w>k
      nnoremap <c-h> <c-w>h
      nnoremap <c-l> <c-w>l

      " Use <leader>l to toggle display of whitespace
      nmap <leader>l :set list!<CR>

      noremap <F5> :ALEGoToDefinition<CR>
      noremap <F6> :Autoformat<CR>

      "Always show current position
      set ruler
      " Ignore case when searching
      set ignorecase
      " When searching try to be smart about cases
      set smartcase
      " set show matching parenthesis
      set showmatch
      " insert tabs on the start of a line according to
      " shiftwidth, not tabstop
      set smarttab
      " Highlight search results
      set hlsearch
      " Makes search act like search in modern browsers
      set incsearch
      " Don't redraw while executing macros (good performance config)
      set lazyredraw
      " Show hybrid line numbers
      set number relativenumber
      set nu rnu
      
      set hidden " LSP needed this
      set tabstop=4
      set shiftwidth=4
      set expandtab
      set autoindent " Always set autoindenting on
      set copyindent " Copy the previous indentation
      set noswapfile " disable swapfile usage
      set autochdir " automatically change window's cwd to file's dir
      
      " mouse scrolling
      set mouse=a
      
      " for command mode
      nmap <Tab> >>
      nmap <S-Tab> <<
      
      " for insert mode
      imap <S-Tab> <Esc><<
      
      " Display all trailing white space
      set list
      
      " change <leader>
      let mapleader = "\<Space>"
      " let maplocalleader = "\\"
      let maplocalleader = "\<Space>"
      
      " Always draw the signcolumn.
      set signcolumn=yes
      
      " show a visual line under the cursor's current line
      set cursorline
      
      " show the matching part of the pair for [] {} and ()
      set showmatch

      """"""""""""""""""""""""""""""""""
      " Colors and formatting
      """"""""""""""""""""""""""""""""""
      
      " Enable syntax highlighting
      syntax enable
      
      " Set colorscheme 
      set termguicolors     " enable true colors support
      colorscheme onehalflight
      
      " Airline settings
      " let g:airline_theme='onehalflight'
      " let g:airline_powerline_fonts = 1
      " let g:airline#extensions#tabline#enabled = 1
      
      " Use Unix as the standard file type
      set fileformat=unix
      
      " Powerline setup
      set laststatus=2
      
      " Override vim's autodetectionn of colors
      set t_Co=256

      """"""""""""""""""""""""""""""""""
      " vim-slime
      """"""""""""""""""""""""""""""""""
      let g:slime_target = "tmux"
      let g:slime_default_config = {"socket_name": "default", "target_pane": "{last}"}

      """"""""""""""""""""""""""""""""""
      " Vim-rooter plugin 
      """"""""""""""""""""""""""""""""""
      " Switch to project.nvim when it is packaged for nixos
      let g:rooter_patterns = ['.git', 'Cargo.toml' ]

      """"""""""""""""""""""""""""""""""
      " Telescope plugin 
      """"""""""""""""""""""""""""""""""
      " Find files using Telescope command-line sugar.
      nnoremap <F3> <cmd>Telescope buffers<cr>
      nnoremap <F4> <cmd>Telescope live_grep<cr>
      lua require('telescope').setup{defaults = {file_ignore_patterns = {"target/", ".*parquet.*", ".git/"}}}

      """"""""""""""""""""""""""""""""""
      " nvim-lspconfig 
      """"""""""""""""""""""""""""""""""
      lua << EOF
        local lspconfig = require('lspconfig')
        -- Mappings for LSP via nvim-lspconfig.
        -- See `:help vim.diagnostic.*` for documentation on any of the below functions
        local opts = { noremap=true, silent=true }
        vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
        vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
        vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
        vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
        
        -- Use an on_attach function to only map the following keys
        -- after the language server attaches to the current buffer
        local on_attach = function(client, bufnr)
          -- Enable completion triggered by <c-x><c-o>
          vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
        
          -- Mappings.
          -- See `:help vim.lsp.*` for documentation on any of the below functions
          local bufopts = { noremap=true, silent=true, buffer=bufnr }
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
          vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
          vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
          vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
          vim.keymap.set('n', '<space>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, bufopts)
          vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
          vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
          vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
          vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)

          -- TODO Update to newer API once NixOS ships neovim 0.8
          -- https://github.com/jose-elias-alvarez/null-ls.nvim/wiki/Avoiding-LSP-formatting-conflicts
          if client.name == "rust_analyzer" then                                                                                                   
            client.server_capabilities.document_formatting = false -- 0.7 and earlier
            -- client.server_capabilities.documentFormattingProvider = false -- 0.8 and later
          end
        end

        -- Add additional capabilities supported by nvim-cmp
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
        
        local lspconfig = require('lspconfig')
        local luasnip = require('luasnip')

        -- Enable some language servers with the additional completion capabilities offered by nvim-cmp
        local servers = { 'pyright', 'rust_analyzer' }
        for _, lsp in ipairs(servers) do
          lspconfig[lsp].setup {
            -- use the on_attach function defined above
            on_attach = on_attach, 
            capabilities = capabilities,
          }
        end
      EOF

      """"""""""""""""""""""""""""""""""
      " nvim-cmp & nvim-lspconfig
      """"""""""""""""""""""""""""""""""
      lua <<EOF
        
        -- TODO Refactor null-ls part
        local null_ls = require("null-ls")
        local sources = {
          null_ls.builtins.diagnostics.pylint,
          null_ls.builtins.formatting.isort,
          null_ls.builtins.formatting.yapf.with {
            args = {"--style='{based_on_style: google, column_limit: 120}'"}  
          },
        }

        -- Make sure only null-ls is used for formatting
        local lsp_formatting = function(bufnr)
            vim.lsp.buf.format({
                filter = function(client)
                    -- apply whatever logic you want (in this example, we'll only use null-ls)
                    return client.name == "null-ls"
                end,
                bufnr = bufnr,
            })
        end
        
        -- Format on save
        local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
        null_ls.setup({
          sources = sources,
          on_attach = function(client, bufnr)
            if client.supports_method("textDocument/formatting") then
                vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                vim.api.nvim_create_autocmd("BufWritePre", {
                    group = augroup,
                    buffer = bufnr,
                    callback = function()
                        -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
                        vim.lsp.buf.formatting_sync()
                    end,
                })
            end
          end,
        })
      
        -- TODO Re-work the snippet part   
        local luasnip = require('luasnip')
        local cmp = require('cmp')
        local lspkind = require('lspkind')
        cmp.setup {
          
           window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
              },
          
          snippet = {
            expand = function(args)
              luasnip.lsp_expand(args.body)
            end,
          },

          mapping = cmp.mapping.preset.insert({
            ['<C-d>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<CR>'] = cmp.mapping.confirm {
              behavior = cmp.ConfirmBehavior.Replace,
              select = true,
            },
            ['<Tab>'] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
              else
                fallback()
              end
            end, { 'i', 's' }),
            ['<S-Tab>'] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
              else
                fallback()
              end
            end, { 'i', 's' }),
          }),

          formatting = {
            format = lspkind.cmp_format(),
          },

          sources = {
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
          }
        }

      EOF

      """"""""""""""""""""""""""""""""""
      " treesitter 
      """"""""""""""""""""""""""""""""""

      lua <<EOF
      require'nvim-treesitter.configs'.setup {
        ensure_installed = { },
        sync_install = false,
        ignore_install = { "" },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        -- Use treesitter for navigating the AST
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<CR>",
            node_incremental = "<CR>",
            scope_incremental = "<TAB>",
            node_decremental = "<S-TAB>",
          },
        },
      }

      EOF

      """"""""""""""""""""""""""""""""""
      " treesitter-textobjects
      """"""""""""""""""""""""""""""""""

      lua <<EOF
      require'nvim-treesitter.configs'.setup {
        textobjects = {
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              ["]f"] = "@function.outer",
              ["]c"] = "@class.outer",
              ["]a"] = "@parameter.inner",
            },
            goto_next_end = {
              ["]F"] = "@function.outer",
              ["]C"] = "@class.outer",
              ["]A"] = "@parameter.outer",
            },
            goto_previous_start = {
              ["[f"] = "@function.outer",
              ["[c"] = "@class.outer",
              ["[a"] = "@parameter.inner",
            },
            goto_previous_end = {
              ["[F"] = "@function.outer",
              ["[C"] = "@class.outer",
              ["[A"] = "@parameter.outer",
            },
          },
        },
      }
      EOF

      """"""""""""""""""""""""""""""""""
      " lualine
      """"""""""""""""""""""""""""""""""
      lua <<EOF
        require('lualine').setup {
          options = {
            theme = "onelight",
          },

          sections = {
            lualine_c = {
              'lsp_progress'
            }
          }
        }
      EOF

      """"""""""""""""""""""""""""""""""
      " Other lua plugins setup
      """"""""""""""""""""""""""""""""""
      lua require('nvim-tree').setup{renderer = {icons = {webdev_colors = true}}}
      lua require('bufferline').setup{}

      """"""""""""""""""""""""""""""""""
      " lualine
      """"""""""""""""""""""""""""""""""
      lua << EOF
      require("which-key").setup {
        plugins = {
          presets = {
            operators = false,
            motions = false,
            text_objects = false,
            windows = false,
            nav = false,
            z = false,
            g = false,
          }
        }
      }

      local wk = require("which-key")

      wk.register({
          b = { "<cmd>bn<cr>", "Next buffer" },
          c = { "Next class start" },
          C = { "Next class end" },
          f = { "Next function start" },
          F = { "Next function end" },
          a = { "Next argument start" },
          A = { "Next argument end" },
          s = { "Next misspelled word" },
          ["%"] = { "Match parenthesis forward" },
          ["]"] = { "Jump forward"}, 
      }, { prefix = "]"})

      wk.register({
          b = { "<cmd>bp<cr>", "Previous buffer" },
          c = { "Previous class start" },
          C = { "Previous class end" },
          f = { "Previous function start" },
          F = { "Previous function end" },
          a = { "Previous argument start" },
          A = { "Previous argument end" },
          s = { "Previous misspelled word" },
          ["%"] = { "Match parenthesis backward" },
          ["["] = { "Jump backward"}, 
        }, { prefix = "["})

        wk.register({
        a = {
          name = "aerial",
          a = {"<cmd>AerialToggle<cr>", "Toggle"},
          ["["] = {"<cmd>AerialPrev<cr>", "Previous"},
          ["]"] = {"<cmd>AerialNext<cr>", "Next"},
        },
        f = {
            name = "file",
            f = {"<cmd>Telescope find_files<cr>", "Find file"},
            o = {"<cmd>Telescope oldfiles<cr>", "Open recent file"},
            n = {":! touch ", "New file"},
            d = {":! mkdir ", "New directory"},
          },
        h = {
           name = "history",
           c = {"<cmd>Telescope command_history<cr>", "Command history"},
           s = {"<cmd>Telescope search_history<cr>", "Search history"},
         },
        b = {
          name = "buffers",
          b = {"<cmd>Telescope buffers<cr>", "List buffers"},
          n = { "<cmd>bn<cr>", "Next buffer" },
          p = { "<cmd>bp<cr>", "Previous buffer" },
        },
        x = {
          name = "trouble",
          x = {"<cmd>TroubleToggle<cr>", "Toggle"},
          w = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "Workspace"},
          d = { "<cmd>TroubleToggle document_diagnostics<cr>", "Document"},
          q = { "<cmd>TroubleToggle quickfix<cr>", "Quickfix"},
          l = { "<cmd>TroubleToggle loclist<cr>", "Loclist"},
        },
 
        s = {
          name = "search",
          b = {"<cmd>Telescope current_buffer_fuzzy_find<cr>", "Search in buffer"},
          c = {"<cmd>Telescope command_history<cr>", "Command history"},
          f = {"<cmd>Telescope live_grep<cr>", "Search through files"},
          h = {"<cmd>Telescope search_history<cr>", "Search history"},
          h = {"<cmd>Telescope search_history<cr>", "Search history"},
          s = {"<cmd>Telescope treesitter<cr>", "Search symbols"},
          w = {"<cmd>Telescope grep_string<cr>", "Search for word"},
        },
      }, { prefix = "<leader>" })
      EOF

        l = {
          name = "LSP",
          l = {"<cmd>TroubleToggle<cr>", "Show diagnostics"},

      require("lualine").setup({
        sections = {
          lualine_x = { "aerial" },
        },
      })

      EOF



      """"""""""""""""""""""""""""""""""
      " Trouble
      """"""""""""""""""""""""""""""""""
      lua << EOF
      require('trouble').setup({})

      EOF





    '';
    packages.myVimPackage = with pkgs.vimPlugins; {
      # loaded on launch
      start = [ 
        aerial-nvim
        bufferline-nvim
        cmp-nvim-lsp
        fzf-vim
        lspkind-nvim
        luasnip
        lualine-nvim
        lualine-lsp-progress
        nvim-cmp
        null-ls-nvim
        nvim-lspconfig
        nvim-tree-lua
        nvim-treesitter-textobjects
        (nvim-treesitter.withPlugins (
          plugins: with plugins; [
            tree-sitter-bash
            tree-sitter-java
            tree-sitter-nix
            tree-sitter-python
            tree-sitter-rust
          ]
        ))
        nvim-web-devicons
        onehalf
        packer-nvim
        telescope-nvim
        telescope-project-nvim
        trouble-nvim
        vim-nix
        vim-rooter
        vim-devicons
        vim-slime
        which-key-nvim
      ];
      # manually loadable by calling `:packadd $plugin-name`
      opt = [ ];
    };
  };
  };
}
