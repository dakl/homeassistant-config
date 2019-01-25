HASS_VERSION=0.85.1
HASS_IMAGE=homeassistant/raspberrypi3-homeassistant
# HASS_IMAGE=homeassistant/home-assistant
HASS_IMAGE_TAGNAME=$(HASS_IMAGE):$(HASS_VERSION)

start:
	docker stop hassio 2> /dev/null || echo "No container to stop, skipping..."
	docker rm hassio 2> /dev/null || echo "No container to remove, skipping..."
	docker pull ${HASS_IMAGE_TAGNAME}
	docker run --name hassio --restart unless-stopped \
		-e "TZ=Europe/Stockholm" \
		-d \
		-v ${PWD}/config/configuration.yaml:/config/configuration.yaml \
		-v ${PWD}/config/secrets.yaml:/config/secrets.yaml \
		--mount source=hassio-cloud,target=/config/.cloud \
		--mount source=hassio-storage,target=/config/.storage \
		-p 8123:8123 \
		${HASS_IMAGE_TAGNAME}

test: 
	docker run --rm -it \
	-e "TZ=Europe/Stockholm" \
	-v ${PWD}/config/configuration.yaml:/config/configuration.yaml \
	-v ${PWD}/config/secrets.yaml:/config/secrets.yaml \
	${HASS_IMAGE_TAGNAME} \
	python -m homeassistant --script check_config -c /config
