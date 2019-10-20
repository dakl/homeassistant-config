.ONESHELL:
HASS_VERSION=latest
HASS_IMAGE_RPI=homeassistant/raspberrypi3-homeassistant
HASS_IMAGE_x86=homeassistant/home-assistant

ARCH := $(shell uname -m)
ifeq ($(ARCH), armv7l)
	HASS_IMAGE=$(HASS_IMAGE_RPI)
else
	HASS_IMAGE=$(HASS_IMAGE_x86)
endif
HASS_IMAGE_TAGNAME=$(HASS_IMAGE):$(HASS_VERSION)

test: 
	docker run --rm -it \
	-e "TZ=Europe/Stockholm" \
	-v ${PWD}/configuration.yaml:/config/configuration.yaml \
	-v ${PWD}/dummy-secrets.yaml:/config/secrets.yaml \
	${HASS_IMAGE_TAGNAME} \
	python -m homeassistant --script check_config -c /config
