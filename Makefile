.PHONY: tests
.SILENT:
.DEFAULT_GOAL: help

help:
	echo "Please use \`make \033[36m<target>\033[0m\`"
	echo "\t where \033[36m<target>\033[0m is one of"
	grep -E '^\.PHONY: [a-zA-Z_-]+ .*?## .*$$' $(MAKEFILE_LIST) \
		| sort | awk 'BEGIN {FS = "(: |##)"}; {printf "• \033[36m%-30s\033[0m %s\n", $$2, $$3}'

.PHONY: build ## 🚀 build the Docker image
build:
	docker build -t ai-sandbox .

.PHONY: run ## ▶️ run the Docker containers (docker-compose up)
run:
	docker-compose up -d

.PHONY: shell ## 🐚 open a bash shell inside the running container
shell:
	docker-compose up -d --build && docker exec -it ai-sandbox bash
