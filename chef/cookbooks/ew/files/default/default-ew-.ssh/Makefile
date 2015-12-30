all: 
	@echo "Create authorized_keys file by running: \`make ak'."
	@echo ""
	@echo "This will OVERWRITE the file \`authorized_keys' with the contents of"
	@echo "  disclaimer authorized_keys.customer authorized_keys.ew authorized_keys.local"
	@echo ""
	@echo "To create the required files, run: \`make files'."
	@echo "This will run \`touch' on:"
	@echo "  disclaimer authorized_keys.customer authorized_keys.ew authorized_keys.local"
	@echo "and fill \`disclaimer' with proper content."

files: 
	touch disclaimer authorized_keys.customer authorized_keys.ew authorized_keys.local
	chmod u=rw,go=r disclaimer authorized_keys.customer authorized_keys.ew authorized_keys.local
	@echo "# This file will be overwritten.  Please edit the appropriate" > disclaimer
	@echo "# source file, e.g. authorized_keys.customer and execute 'make ak'." >> disclaimer

ak: authorized_keys

authorized_keys: disclaimer authorized_keys.customer authorized_keys.ew authorized_keys.local
	cat disclaimer > authorized_keys
	echo '' >> authorized_keys
	sort authorized_keys.customer authorized_keys.ew authorized_keys.local | uniq >> authorized_keys
	chmod u=rw,go= authorized_keys
