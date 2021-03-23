php:
	- cd base-php && docker build -t ciareis/base-php-v2:php-8.0 . --network=host
	- cd base-php && docker build -t ciareis/base-php-v2:latest . --network=host
	- docker push ciareis/base-php-v2:php-8.0
	- docker push ciareis/base-php-v2:latest

php74:
	- cd base-php && docker build -t ciareis/base-php-v2:php-7.4 . --network=host
	- docker push ciareis/base-php-v2:php-7.4

build:
	- cd base-php && docker build -t ciareis/base-php-v2:latest . --network=host
	- cd base-php && docker build -t ciareis/base-php-v2:php-8.0 . --network=host

build74:
	- cd base-php && docker build -t ciareis/base-php-v2:php-7.4 . --network=host
