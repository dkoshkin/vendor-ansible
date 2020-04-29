VERSION = $(shell cat ansible-version.txt)

all:
	@echo "Making vendored Ansible package for $(VERSION)"
	$(MAKE) python37
	$(MAKE) python36
	$(MAKE) python27
	tar -zcf ansible.tar.gz /ansible

python27:
	docker run --rm \
	-v "$(shell pwd)/ansible/lib/python2.7/":/ansible/lib/python2.7/ \
	-v "$(shell pwd)/ansible/bin/":/ansible/bin/ \
	-w /vendor-ansible \
	mesosphere/vendor-ansible:2.7 \
	pip install --install-option="--prefix=/ansible" ansible==$(VERSION) netaddr jmespath

python36:
	docker run --rm \
	-v "$(shell pwd)/ansible/lib/python3.6/":/ansible/lib/python3.6/ \
	-w /vendor-ansible \
	mesosphere/vendor-ansible:3.6 \
	pip3 install --install-option="--prefix=/ansible" ansible==$(VERSION) netaddr jmespath

python37:
	docker run --rm \
	-v "$(shell pwd)/ansible/lib/python3.7/":/ansible/lib/python3.7/ \
	-w /vendor-ansible \
	mesosphere/vendor-ansible:3.7 \
	pip3 install --install-option="--prefix=/ansible" ansible==$(VERSION) netaddr jmespath

build:
	docker build -t mesosphere/vendor-ansible:2.7 -f Dockerfile.2.7 .
	docker build -t mesosphere/vendor-ansible:3.6 -f Dockerfile.3.6 .
	docker build -t mesosphere/vendor-ansible:3.7 -f Dockerfile.3.7 .

.PHONY: clean
clean:
	rm -rf ansible.tar.gz
	rm -rf /ansible

