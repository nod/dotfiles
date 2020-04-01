# sourced on all invocations of shell

machineOS="$(uname -s)"
case "${osguess}" in
	Linux*)   OSGuess=Linux;;
	Darwin*)  OSGuess=Mac;;
esac


# pull in our local secrets
source ~/.secrets/secrets
