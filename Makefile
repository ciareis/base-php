php:
	- cd base-php && DOCKER_BUILDKIT=1 docker build -t ciareis/base-php-v2:php-8.0 . --network=host
	- cd base-php && DOCKER_BUILDKIT=1 docker build -t ciareis/base-php-v2:latest . --network=host
	- docker push ciareis/base-php-v2:php-8.0
	- docker push ciareis/base-php-v2:latest

php74:
	- cd base-php && DOCKER_BUILDKIT=1 docker build -t ciareis/base-php-v2:php-7.4 . --network=host
	- docker push ciareis/base-php-v2:php-7.4

build:
	- cd base-php && DOCKER_BUILDKIT=1 docker build -t ciareis/base-php-v2:php-8.0 . --network=host

build74:
	- cd base-php && DOCKER_BUILDKIT=1 docker build -t ciareis/base-php-v2:php-7.4 . --network=host
