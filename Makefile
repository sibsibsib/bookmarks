.PHONY: version release release_builder infra_builder infra_shell


release: release_builder
	docker run -v $$(pwd):/src bookmarks:builder /release.sh


release_shell: release_builder
	docker run --rm -i -t -v $$(pwd):/src bookmarks:builder bash


release_builder:
	docker build --rm=true -t bookmarks:builder ./release


infra_shell: infra_builder
	docker run --rm --cap-add SYS_ADMIN --name nomad -p 8080:8080 -p 8081:8081 -p 4646:4646 -p 8500:8500 -p 9999:9999 -p 9998:9998 -i -t -v $$(pwd):/src sib:infra bash


infra_builder:
	docker build --rm=true -t sib:infra ./infra

