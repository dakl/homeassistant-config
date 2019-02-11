.ONESHELL:
HASS_VERSION=0.85.1
HASS_IMAGE_RPI=homeassistant/raspberrypi3-homeassistant
HASS_IMAGE_x86=homeassistant/home-assistant

ARCH := $(shell uname -m)
ifeq ($(ARCH), armv7l)
	HASS_IMAGE=$(HASS_IMAGE_RPI)
else
	HASS_IMAGE=$(HASS_IMAGE_x86)
endif
HASS_IMAGE_TAGNAME=$(HASS_IMAGE):$(HASS_VERSION)

dev:
	docker stop hassio-dev 2> /dev/null || echo "No container to stop, skipping..."
	docker rm hassio-dev 2> /dev/null || echo "No container to remove, skipping..."
	docker pull ${HASS_IMAGE_TAGNAME}
	echo "Starting hassio-dev on port 8124"
	docker run --name hassio-dev --restart unless-stopped \
		-e "TZ=Europe/Stockholm" \
		-v ${PWD}/config/configuration.yaml:/config/configuration.yaml \
		-v ${PWD}/config/secrets.yaml:/config/secrets.yaml \
		--mount source=hassio-dev-cloud,target=/config/.cloud \
		--mount source=hassio-dev-storage,target=/config/.storage \
		-p 8123:8123 \
		${HASS_IMAGE_TAGNAME}

start:
	docker stop hassio 2> /dev/null || echo "No container to stop, skipping..."
	docker rm hassio 2> /dev/null || echo "No container to remove, skipping..."
	docker pull ${HASS_IMAGE_TAGNAME}
	docker run --name hassio --restart unless-stopped \
		-e "TZ=Europe/Stockholm" \
		-d \
		-v ${PWD}/config/configuration.yaml:/config/configuration.yaml \
		-v /home/pi/klevan-secrets/hassio/secrets.yaml:/config/secrets.yaml \
		-v /home/pi/klevan-secrets/hassio/.homekit.state:/config/.homekit.state \
		--mount source=hassio-cloud,target=/config/.cloud \
		--mount source=hassio-storage,target=/config/.storage \
		--network="host" \
		${HASS_IMAGE_TAGNAME}

test: 
	docker run --rm -it \
	-e "TZ=Europe/Stockholm" \
	-v ${PWD}/config/configuration.yaml:/config/configuration.yaml \
	-v ${PWD}/config/secrets.yaml:/config/secrets.yaml \
	${HASS_IMAGE_TAGNAME} \
	python -m homeassistant --script check_config -c /config
