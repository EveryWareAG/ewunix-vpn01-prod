# ew::test
# This is the recipe for testing things.

# Hier kann man auf einer Node im Recipe Sachen testen und dann mit
# /usr/bin/chef-solo -c "$REPO_LOCAL/solo.rb" -j "$CHEF_NODE" -E "$CHEF_ENV" -l debug -o 'recipe[ew::test]'
# ausführen.
# Im Repo sollte das recipe leer sein. Es sollte in keiner role per 
# default aufgerufen werden.

# EOF
