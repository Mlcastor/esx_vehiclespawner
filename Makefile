#--------------------------------------------------------------------
# ESX Resource Template – Makefile
#--------------------------------------------------------------------
# Requires:
#   • stylua          – code formatter
#   • luacheck        – linter
#   • busted          – (optional) Lua unit-test framework
#   • release-please  – semantic-release CLI (npm i -g release-please)
#
# Usage examples:
#   make lint           # run luacheck
#   make format         # auto-format Lua files with stylua
#   make test           # run unit tests via busted
#   make release        # create changelog + GitHub release (CI)
#   make                # alias for 'ci' (lint + test)
#--------------------------------------------------------------------

# Directories -------------------------------------------------------
SRC    := $(shell find client server shared -type f -name "*.lua")
TESTS  := $(shell find tests -type f -name "*.lua")

# Tool commands (override via env var if needed) --------------------
STYLUA      ?= stylua
LUALINT     ?= luacheck
TEST_RUNNER ?= busted
RELEASE_CLI ?= release-please

#--------------------------------------------------------------------
# Targets
#--------------------------------------------------------------------

.PHONY: help
help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?##' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?##"}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

# -------- Formatting & Linting ------------------------------------

.PHONY: format
format: ## Format Lua sources with stylua
	$(STYLUA) .

.PHONY: lint
lint: ## Lint Lua sources with luacheck
	$(LUALINT) $(SRC)

# -------- Testing --------------------------------------------------

.PHONY: test
test: ## Run unit tests (busted)
	@if [ -n "$(TESTS)" ]; then \
		$(TEST_RUNNER) --output=tap $(TESTS); \
	else \
		echo "No tests defined – skipping"; \
	fi

# -------- Continuous Integration ----------------------------------

.PHONY: ci
ci: lint test ## Lint + test (default for CI)

.PHONY: default
default: ci   ## Alias for CI when you just run `make`

# -------- Release --------------------------------------------------

.PHONY: release
release: ## Create changelog + GitHub release via release-please
	$(RELEASE_CLI) github release-pr --token $$GITHUB_TOKEN
	# In CI you usually follow with:
	# release-please github release --token $GITHUB_TOKEN

# -------- Packaging (optional) ------------------------------------

.PHONY: package
package: ## Zip resource for manual distribution
	@echo "Packaging resource…"
	@zip -qr dist/$(shell basename `pwd`)-$(shell date +%Y%m%d).zip \
		client server shared locales html* *.lua *.md fxmanifest.lua

# -------- Tooling bootstrap (optional) ----------------------------

.PHONY: install-tools
install-tools: ## Install Lua tooling via luarocks / npm
	luarocks install luacheck
	curl -L https://github.com/JohnnyMorganz/StyLua/releases/latest/download/stylua-linux-x86_64.zip -o stylua.zip
	unzip stylua.zip -d /usr/local/bin && rm stylua.zip
	npm i -g release-please