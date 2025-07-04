PY?=python3
PELICAN?=pelican
PELICANOPTS=

BASEDIR=$(CURDIR)
INPUTDIR=$(BASEDIR)/content
OUTPUTDIR=$(BASEDIR)/output
CONFFILE=$(BASEDIR)/pelicanconf.py
PUBLISHCONF=$(BASEDIR)/publishconf.py

FTP_HOST=localhost
FTP_USER=anonymous
FTP_TARGET_DIR=/

SSH_HOST=localhost
SSH_PORT=22
SSH_USER=root
SSH_TARGET_DIR=/var/www

S3_BUCKET=my_s3_bucket

CLOUDFILES_USERNAME=my_rackspace_username
CLOUDFILES_API_KEY=my_rackspace_api_key
CLOUDFILES_CONTAINER=my_cloudfiles_container

DROPBOX_DIR=~/Dropbox/Public/

GITHUB_PAGES_BRANCH=gh-pages
GITHUB_CNAME=qrk.us
GITHUB_PAGES_REMOTE=origin
GITHUB_SOURCE_BRANCH=main

KEYBASE_ROOT=/keybase
KEYBASE_USER=kourier

DEBUG ?= 0
ifeq ($(DEBUG), 1)
	PELICANOPTS += -D
endif

RELATIVE ?= 0
ifeq ($(RELATIVE), 1)
	PELICANOPTS += --relative-urls
endif

help:
	@echo 'Makefile for a pelican Web site                                           '
	@echo '                                                                          '
	@echo 'Usage:                                                                    '
	@echo '   make html                           (re)generate the web site          '
	@echo '   make clean                          remove the generated files         '
	@echo '   make regenerate                     regenerate files upon modification '
	@echo '   make publish                        generate using production settings '
	@echo '   make serve [PORT=8000]              serve site at http://localhost:8000'
	@echo '   make serve-global [SERVER=0.0.0.0]  serve (as root) to $(SERVER):80    '
	@echo '   make devserver [PORT=8000]          start/restart develop_server.sh    '
	@echo '   make stopserver                     stop local server                  '
	@echo '   make ssh_upload                     upload the web site via SSH        '
	@echo '   make rsync_upload                   upload the web site via rsync+ssh  '
	@echo '   make dropbox_upload                 upload the web site via Dropbox    '
	@echo '   make ftp_upload                     upload the web site via FTP        '
	@echo '   make s3_upload                      upload the web site via S3         '
	@echo '   make cf_upload                      upload the web site via Cloud Files'
	@echo '   make github                         upload the web site via gh-pages   '
	@echo '   make keybase                        rsync to kbfs/public/$KEYBASE_USER '
	@echo '                                                                          '
	@echo 'Set the DEBUG variable to 1 to enable debugging, e.g. make DEBUG=1 html   '
	@echo 'Set the RELATIVE variable to 1 to enable relative urls                    '
	@echo '                                                                          '

html:
	$(PELICAN) $(INPUTDIR) -o $(OUTPUTDIR) -s $(CONFFILE) $(PELICANOPTS)

clean:
	[ ! -d $(OUTPUTDIR) ] || rm -rf $(OUTPUTDIR)

regenerate:
	$(PELICAN) -r $(INPUTDIR) -o $(OUTPUTDIR) -s $(CONFFILE) $(PELICANOPTS)

serve:
ifdef PORT
	cd $(OUTPUTDIR) && $(PY) -m pelican.server $(PORT)
else
	cd $(OUTPUTDIR) && $(PY) -m pelican.server
endif

serve-global:
ifdef SERVER
	cd $(OUTPUTDIR) && $(PY) -m pelican.server 80 $(SERVER)
else
	cd $(OUTPUTDIR) && $(PY) -m pelican.server 80 0.0.0.0
endif


SERVER_PID = $(BASEDIR)/pelican.pid
SERVER_LOG = $(BASEDIR)/pelican.log

startserver: stopserver
	@echo "Starting Pelican server..."
	set -m; \
	$(PELICAN) \
		--debug \
		--autoreload \
		--output $(OUTPUTDIR) \
		--settings $(CONFFILE) \
		--listen \
		--port $(or $(PORT),8000) \
		$(PELICANOPTS) \
		$(INPUTDIR) > "$(SERVER_LOG)" 2>&1 & \
	echo $$! > "$(SERVER_PID)"
	@echo "Pelican server started (PID: $$(cat $(SERVER_PID)))"
	@( xdg-open http://localhost:$(or $(PORT),8000) 2>/dev/null || \
	   open http://localhost:$(or $(PORT),8000) 2>/dev/null || \
	   echo "Open http://localhost:$(or $(PORT),8000) in your browser" ) &

# Alias for backward compatibility
devserver: startserver

stopserver:
	@if [ -f "$(SERVER_PID)" ]; then \
		PID=$$(cat "$(SERVER_PID)"); \
		if ps -p $$PID >/dev/null 2>&1; then \
			echo "Stopping Pelican server (PID: $$PID)"; \
			pkill -P $$PID 2>/dev/null || true; \
			kill $$PID 2>/dev/null || true; \
			while ps -p $$PID >/dev/null 2>&1; do \
				sleep 0.5; \
			done; \
			echo 'Pelican server stopped.'; \
		else \
			echo 'Pelican server was not running (stale PID file).'; \
		fi; \
		rm -f "$(SERVER_PID)" "$(SERVER_LOG)"; \
	else \
		echo 'No Pelican server is currently running (no PID file).'; \
	fi;
	# Additional cleanup in case of any remaining processes
	pkill -f "pelican.*pelicanconf\.py" 2>/dev/null || true

publish:
	pip install --upgrade --requirement $(BASEDIR)/requirements.txt
	$(PELICAN) $(INPUTDIR) -o $(OUTPUTDIR) -s $(PUBLISHCONF) $(PELICANOPTS)

ssh_upload: publish
	scp -P $(SSH_PORT) -r $(OUTPUTDIR)/* $(SSH_USER)@$(SSH_HOST):$(SSH_TARGET_DIR)

rsync_upload: publish
	rsync -e "ssh -p $(SSH_PORT)" -P -rvzc --delete $(OUTPUTDIR)/ $(SSH_USER)@$(SSH_HOST):$(SSH_TARGET_DIR) --cvs-exclude

dropbox_upload: publish
	cp -r $(OUTPUTDIR)/* $(DROPBOX_DIR)

ftp_upload: publish
	lftp ftp://$(FTP_USER)@$(FTP_HOST) -e "mirror -R $(OUTPUTDIR) $(FTP_TARGET_DIR) ; quit"

s3_upload: publish
	s3cmd sync $(OUTPUTDIR)/ s3://$(S3_BUCKET) --acl-public --delete-removed --guess-mime-type --no-mime-magic --no-preserve

cf_upload: publish
	cd $(OUTPUTDIR) && swift -v -A https://auth.api.rackspacecloud.com/v1.0 -U $(CLOUDFILES_USERNAME) -K $(CLOUDFILES_API_KEY) upload -c $(CLOUDFILES_CONTAINER) .

github: publish
	git fetch $(GITHUB_PAGES_REMOTE) $(GITHUB_PAGES_BRANCH)
	ghp-import --push --message "Generate Pelican site" --branch $(GITHUB_PAGES_BRANCH) --remote $(GITHUB_PAGES_REMOTE) --cname $(GITHUB_CNAME) $(OUTPUTDIR)
	git push origin $(GITHUB_SOURCE_BRANCH)

keybase: publish
	rsync --recursive \
	 			--checksum \
				--itemize-changes \
				--cvs-exclude \
				--delete-excluded \
				--stats \
				$(OUTPUTDIR)/ \
				$(KEYBASE_ROOT)/public/$(KEYBASE_USER)/


.PHONY: html help clean regenerate serve serve-global devserver stopserver publish ssh_upload rsync_upload dropbox_upload ftp_upload s3_upload cf_upload github
