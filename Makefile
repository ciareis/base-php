php:
	- cd base-php && DOCKER_BUILDKIT=1 docker build -t ciareis/base-php-v3:php-8.0 . --network=host
#	- cd base-php && DOCKER_BUILDKIT=1 docker build -t ciareis/base-php-v3:latest . --network=host
	- docker push ciareis/base-php-v3:php-8.0
#	- docker push ciareis/base-php-v3:latest

php74:
	- cd base-php && DOCKER_BUILDKIT=1 docker build -t ciareis/base-php-v3:php-7.4 . --network=host
	- docker push ciareis/base-php-v3:php-7.4

build:
	- cd base-php && DOCKER_BUILDKIT=1 docker build -t ciareis/base-php-v3:php-8.0 . --network=host

build74:
	- cd base-php && DOCKER_BUILDKIT=1 docker build -t ciareis/base-php-v3:php-7.4 . --network=host
