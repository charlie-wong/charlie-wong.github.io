# NOTE Bash can only `return` from function or sourced script,
# but it works well in zsh for none function or sourced script
#
# - if no return, then return the last execute command exit code
# - return is a bash builtin command, valid number between [0, 255]

# return number from shell function
function return-number() {
  # some handling
  return 0
}

# return string from shell function
function return-string() {
  # some handling
  echo "this is return data"
}

# return string from shell function
function return-number-and-string() {
  # some handling
  echo "this is return data"
  return 52
}

# capture return number
return-number
echo "return number=[$?]"

# capture return string
rdata="$(return-string)"
echo "return string=[${rdata}]"

# capture both: number and string
rdata="$(return-number-and-string)"
echo "return number=[$?]"
echo "return string=[${rdata}]"
