(require 'git)
(require 'git-blame)
(add-to-list 'vc-handled-backends 'GIT)

(require 'ack)

(require 'unbound)

(autoload 'screen-lines-mode "screen-lines"
          "Toggle Screen Lines minor mode for the current buffer." t)
(autoload 'turn-on-screen-lines-mode "screen-lines"
          "Turn on Screen Lines minor mode for the current buffer." t)
(autoload 'turn-off-screen-lines-mode "screen-lines"
          "Turn off Screen Lines minor mode for the current buffer." t)

(require 'moinmoin-mode)