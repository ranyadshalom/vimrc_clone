#!/usr/bin/env bash

set -o nounset    # error when referencing undefined variable
set -o errexit    # exit when command fails
# Install latest nodejs
if [ ! -x "$(command -v node)"  ]; then
       curl --fail -LSs https://install-node.now.sh/latest | sh
          export PATH="/usr/local/bin/:$PATH"
             # Or use apt-get
                # sudo apt-get install nodejs
fi
# Use package feature to install coc.nvim
# for vim8
mkdir -p ~/.vim/pack/coc/start
cd ~/.vim/pack/coc/start
curl --fail -L https://github.com/neoclide/coc.nvim/archive/release.tar.gz | tar xzfv -
# for neovim
# mkdir -p ~/.local/share/nvim/site/pack/coc/start
# cd ~/.local/share/nvim/site/pack/coc/start
# curl --fail -L https://github.com/neoclide/coc.nvim/archive/release.tar.gz | tar xzfv -
# Install extensions
mkdir -p ~/.config/coc/extensions
cd ~/.config/coc/extensions
if [ ! -f package.json  ]
then
     echo '{"dependencies":{}}'> package.json
fi
# Change extension names to the extensions you need
npm install coc-snippets --global-style --ignore-scripts --no-bin-links --no-package-lock --only=prod
npm install coc-tsserver --global-style --ignore-scripts --no-bin-links --no-package-lock --only=prod
npm install coc-java --global-style --ignore-scripts --no-bin-links --no-package-lock --only=prod
npm install coc-pyright --global-style --ignore-scripts --no-bin-links --no-package-lock --only=prod
npm install coc-sh --global-style --ignore-scripts --no-bin-links --no-package-lock --only=prod
npm install coc-vimlsp --global-style --ignore-scripts --no-bin-links --no-package-lock --only=prod

# update settings to what I like
echo -n "Copy @ranys defult settings to ~/.vim/coc-settings.json [y/n]"
read answer
if [ "$answer" != "${answer#[Yy]}"  ] ;then
        echo '{
            "python.jediEnabled": false,
            "python.linting.flake8Enabled": true,
            "python.linting.pep8Args": ["--max-line-length=140"],
            "python.linting.flake8Args": ["--max-line-length=140"],
            "python.linting.flake8Path": "flake8",
            "python.formatting.autopep8Path": "autopep8",
            "python.linting.enabled": true,
            "python.linting.pylintEnabled": true,
            "python.analysis.memory.keepLibraryAst": true,
            "java.home": "/usr/lib/jvm/java-11-amazon-corretto.x86_64",
            "solargraph.diagnostics": false,
            "solargraph.autoformat": true,
            "solargraph.formatting": true,
            "solargraph.hover": true,
            "snippets.snipmate.enable": false,
            "snippets.ultisnips.enable": false,
            "coc.source.around.enable": false,
            "coc.source.buffer.enable": false,
            "java.jdt.ls.vmargs": "-noverify -Xmx4G -XX:+UseG1GC -XX:+UseStringDeduplication",
            "java.completion.maxResults": 50,
            "java.foldingRange.enabled": true
        }' > ~/.vim/coc-settings.json
    else
        echo "Did not copy default settings."
fi
