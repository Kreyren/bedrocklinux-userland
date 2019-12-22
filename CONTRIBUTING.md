This project is heavy on sanitization and portability that's why you are expected to follow these directives

Every merge request has to pass linting (https://en.wikipedia.org/wiki/Lint_(software)) otherwise your merge request will be closed on review unless you are submiting it as a part of mentoring program in which this should be stated in the original post.

# How to contribute

### Do a fact check
If you find something that is not true, then your are encouraged to make an issue or merge request with reasoning to be evaluated

### FIXMEs
Fixing 'FIXME' in the code is always welcomed.

### Educate the community
If you are confident in your abilities and if you are open-minded about informations that you are providing (to make sure that the informations that you are providing are accurate) then you are encouraged to educate the community.

### Make maintainers richer
Throwing money on maintainers (not literally i learned my lesson) also counts as a contribution.

# C lang
### General
- FIXME: info needed

# non-POSIX/POSIX shell/bash
### General
- Write the script to be POSIX-compatible unless there is a good reason to use non-POSIX shell/bash

If we can't use POSIX shell -> provide a reasoning in the code.

This is for portability in case we need to use said script on POSIX system assuming that everything excluding complicated RegEx can be done on POSIX.

- Write a code on triger -> action bases
```sh
# Unwanted
rm something
# Wanted
  [ -e something ] && rm something
# ^^^^^^^^^^^^^^^^^^^ - Trigger
#                     ^^^^^^^^^^^^ - Action
```

Reasoning being sanitization to avoid unexpected action

- Output helpful messages

```sh
# Unwanted
mv something nothing || exit 1

# Wanted
mv something nothing || die 1 "Unable to move 'something' to 'nothing' which is required for reasons"
```

This is done so that maintainers can avoid talking to the end-user at all cost when they report an issue which usually wastes lots of time and is **more likely** to cause a confusion.

If you contribute a code you should expect an output **only** to know what is the issue in case your code causes a regression.

- 'echo' is banned
Command echo is not allowed in this repository, use `printf '%s\n' "msg"` instead

Reasoning being
- reliability on POSIX and non-standard systems (https://unix.stackexchange.com/a/65819)
- slight runtime advantage in favor of printf (https://unix.stackexchange.com/a/77564)

### Variables
- Avoid unnecesary curly brackets
```sh
test="hello"
# Unwanted
printf '%s\n' "${test}"
# Wanted
printf '%s\n' "$test"

# Acceptable
printf '%s\n' "${test}world"
#                    ^ if we removed curly brackets here it would make it into a $testworld which is unexpected
```

### If statements
- Avoid using `test` -> use square brackets '[]'
```sh
# Unwanted
if test -e something; then ...
# Wanted
if [ -e something ]; then ...
```

Reasoning being readability

- Avoid using -o/-a in if statements
```sh
# Unwanted
if [ true ] -a [ false ]; then ...
# Wanted
if [ true ] && [ false ]; then ...
```

Reasoning being readability

- Using 'else' is not allowed
```sh
# Unwanted
if true; then
	someting
else
	nothing
fi
# Wanted
if true; then
	someting
elif false; then
	nothing
else
	die 255 "Identification of codeblock"
fi
```

This is used for sanitization and Quality Assurance so that if you write a logic that doesn't match the else statement will trigger
