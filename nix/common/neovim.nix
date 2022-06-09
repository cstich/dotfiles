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
    yapf
  ]; 
in 

{
  environment.systemPackages = with pkgs; [
    (python3.withPackages myPythonPackages)
    fzf
    yarn
    ctags

    # Telescope
    fd
    ripgrep

    # Tree sitter depenencies
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
      " Vim-rooter plugin 
      """"""""""""""""""""""""""""""""""
      " Switch to project.nvim when it is packaged for nixos
      let g:rooter_patterns = ['.git' ]

      " Find files using Telescope command-line sugar.
      nnoremap <F2> <cmd>Telescope find_files<cr>
      nnoremap <F3> <cmd>Telescope buffers<cr>
      nnoremap <F4> <cmd>Telescope live_grep<cr>

      """"""""""""""""""""""""""""""""""
      " nvim-cmp
      """"""""""""""""""""""""""""""""""
      lua <<EOF
        
        -- Add additional capabilities supported by nvim-cmp
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
        
        local lspconfig = require('lspconfig')
        local luasnip = require('luasnip')

        -- Enable some language servers with the additional completion capabilities offered by nvim-cmp
        local servers = { 'pyright' }
        for _, lsp in ipairs(servers) do
          lspconfig[lsp].setup {
            -- on_attach = my_custom_on_attach,
            capabilities = capabilities,
          }
        end


        local null_ls = require("null-ls")
        local sources = {
          null_ls.builtins.diagnostics.flake8,
          null_ls.builtins.formatting.isort,
          null_ls.builtins.formatting.yapf,
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
        ensure_installed = { "python" },
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
      " lualine
      """"""""""""""""""""""""""""""""""
      lua <<EOF
        require("nvim-gps").setup()
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

    '';
    packages.myVimPackage = with pkgs.vimPlugins; {
      # loaded on launch
      start = [ 
      	bufferline-nvim
        cmp-nvim-lsp
        fzf-vim
        lspkind-nvim
        luasnip
        lualine-nvim
        lualine-lsp-progress
        nvim-cmp
        nvim-gps
        null-ls-nvim
        nvim-lspconfig
        nvim-tree-lua
        nvim-treesitter
        nvim-web-devicons
        onehalf
        packer-nvim
        telescope-nvim
        telescope-project-nvim
        vim-nix
        vim-rooter
        vim-devicons
      ];
      # manually loadable by calling `:packadd $plugin-name`
      opt = [ ];
    };
  };

  };
}
