'use strict'

// usage :
// conventional-changelog -p angular -n scripts/conventional_config.js > OUTPUT.md

module.exports = {
  parserOpts: {
    headerPattern: /^(\w*)(?:\((.*)\))?!?: (.*)$/,
  }
}
