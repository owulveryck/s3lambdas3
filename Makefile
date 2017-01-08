#
# Copyright 2017 Alsanium, SAS. or its affiliates. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

GOPATH ?= $(HOME)/go
HANDLER ?= handler
PACKAGE ?= package

all: $(HANDLER).so $(PACKAGE).zip

$(HANDLER).so: *.go
	go build -buildmode=plugin -ldflags='-w -s' -o $(HANDLER).so
	chown $(shell stat -c '%u:%g' .) $(HANDLER).so

$(HANDLER)/shim.so: $(HANDLER)/*.go $(HANDLER)/*.c
	cd $(HANDLER)
	go build -buildmode=plugin -ldflags='-w -s' -o shim.so

$(PACKAGE).zip: $(HANDLER)/shim.so $(HANDLER).so $(HANDLER)/*
	zip -q $(PACKAGE).zip $(HANDLER).so
	zip -q -r $(PACKAGE).zip $(HANDLER)/shim.so $(HANDLER)/*.py
	chown $(shell stat -c '%u:%g' .) $(PACKAGE).zip

clean:
	@rm $(PACKAGE).zip $(HANDLER).so
