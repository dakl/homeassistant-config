build:
	docker build -t dakl/home-assistant .

push:
	docker push dakl/home-assistant

run:
	docker run --rm --name hassio \
	-e "TZ=Europe/Stockholm" \
	-v ${PWD}/config:/config \
	-p 8123:8123 \
	homeassistant/home-assistant:0.85.1

test: 
	docker run --rm -it \
	-e "TZ=Europe/Stockholm" \
	-v ${PWD}/config/configuration.yaml:/config/configuration.yaml \
	-v ${PWD}/config/secrets.yaml:/config/secrets.yaml \
	-p 8123:8123 \
	homeassistant/home-assistant:0.85.1 \
	python -m homeassistant --script check_config -c /config
