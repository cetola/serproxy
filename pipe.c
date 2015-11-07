/*
 * pipe.c
 *
 * serial port <-> TCP/IP piping
 *
 * (C)1999 Stefano Busti
 *
 */

#include <stdlib.h>

#include "pipe.h"

int pipe_init(pipe_s *pipe, int sock_port)
{
	if (sio_init(&pipe->sio))
		return -1;

	if (tcp_init(&pipe->sock, sock_port))
		return -1;

	pipe->mutex = malloc(sizeof(thr_mutex_t));
	*(pipe->mutex) = thr_mutex_create();
	
	return 0;
}

void pipe_cleanup(pipe_s *pipe)
{
	sio_cleanup(&pipe->sio);
	tcp_cleanup(&pipe->sock);
	thr_mutex_unlock(pipe->mutex);
	thr_mutex_destroy(pipe->mutex);
	free(pipe->mutex);
}

void pipe_destroy(void *data)
{
	pipe_s *pipe = (pipe_s *)data;

	pipe_cleanup(pipe);
	free(pipe);
}
