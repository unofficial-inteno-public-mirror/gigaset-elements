


all:
	gcc -Wall -o reef_test main.c

clean:
	rm -rf *.[asio]
	rm -r reef_test
