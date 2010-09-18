
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/select.h>
#include <sys/wait.h>
#include <unistd.h>
#include <stdio.h>
#include <errno.h>
#include <string.h>
#include <libgen.h>
#include <netinet/in.h>
#include <netinet/ip.h>
#include <time.h>

#define EXEC_PATH "/home/owen/src/little-stuff/service-event/start-service"
#define PORT 8000

int service_listen(void);
int start_service(void);

int service_listen(void) {
	int sock;
	fd_set read_set;
	int status;
	
	struct sockaddr_in addr = {
		.sin_family   = AF_INET,
		.sin_port     = htons(PORT),
		.sin_addr     = { INADDR_ANY }
	};
	
	sock = socket(AF_INET, SOCK_STREAM, 0);
	if (sock == -1) {
		fprintf(stderr, "Failed to create listening socket: %s\n",
			strerror(errno));
		
		return -1;
	}
	
	status = bind(sock, (struct sockaddr*)&addr, sizeof(addr));
	if (status == -1) {
		fprintf(stderr, "Failed to bind() socket: %s\n",
			strerror(errno));
		
		return -1;
	}
	
	status = listen(sock, 2);
	if (status == -1) {
		fprintf(stderr, "Error in listen(): %s\n",
			strerror(errno));
		
		return -1;
	}
	
	FD_ZERO(&read_set);
	FD_SET(sock, &read_set);
	
	for (;;) {
		printf("selecting.........\n");
		fflush(stdout);
		
		status = select(sock+1, &read_set, NULL, NULL, NULL);
		
		printf("select returned!! %d\n", status);
		fflush(stdout);
		
		if (status == 0) continue;
		
		if (status == -1) {
			fprintf(stderr, "Failed on select(): %s\n",
				strerror(errno));
			return -1;
		}
		
		break;
	}
	
	status = close(sock);
	if (status == -1) {
		fprintf(stderr, "Failed to close() socket: %s\n",
			strerror(errno));
		return -1;
	}
	
	start_service();
	
	return 0;
}

int start_service() {
	int pid;
	int status;
	const char *exec_name;
	
	exec_name = basename(EXEC_PATH);
	
	pid = fork();

	if (pid == -1) {
		fprintf(stderr, "Failed to fork(): %s\n", strerror(errno));
		return -1;
	}

	else if (pid) {
		waitpid(pid, NULL, 0);
	}
	else {
		status = execl(EXEC_PATH, exec_name, (const char*)NULL);
		
		if (status == -1) {
			fprintf(stderr, "Failed to execl(%s): %s\n",
				EXEC_PATH,
				strerror(errno));
			return -1;
		}
	}

	return 0;
}

int main(int argc, char **argv) {
	return service_listen();
}

