CC=gcc

all: main

main: main.c
	$(CC) -o main *.c

debug: main.c
	$(CC) -g -o main *.c



# # Variables

# CC=gcc


# # Commands

# # Running "make" will execute all, which will execute main, which will execute main.o
# all: main

# main: main.o
# 	$(CC) -o main main.o

# main.o: main.c
# 	$(CC) -c main.c

# clean:
# # rm existe que sur linux
# 	rm -f *.o main