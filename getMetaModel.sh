#!/bin/bash
fetchMetaModel () {
  cd src
  cd metaModel
  rm -rf $1
  mkdir $1
  cd $1
  curl -O https://microsoft.github.io/language-server-protocol/specifications/lsp/$1/metaModel/metaModel.json
  curl -O https://microsoft.github.io/language-server-protocol/specifications/lsp/$1/metaModel/metaModel.schema.json
  curl -O https://microsoft.github.io/language-server-protocol/specifications/lsp/$1/metaModel/metaModel.ts
  touch README.md
  echo "# Language Server Protocol Version $1" >> README.md
  echo "" >> README.md
  echo "These files were downloaded from:" >> README.md
  echo "https://microsoft.github.io/language-server-protocol/specifications/lsp/$1/metaModel/" >> README.md
  echo "on $(date)" >> README.md
}
fetchMetaModel "3.18"