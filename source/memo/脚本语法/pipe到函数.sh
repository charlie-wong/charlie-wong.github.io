# https://www.baeldung.com/linux/pipe-output-to-function

# - `foo` receives standard input from the process that started it
# - `cat` when used without arguments, redirects its stdin to stdout
foo() { printf "--["; cat; printf "]--\n"; }
echo -n ok | foo # => --[ok]--

# - reference standard input using the file `/dev/stdin` -> `/proc/self/fd/0`
foo() { printf "--["; cat < /dev/stdin; printf "]--\n"; }
echo -n ok | foo # => --[ok]--

# receiving input from a pipe by the `read` utility
foo() { local in; printf "--["; read -r in; echo -n "${in}"; printf "]--\n"; }
echo -n ok | foo # => --[ok]--

function foo() {
  if [ $# -gt 0 ]; then
    echo "[$*]"
  elif [ ! -t 0 ]; then
    cat < /dev/stdin
  fi
}
