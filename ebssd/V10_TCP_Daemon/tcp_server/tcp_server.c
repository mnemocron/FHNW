#include <stdlib.h>    // system()
#include <stdio.h>     // printf
#include <unistd.h>    // gethostname
#include <error.h>      // generate error output
#include <errno.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/socket.h>
#include <sys/signal.h>
#include <fcntl.h>
#include <signal.h>     // sigint handling
#include <netinet/tcp.h>
#include <netdb.h>
#include <string.h>     // memset
#include <arpa/inet.h>  // htons

#define DEVICENODE "/dev/mod_hrtimer_dev"
#define MAXPUF 1023
#define IN_PORT 32768

int fd_hrtim;
int IDPartnerSocket;  // global to close on abbort

void sigintHandler(int);
void handle_connection(int);

int main( int argc, char **argv ) {

    signal(SIGINT, sigintHandler);

    int IDMySocket;
    struct sockaddr_in AdrMySock, AdrPartnerSocket;
    struct servent *Service;
    int AdrLen;

    memset(&AdrMySock, sizeof(struct sockaddr_in), 0);
    memset(&AdrPartnerSocket, sizeof(struct sockaddr_in), 0);

    printf("opening /dev/mod_hrtimer_dev...\n");
    fd_hrtim = open(DEVICENODE, O_RDONLY);
    if(fd_hrtim < 0){
        error(-1, errno, "Unable to open /dev/mod_hrtimer_dev\n");
    }

    printf("creating socket...\n");
    IDMySocket = socket(AF_INET, SOCK_STREAM, 0);
    /* bind Socket to port number */
    AdrMySock.sin_family = AF_INET;
    AdrMySock.sin_addr.s_addr = INADDR_ANY;   // accept any address
    /* Select Port */
    printf("selecting port...\n");
    Service = getservbyname("hilfe","tcp");
    // AdrMySock.sin_port = Service->s_port;
    AdrMySock.sin_port = htons(IN_PORT);
    printf("listening on: localhost: %d...\n", IN_PORT);
    bind(IDMySocket, (const struct sockaddr*) &AdrMySock, sizeof(AdrMySock));
    listen(IDMySocket, 5);

    int count = 0;
    while(1){
        int opt = 1;
        IDPartnerSocket = accept(IDMySocket, (struct sockaddr*) &AdrPartnerSocket, &AdrLen);
        setsockopt(IDPartnerSocket, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt));
        

        printf("new client connected...\n");
        handle_connection(IDPartnerSocket);
        printf("client disconnected, closing...\n");


        close(IDPartnerSocket);
        count ++;
    }
}

void handle_connection(int sock_id)
{
    int n = 0;
    int MsgLen;
    char Puffer[MAXPUF];
    for(int i=0; i<MAXPUF;i++)
        Puffer[i] = 0;

    MsgLen = recv(sock_id, Puffer, MAXPUF, 0);
    if(MsgLen < 0)
        error(-1, errno, "Error reading from client\n");
    else
        printf("rcv (%d): %s\n", n, Puffer);
    // clear buffer again
    do{
        for(int i=0; i<MAXPUF;i++)
            Puffer[i] = 0;

        int er = read(fd_hrtim, &Puffer, sizeof(Puffer)/sizeof(char));
        if(er < 0)
            error(-1, errno, "Error reading /dev/mod_hrtimer_dev\n");
        printf("hrtim: %s\n", Puffer);

        MsgLen = recv(sock_id, Puffer, MAXPUF, 0);
        if(MsgLen < 1)
            return;
        send(sock_id, Puffer, strnlen((const char *)&Puffer, MAXPUF), 0);   
        n++;
    } while(1);
}

/* on CTRL+C abort --> uninit led and button */
void sigintHandler(int sig_num)
{
    signal(SIGINT, sigintHandler);

    printf("closing /dev/mod_hrtimer_dev...\n");
    close(fd_hrtim);
    printf("closing socket...\n");
    close(IDPartnerSocket);

    printf("\n");
    fflush(stdout);
    exit(0);
}
