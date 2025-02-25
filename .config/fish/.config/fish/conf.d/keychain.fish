if status is-login
  and status is-interactive
  # to add a key:
  # set -Ua SSH_KEYS_TO_AUTOLOAD keypath
  # to remove a key:
  # set -U --erase SSH_KEYS_TO_AUTOLOAD[index]
  keychain --eval $SSH_KEYS_TO_AUTOLOAD | source
end
