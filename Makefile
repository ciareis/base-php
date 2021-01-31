php:
	- cd base-php && docker build -t ciareis/base-php:latest . --network=host
	- docker push ciareis/base-php:latest
	- cd base-php && docker build -t ciareis/base-php:php-8.0 . --network=host
	- docker push ciareis/base-php:php-8.0

php74:
	- cd base-php && docker build -t ciareis/base-php:php-7.4 . --network=host
	- docker push ciareis/base-php:php-7.4

build:
	- cd base-php && docker build -t ciareis/base-php:latest . --network=host
	- cd base-php && docker build -t ciareis/base-php:php-8.0 . --network=host

build74:
	- cd base-php && docker build -t ciareis/base-php:php-7.4 . --network=host
