#! /bin/sh

. tests/common/header.sh

##################
# Make git repo. #
##################

mkdir -p -- "$MIYKA_ROOT/temporary/repo1"
cd -- "$MIYKA_ROOT/temporary/repo1"
git init
git config user.name name
git config user.email email
echo hello > file1.txt
echo '
miyka-initialize:
	ln -sT $(PWD)/file1.txt "$(MIYKA_REPO_HOME)/file1.txt"
' > Makefile
git add --all
git commit --message "initial commit"
cd -

###########
# Use it. #
###########

t_miyka create test-project

echo "(git \"file://$PWD/$MIYKA_ROOT/temporary/repo1\") (move-home) (install \"coreutils\") (install \"dash\")" \
     > "$MIYKA_ROOT/repositories/test-project/wd/home/.config/miyka/configuration.lisp"

if test -f "$MIYKA_ROOT/repositories/test-project/wd/home/file1.txt"
then exit 1
fi

t_miyka run test-project

if ! test -f "$MIYKA_ROOT/repositories/test-project/wd/home/file1.txt"
then exit 1
fi
