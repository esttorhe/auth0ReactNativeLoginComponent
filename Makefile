EDITOR=vim

HELP_FUNC = \
    %help; \
    while(<>) { \
        if(/^([a-z0-9_-]+):.*\#\#(?:@(\w+))?\s(.*)$$/) { \
            push(@{$$help{$$2}}, [$$1, $$3]); \
        } \
    }; \
    print "usage: make [target]\n\n"; \
    for ( sort keys %help ) { \
        print "$$_:\n"; \
        printf("  %-20s %s\n", $$_->[0], $$_->[1]) for @{$$help{$$_}}; \
        print "\n"; \
    }

help: ## This help dialog.
	@IFS=$$'\n' ; \
		help_lines=(`fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##/:/'`); \
		printf '\033[33m'; \
		printf "%-30s %s\n" "Action" "Description" ; \
		printf "%-30s %s\n" "------" "------------" ; \
		for help_line in $${help_lines[@]}; do \
			IFS=$$':' ; \
			help_split=($$help_line) ; \
			help_command=`echo $${help_split[0]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
			help_info=`echo $${help_split[2]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
			printf '\033[36m'; \
			printf "%-30s %s" $$help_command ; \
			printf '\033[0m'; \
			printf "%s\n" $$help_info; \
		done

bundle: ## Retrieves all the GEMS listed on the Gemfile and installs the resulting bundle at \033[35m`./vendor`
	bundle install --path="./vendor"
	npm install react-native

pod: ## Executes the bundled gem \033[35m`cocoapods` \033[0mcommand \033[35m`pod install`. \033[0mInstalls missings pods to the Workdspace
	bundle exec pod install --project-directory=auth0ReactNativeLoginComponent

server: ## Starts the \033[35mReactComponent \033[0mby running \033[35mnpm run start\033[0m
	(JS_DIR=`pwd`/auth0ReactNativeLoginComponent/ReactComponent; cd node_modules/react-native; npm run start -- --root $$JS_DIR)

countLOC: ## Counts the number of lines of code on each class in the project sorted from biggest to smallest.
	find Lovecalls -name "*.swift" -exec wc -l "{}" \; | sort -rn
