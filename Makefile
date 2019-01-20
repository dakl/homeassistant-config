HASS_VERSION=0.85.1
HASS_IMAGE=homeassistant/raspberrypi3-homeassistant
# HASS_IMAGE=homeassistant/home-assistant
HASS_IMAGE_TAGNAME=$(HASS_IMAGE):$(HASS_VERSION)

start:
	git submodule update --recursive --remote
	docker pull ${HASS_IMAGE_TAGNAME}
	docker run --rm --name hassio \
		-d \
		-e "TZ=Europe/Stockholm" \
		-v ${PWD}/config:/config \
		-p 8123:8123 \
		${HASS_IMAGE_TAGNAME}


test: 
	docker run --rm -it \
	-e "TZ=Europe/Stockholm" \
	-v ${PWD}/config/configuration.yaml:/config/configuration.yaml \
	-v ${PWD}/config/secrets.yaml:/config/secrets.yaml \
	-p 8123:8123 \
	${HASS_IMAGE_TAGNAME} \
	python -m homeassistant --script check_config -c /config
