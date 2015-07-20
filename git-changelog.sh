#!/bin/sh
# Git-changelog by @michaelschultz
# michaelschultz.com


# INSTRUCTIONS:
# Run on current git respoitory with $ bash git-changelog.sh
#
# $ bash git-changelog -open to open changelog after generation
# $ bash git-changelog -force to generate new changelog if you get stuck in a weird state


# Examples of well designed changelogs
# - https://www.firebase.com/docs/ios/changelog.html


# START GIT-CHANGELOG SHELL SCRIPT
# 
# Checks to see if changelog was already updated by checking previous commit
look_for_changelog_commit() {
  if git show --name-only | grep -q -ci changelog.html;
  then
    exit 0
  fi

  # Only need to do this check if not being called from the git commit-msg hook
  # if [ -d .git ]; then
  #   echo working;
  # else
  #   echo No git repository found;
  #   git rev-parse --git-dir 2> /dev/null;
  #	  exit 0;
  # fi;
}

# Adds updated changelog to current commit
git_add() {
  git add changelog.html
  git commit --amend
}

# Locate config file
git_log() {
  # add --reverse to start with first commit
  git log --pretty=format:'<li><span class="commit">%s</span> <span class="date">%cd</span></li> ' --shortstat --date=local >> changelog.html
}

git_total_commits() {
  # grabs total number of commits
  TOTAL_COMMITS="$(git rev-list HEAD --count)"

cat <<-ENDCOUNT >> changelog.html
<h2>Total commits: $TOTAL_COMMITS</h2>
ENDCOUNT
}

# Generate html
generate_html() {
# no indent due to cat syntax limitations.
# this cat block creates the changlog.html file or overwrites the current one.
cat <<-BLOCK > changelog.html
<html> 
<head>
<title>Git Changelog</title>
<style>
  body {
    color: #cccccc;
    font-family: "HelveticaNeue-Light", "Helvetica Neue Light", "Helvetica Neue", Helvetica, Arial, "Lucida Grande", sans-serif;
    font-size: 14px;
    font-weight: 300;
    margin: 20px 20px 100px 20px;
    padding: 0;
  }
  h1, h2 {
    color: #cccccc;
    font-family: "HelveticaNeue-Light", "Helvetica Neue Light", "Helvetica Neue", Helvetica, Arial, "Lucida Grande", sans-serif;
    font-size: 38px;
    font-weight: 300;
    padding: 0 0 0 20px;
    margin-top: 0;
    margin-bottom: 0;
  }
  h2 {
  	padding-top: 5px;
  	padding-left: 22px;
  	font-size: 16px;
  }
  .changelog {
    margin: 0 auto;
    max-width: 900px;
  }
  .commit {
  	flex: 4;
  	padding: 10px 10px 10px 20px;
  }
  .date {
  	background: #ffffff;
  	border-radius: 0 4px 4px 0;
  	flex: 1;
  	font-size: 12px;
  	padding: 10px;
  	text-align: right;
    color: #66CE83;
  }
  ul {
    border-left: 1px solid #dddddd;
    list-style: none;
    margin-top: 4em;
    padding-left: 34px;
  }
  ul li {
  	align-items: center;
  	display: flex;
    border-color: #dddddd;
    border-radius: 4px;
    border-style: solid;
    border-width: 1px 1px 1px 4px;
    color: #3F3F3F;
    font-size: 16px;
    margin: 25px 0 10px -13px;
  }
  li:before {
    background: #ffffff;
    color: #cccccc;
    content: "\2022 ";
    font-size: 18px;
    margin-left: -40px;
    padding: 0 10px;
  }
  li:last-child {
  	margin-top: 60px;
  }
  .footer {
  	color: cccccc;
  	font-family: "HelveticaNeue-Light", "Helvetica Neue Light", "Helvetica Neue", Helvetica, Arial, "Lucida Grande", sans-serif;
  	text-align: center;
    font-size: 15px;
    font-weight: 300;
    margin: 4em 0;
  }
</style>
</head>
<body>
<div class="changelog">
<h1>Changelog</h1>
BLOCK

  git_total_commits

cat <<-BLOCK >> changelog.html
<ul>
BLOCK

  git_log

cat <<-BLOCK >> changelog.html
</ul>
</div>
<div class="footer">
  <p>beginning of something awesome</p>
</div>
</body>
</html>
BLOCK
}

# open changelog
open_changelog() {
  # makes extra sure that the file opens in a the default browser window
  open changelog.html -a "$(VERSIONER_PERL_PREFER_32_BIT=true perl -MMac::InternetConfig -le 'print +(GetICHelper "http")[1]')"
}


case "$1" in
  "-force" | "-f")
    generate_html
    ;;
  "-open" | "-o")
    look_for_changelog_commit
    generate_html
    git_add
    open_changelog
    ;;
  *)

  look_for_changelog_commit
  generate_html
  git_add
esac
exit 0

# FINISHED