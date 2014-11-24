

INCLUDE_PATHS = \
		-I$(STAGING_DIR)/usr/include/natalie-dect/ \
		-I$(STAGING_DIR)/usr/include/natalie-dect/Phoenix

all:
	$(CC) $(LDFLAGS) $(INCLUDE_PATHS) -o reef_test main.c



clean:
	rm -rf *.[asio]
	rm -r reef_test

